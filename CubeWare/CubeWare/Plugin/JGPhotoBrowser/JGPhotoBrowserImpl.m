//
//  JGPhotoBrowserImpl.m
//  JGPhotoBrowser
//
//  Created by Mei Jigao on 2017/11/24.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

#import "JGPhotoBrowserImpl.h"
#import "JGSourceBase.h"
#import "JGPhoto.h"
#import "JGPhotoView.h"
#import "JGPhotoToolbar.h"
#import "JGPhotoExtraBar.h"
#import "FLAnimatedImageView+WebCache.h"
#import <objc/runtime.h>
#import <Photos/Photos.h>
#import "JGPhotoStatusView.h"
#import "CWResourceUtil.h"
#import "CWActionSheet.h"
#import "CWToastUtil.h"

#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface JGPhotoBrowser () <UIScrollViewDelegate, JGPhotoViewDelegate,CWActionSheetDelegate>

// 所有的图片对象
@property (nonatomic, strong) NSArray<JGPhoto *> *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentIndex;
// 保存按钮
@property (nonatomic, assign) NSUInteger showSaveBtn;
// 显示浮层
@property (nonatomic, assign) BOOL showTools;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, strong) NSMutableSet<JGPhotoView *> *visiblePhotoViews;
@property (nonatomic, strong) NSMutableSet<JGPhotoView *> *reusablePhotoViews;
@property (nonatomic, strong) JGPhotoToolbar *toolbar;
@property (nonatomic, strong) JGPhotoStatusView *statusView;
@property (nonatomic, strong) JGPhotoExtraBar *extraBar;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation JGPhotoBrowser

static const char JGPhotoBrowserWindowKey = '\0';

/**
 内存管理处理，全局管理内存，外部不需要管理内存
 */
static NSMutableArray<JGPhotoBrowser *> *showingBrowser = nil;

#pragma mark - init
- (instancetype)initWithPhotos:(NSArray<JGPhoto *> *)photos index:(NSInteger)curIndex {
    return [self initWithPhotos:photos index:curIndex showSave:YES];
}

- (instancetype)initWithPhotos:(NSArray<JGPhoto *> *)photos index:(NSInteger)curIndex showSave:(BOOL)showSaveBtn {
    
    self = [super init];
    if (self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            showingBrowser = [[NSMutableArray alloc] init];
        });
        
        _showTools = YES;
        _photos = photos;
        _currentIndex = curIndex;
        _showSaveBtn = showSaveBtn;
        
        [self initDatas];
    }
    
    return self;
}

- (void)initDatas {
    
    [_photos enumerateObjectsUsingBlock:^(JGPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.index = idx;
    }];
}

- (void)dealloc {
    
    //JGLog(@"<%@: %p>", NSStringFromClass([self class]), self);
}

#pragma mark - Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewElements];
}

#pragma mark - Control
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return [self photoBrowserWindow].alpha == 1.f;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - View
- (void)setupViewElements {
    
    // mask
    self.view.backgroundColor = [UIColor blackColor];
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    _maskView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [self.view addSubview:_maskView];
    
    // scroll
    _photoScrollView = [[UIScrollView alloc] init];
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_photoScrollView];
    
    // status
    _statusView = [[JGPhotoStatusView alloc] init];
    [self.view addSubview:_statusView];
    _statusView.hidden = YES;
    
    // tool
    _toolbar = [[JGPhotoToolbar alloc] initWithPhotosCount:_photos.count index:_currentIndex];
    [self.view addSubview:_toolbar];
    
    JGWeak(self);
    _toolbar.showSaveBtn = _showSaveBtn;
    if ([self photoHasExtraText]) {
        _toolbar.closeShowAction = ^{
            JGStrong(self);
            [self closePhotoShow];
        };
    }
    _toolbar.saveShowPhotoAction = ^(NSInteger index) {
        JGStrong(self);
        [self saveCurrentShowPhoto];
    };
    
    // extra
    if ([self photoHasExtraText]) {
        
        _extraBar = [[JGPhotoExtraBar alloc] init];
        [self.view addSubview:_extraBar];
    }
    
    // moreBtn
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[CWResourceUtil imageNamed:@"threedian"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreBtn];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _maskView.frame = self.view.bounds;
    _statusView.frame = self.view.bounds;
    
    _photoScrollView.frame = self.view.bounds;
    CGFloat viewW = CGRectGetWidth(self.view.bounds);
    _photoScrollView.contentSize = CGSizeMake(viewW * _photos.count, 0);
    _photoScrollView.contentOffset = CGPointMake(_currentIndex * viewW, 0);
     UIEdgeInsets safeInsets = [self viewSafeAreaInsets];
    if (_showTools) {
        
        BOOL topTool = [self photoHasExtraText];
       
        _toolbar.frame = CGRectMake(0, topTool ? safeInsets.top : (CGRectGetHeight(self.view.bounds) - 49 - safeInsets.bottom), CGRectGetWidth(self.view.bounds), topTool ? 44 : 49);
        _toolbar.browserSafeAreaInsets = UIEdgeInsetsMake(topTool ? safeInsets.top : 0, 0, topTool ? 0 : safeInsets.bottom, 0);
        
        _extraBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 80 - safeInsets.bottom, CGRectGetWidth(self.view.bounds), 80);
        _extraBar.browserSafeAreaInsets = UIEdgeInsetsMake(0, 0, safeInsets.bottom, 0);
    }
    _moreBtn.frame = CGRectMake(self.view.frame.size.width - 50, 20, 44, 44);
}

- (UIEdgeInsets)viewSafeAreaInsets {
    
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

#pragma mark - Getter
- (BOOL)photoHasExtraText {
    
    for (JGPhoto *photo in _photos) {
        if (photo.extraText.length > 0) {
            return YES;
        }
    }
    return NO;
}

- (UIWindow *)photoBrowserWindow {
    
    UIWindow *window = objc_getAssociatedObject(self, &JGPhotoBrowserWindowKey);
    if (!window) {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        objc_setAssociatedObject(self, &JGPhotoBrowserWindowKey, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return window;
}

//#pragma mark - Show
- (void)show {

    UIWindow *window = [self photoBrowserWindow];
    window.hidden = NO;
    window.alpha = 0;
    window.rootViewController = self;
    [self.view layoutIfNeeded];

    //初始化数据
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [showingBrowser addObject:self];

    _visiblePhotoViews = _visiblePhotoViews ?: [NSMutableSet set];
    _reusablePhotoViews = _reusablePhotoViews ?: [NSMutableSet set];

    CGFloat viewW = CGRectGetWidth(self.view.bounds);
    _photoScrollView.contentSize = CGSizeMake(viewW * _photos.count, 0);
    _photoScrollView.contentOffset = CGPointMake(_currentIndex * viewW, 0);

    [self updateTollbarState];
    [self showPhotos];

    //渐变显示
    window.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{

        window.alpha = 1.0;
        [self setNeedsStatusBarAppearanceUpdate];

    } completion:^(BOOL finished) {

    }];
}
- (void)showFromView:(UIView *)view{
    
    UIWindow *window = [self photoBrowserWindow];
    window.hidden = NO;
    window.alpha = 0;
    window.rootViewController = self;
    [self.view layoutIfNeeded];
    
    
    
    //初始化数据
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [showingBrowser addObject:self];
    
    _visiblePhotoViews = _visiblePhotoViews ?: [NSMutableSet set];
    _reusablePhotoViews = _reusablePhotoViews ?: [NSMutableSet set];
    
    CGFloat viewW = CGRectGetWidth(self.view.bounds);
    _photoScrollView.contentSize = CGSizeMake(viewW * _photos.count, 0);
    _photoScrollView.contentOffset = CGPointMake(_currentIndex * viewW, 0);
    
    [self updateTollbarState];
    [self showPhotos];
    
    //渐变显示
    window.alpha = 0;
    
    CGRect rect = [view convertRect:view.bounds toView:nil];
    _photoScrollView.frame = rect;
    _photoScrollView.center = self.view.center;
    [UIView animateWithDuration:0.3 animations:^{
        
        window.alpha = 1.0;
        _photoScrollView.frame = self.view.bounds;;
//        [self setNeedsStatusBarAppearanceUpdate];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showPhotos {
    
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = floorf((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
    firstIndex = MIN(MAX(0, firstIndex), _photos.count - 1);
    lastIndex = MIN(MAX(0, lastIndex), _photos.count - 1);
    
    // 回收不再显示的ImageView
    __block NSInteger photoViewIndex = 0;
    [_visiblePhotoViews enumerateObjectsUsingBlock:^(JGPhotoView * _Nonnull obj, BOOL * _Nonnull stop) {
        
        photoViewIndex = kPhotoViewIndex(obj);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            
            [_reusablePhotoViews addObject:obj];
            [obj removeFromSuperview];
        }
    }];
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        
        if (![self isShowingPhotoViewAtIndex:index]) {
            
            [self showPhotoViewAtIndex:index];
        }
    }
}

//  显示一个图片view
- (void)showPhotoViewAtIndex:(NSInteger)index {
    
    JGPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) {
        
        // 添加新的图片view
        photoView = [[JGPhotoView alloc] init];
    }
    photoView.photoViewDelegate = self;
    
    // 调整当前页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.origin.x = (bounds.size.width * index);
    photoView.tag = kPhotoViewTagOffset + index;
    
    JGPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

//  加载index附近的图片
- (void)loadImageNearIndex:(NSInteger)index {
    
    if (index > 0) {
        
        JGPhoto *photo = _photos[index - 1];
        [[SDWebImageManager sharedManager] loadImageWithURL:photo.url options:(SDWebImageRetryFailed | SDWebImageLowPriority) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            //do nothing
        }];
    }
    
    if (index < _photos.count - 1) {
        
        JGPhoto *photo = _photos[index + 1];
        [[SDWebImageManager sharedManager] loadImageWithURL:photo.url options:(SDWebImageRetryFailed | SDWebImageLowPriority) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            //do nothing
        }];
    }
}

//  index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    
    __block BOOL isShow = NO;
    [_visiblePhotoViews enumerateObjectsUsingBlock:^(JGPhotoView * _Nonnull obj, BOOL * _Nonnull stop) {
        
        isShow = kPhotoViewIndex(obj) == index;
        *stop = isShow;
    }];
    
    return  isShow;
}

// 重用页面
- (JGPhotoView *)dequeueReusablePhotoView {
    
    JGPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        
        [_reusablePhotoViews removeObject:photoView];
    }
    
    return photoView;
}
#pragma mark - ToolBar
- (void)updateTollbarState {
    
    _currentIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    [_toolbar changeCurrentIndex:_currentIndex indexsaved:_photos[_currentIndex].saved];
    _extraBar.text = _photos[_currentIndex].extraText;
}

- (void)closePhotoShow {
    
    UIWindow *window = [self photoBrowserWindow];
    [UIView animateWithDuration:0.3 animations:^{
        
        window.alpha = 0;
        [self setNeedsStatusBarAppearanceUpdate];
        
    } completion:^(BOOL finished) {
        
        window.hidden = YES;
        window.rootViewController = nil;
        [showingBrowser removeObject:self];
    }];
}

- (void)saveCurrentShowPhoto {
    
    JGWeak(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 保存相片到相册
        JGStrong(self);
        PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
        if (authorizationStatus == PHAuthorizationStatusAuthorized) {
            
            [self saveShowingImageToPhotoLibrary];
        }
        else if (authorizationStatus == PHAuthorizationStatusNotDetermined) {
            
            JGWeak(self);
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                JGStrong(self);
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    [self saveShowingImageToPhotoLibrary];
                }
                else {
                    
                    JGWeak(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        JGStrong(self);
                        [self changePhotoStatusViewWithStatus:JGPhotoStatusPrivacy];
                    });
                }
            }];
        }
        else {
            
            JGWeak(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                JGStrong(self);
                [self changePhotoStatusViewWithStatus:JGPhotoStatusPrivacy];
            });
        }
    });
}

- (void)saveShowingImageToPhotoLibrary {
    
    JGWeak(self);
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        JGStrong(self);
        JGPhoto *showPhoto = [self.photos objectAtIndex:self.currentIndex];
        NSData *saveData = showPhoto.GIFImage.data ?: UIImageJPEGRepresentation(showPhoto.image, 1.f);
        if (@available(iOS 9.0, *)) {
            
            PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
            [request addResourceWithType:PHAssetResourceTypePhoto data:saveData options:nil];
        }
        else {
            
            NSString *temporaryFileName = [NSProcessInfo processInfo].globallyUniqueString;
            NSString *temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:temporaryFileName];
            NSURL *temporaryFileURL = [NSURL fileURLWithPath:temporaryFilePath];
            NSError *error = nil;
            [saveData writeToURL:temporaryFileURL options:NSDataWritingAtomic error:&error];
            
            [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:temporaryFileURL];
            [[NSFileManager defaultManager] removeItemAtURL:temporaryFileURL error:nil];
        }
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            JGStrong(self);
            BOOL saved = success && !error ? YES : NO;
            JGPhoto *showPhoto = [self.photos objectAtIndex:self.currentIndex];
            showPhoto.saved = saved ? YES : NO;
            [self.toolbar changeCurrentIndex:self.currentIndex indexsaved:saved];
            if(saved){
                [CWToastUtil showTextMessage:@"已保存至手机本地相册中" andDelay:2.0];
            }else{
                [CWToastUtil showTextMessage:@"保存图片失败" andDelay:2.0];
            }
//            [self changePhotoStatusViewWithStatus:saved ? JGPhotoStatusSaveSuccess : JGPhotoStatusSaveFail];
        });
    }];
}

- (void)changePhotoStatusViewWithStatus:(JGPhotoStatus)status {
    
    _statusView.hidden = NO;
    _statusView.alpha = 1.f;
    [_statusView showWithStatus:status];
    
    JGWeak(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        JGStrong(self);
        [UIView animateWithDuration:0.2 animations:^{
            self.statusView.alpha = 0;
        } completion:^(BOOL finished) {
            self.statusView.hidden = YES;
        }];
    });
}

#pragma mark - JGPhotoViewDelegate
- (void)photoViewImageFinishLoad:(JGPhotoView *)photoView {
    
    [self updateTollbarState];
}

- (void)photoViewSingleTap:(JGPhotoView *)photoView {
    
    if ([self photoHasExtraText]) {
        
        _showTools = !_showTools;
        UIEdgeInsets safeInsets = [self viewSafeAreaInsets];
        
        CGFloat toolY = safeInsets.top, hideY = -(safeInsets.top + CGRectGetHeight(_toolbar.frame));
        CGFloat extraY = CGRectGetHeight(self.view.bounds) - (CGRectGetHeight(self.extraBar.frame) + safeInsets.bottom);
        CGFloat extraHideY = CGRectGetHeight(self.view.bounds);
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.toolbar.frame = CGRectMake(0, self.showTools ? toolY : hideY, CGRectGetWidth(self.toolbar.frame), CGRectGetHeight(self.toolbar.frame));
            self.extraBar.frame = CGRectMake(0, self.showTools ? extraY : extraHideY, CGRectGetWidth(self.extraBar.frame), CGRectGetHeight(self.extraBar.frame));
        }];
    }
    else {
        
        [self closePhotoShow];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self showPhotos];
    [self updateTollbarState];
}

#pragma  mark - CWActionSheetDelegate
- (void)actionSheet:(CWActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){// 发送给朋友
        if (_delegate && [_delegate respondsToSelector:@selector(photoBrowserDidSendFriend:)]) {
            [_delegate photoBrowserDidSendFriend:self.photos[_currentIndex]];
        }
    }else if(buttonIndex == 1){ // 保存到手机
        [self saveCurrentShowPhoto];
    }else{
        
    }
}
#pragma mark - Action
- (void)moreBtnAction{
    CWActionSheet * actionSheet = [[CWActionSheet alloc] initWithTitle:nil buttonTitles:@[@"发送给朋友",@"保存到手机"] redButtonIndex:-1 delegate:self];
    [actionSheet show];
}

#pragma mark - End

@end
