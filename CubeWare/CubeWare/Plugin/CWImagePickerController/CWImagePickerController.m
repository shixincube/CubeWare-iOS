//
//  CWImagePickerControllerViewController.m
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWImagePickerController.h"
#import "CWPhotoPickerController.h"
#import "CWPhotoPreviewController.h"
#import "CWCustomAlertView.h"
#import "CWAssetModel.h"
#import "CWAssetCell.h"
#import "UIView+NCubeWare.h"
#import "CWImageManager.h"
#import "CubeWareHeader.h"
@interface CWImagePickerController (){
    NSTimer *_timer;
    UILabel *_tipLable;
    BOOL _pushToPhotoPickerVc;
    UIButton *_progressHUD;
    UIView *_HUDContainer;
    UIActivityIndicatorView *_HUDIndicatorView;
    UILabel *_HUDLable;
}

@end

@implementation CWImagePickerController

- (void)setCurrentImageLength:(NSInteger)currentImageLength{
    if (currentImageLength > 0) {
        _currentImageLength = currentImageLength;
    }else{
        _currentImageLength = 0;
    }
}

-(CGSize)imageSize{
    if (_imageSize.width == 0 && _imageSize.height == 0) {
        _imageSize = CGSizeMake(4096, 4096);
    }
    return _imageSize;
}

-(NSInteger)imageLength{
    if (_imageLength == 0) {
        _imageLength = NSIntegerMax;
    }
    return _imageLength;
}

-(NSInteger)totalImageLength{
    if (_totalImageLength == 0) {
        _totalImageLength = NSIntegerMax;
    }
    return _totalImageLength;
}

- (NSString *)confirmTitle{
    if (!_confirmTitle || !_confirmTitle.length) {
        _confirmTitle = @"发送";
    }
    return _confirmTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.translucent = YES;
    [CWImageManager manager].shouldFixOrientation = NO;
    
    // Default appearance, you can reset these after this method
    // 默认的外观，你可以在这个方法后重置
    self.oKButtonTitleColorNormal   = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0];
    self.oKButtonTitleColorDisabled = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5];
    
    if (IOS7) {
        self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIBarButtonItem *barItem;
#ifdef __IPHONE_9_0
    barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[CWImagePickerController class]]];
#else
    barItem = [UIBarButtonItem appearanceWhenContainedIn:[CWImagePickerController class], nil];
#endif
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x8a8fa4);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideProgressHUD];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<CWImagePickerControllerDelegate>)delegate {
    CWAlbumPickerController *albumPickerVc = [[CWAlbumPickerController alloc] init];
    self = [super initWithRootViewController:albumPickerVc];
    if (self) {
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 5; // Default is 5 / 默认最大可选5张图片
        self.pickerDelegate = delegate;
        self.selectedModels = [NSMutableArray array];
        
        // Allow user picking original photo and video, you also can set No after this method
        // 默认准许用户选择原图和视频, 你也可以在这个方法后置为NO
        self.allowPickingOriginalPhoto = YES;
        //        self.allowPickingOriginalPhoto = NO;
        self.allowPickingVideo = YES;
        self.allowPickingImage = YES;
        self.allowTakePicture = YES;
        self.timeout = 15;
        self.photoWidth = 828.0;
        self.photoPreviewMaxWidth = 600;
        
        if (![[CWImageManager manager] authorizationStatusAuthorized]) {
            _tipLable = [[UILabel alloc] init];
            _tipLable.frame = CGRectMake(8, 0, self.view.cw_width - 16, 300);
            _tipLable.textAlignment = NSTextAlignmentCenter;
            _tipLable.numberOfLines = 0;
            _tipLable.font = [UIFont systemFontOfSize:16];
            _tipLable.textColor = [UIColor blackColor];
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
            _tipLable.text = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
            [self.view addSubview:_tipLable];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:YES];
        } else {
            [self pushToPhotoPickerVc];
        }
    }
    return self;
}

/// This init method just for previewing photos / 用这个初始化方法以预览图片
- (instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets selectedPhotos:(NSMutableArray *)selectedPhotos index:(NSInteger)index{
    CWPhotoPreviewController *previewVc = [[CWPhotoPreviewController alloc] init];
    self = [super initWithRootViewController:previewVc];
    if (self) {
        self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        self.allowPickingOriginalPhoto = YES;
        self.timeout = 15;
        self.photoWidth = 828.0;
        self.maxImagesCount = selectedAssets.count;
        self.photoPreviewMaxWidth = 600;
        
        previewVc.photos = [NSMutableArray arrayWithArray:selectedPhotos];
        previewVc.currentIndex = index;
        __weak typeof(self) weakSelf = self;
        [previewVc setOkButtonClickBlockWithPreviewType:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (weakSelf.didFinishPickingPhotosHandle) {
                weakSelf.didFinishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return self;
}

- (void)observeAuthrizationStatusChange {
    if ([[CWImageManager manager] authorizationStatusAuthorized]) {
        [self pushToPhotoPickerVc];
        [_tipLable removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)pushToPhotoPickerVc {
    _pushToPhotoPickerVc = YES;
    if (_pushToPhotoPickerVc) {
        CWPhotoPickerController *photoPickerVc = [[CWPhotoPickerController alloc] init];
        [[CWImageManager manager] getCameraRollAlbum:self.allowPickingVideo allowPickingImage:self.allowPickingImage completion:^(CWAlbumModel *model) {
            photoPickerVc.model = model;
            [self pushViewController:photoPickerVc animated:YES];
            _pushToPhotoPickerVc = NO;
        }];
    }
}

- (void)showAlertWithTitle:(NSString *)title {
    [CWCustomAlertView showNormalAlertWithTitle:@"" message:title leftTitle:@"" rightTitle:@"我知道了" hanle:^(NSString *buttonTitle) {
        if ([buttonTitle isEqualToString:@"我知道了"]) {
            
        }
    }];
}

- (void)showProgressHUD {
    if (!_progressHUD) {
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.frame = CGRectMake((self.view.cw_width - 120) / 2, (self.view.cw_height - 90) / 2, 120, 90);
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        _HUDLable = [[UILabel alloc] init];
        _HUDLable.frame = CGRectMake(0,40, 120, 50);
        _HUDLable.textAlignment = NSTextAlignmentCenter;
        _HUDLable.text = @"正在处理...";
        _HUDLable.font = [UIFont systemFontOfSize:15];
        _HUDLable.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLable];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    [_HUDIndicatorView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD];
    
    // if over time, dismiss HUD automatic
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideProgressHUD];
    });
}

- (void)hideProgressHUD {
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}

- (void)setTimeout:(NSInteger)timeout {
    _timeout = timeout;
    if (timeout < 5) {
        _timeout = 5;
    } else if (_timeout > 60) {
        _timeout = 60;
    }
}

- (void)setPhotoPreviewMaxWidth:(CGFloat)photoPreviewMaxWidth {
    _photoPreviewMaxWidth = photoPreviewMaxWidth;
    if (photoPreviewMaxWidth > 800) {
        _photoPreviewMaxWidth = 800;
    } else if (photoPreviewMaxWidth < 500) {
        _photoPreviewMaxWidth = 500;
    }
    [CWImageManager manager].photoPreviewMaxWidth = _photoPreviewMaxWidth;
}

- (void)setSelectedAssets:(NSMutableArray *)selectedAssets {
    _selectedAssets = selectedAssets;
    _selectedModels = [NSMutableArray array];
    for (id asset in selectedAssets) {
        CWAssetModel *model = [CWAssetModel modelWithAsset:asset type:CWAssetModelMediaTypePhoto];
        model.isSelected = YES;
        [_selectedModels addObject:model];
    }
}

- (void)setAllowPickingImage:(BOOL)allowPickingImage {
    _allowPickingImage = allowPickingImage;
    NSString *allowPickingImageStr = _allowPickingImage ? @"1" : @"0";
    [[NSUserDefaults standardUserDefaults] setObject:allowPickingImageStr forKey:@"CW_allowPickingImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAllowPickingVideo:(BOOL)allowPickingVideo {
    _allowPickingVideo = allowPickingVideo;
    NSString *allowPickingVideoStr = _allowPickingVideo ? @"1" : @"0";
    [[NSUserDefaults standardUserDefaults] setObject:allowPickingVideoStr forKey:@"CW_allowPickingVideo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (IOS7) viewController.automaticallyAdjustsScrollViewInsets = NO;
    if (_timer) { [_timer invalidate]; _timer = nil;}
    
    if (self.childViewControllers.count > 0) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 50, 44)];
        [backButton setImage:[UIImage imageNamed:@"img_return_normal"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"img_return_selected"] forState:UIControlStateSelected];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:UIColorFromRGB(0x8a8fa4) forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [backButton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:animated];
}

@end


@interface CWAlbumPickerController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *albumArr;
@end

@implementation CWAlbumPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"照片";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    rightItem.tintColor = UIColorFromRGB(0x8a8fa4);
    self.navigationItem.rightBarButtonItem = rightItem;
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
    [imagePickerVc hideProgressHUD];
    if (_albumArr) {
        for (CWAlbumModel *albumModel in _albumArr) {
            albumModel.selectedModels = imagePickerVc.selectedModels;
        }
        [_tableView reloadData];
    } else {
        [self configTableView];
    }
}

- (void)configTableView {
    CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
    [[CWImageManager manager] getAllAlbums:imagePickerVc.allowPickingVideo allowPickingImage:imagePickerVc.allowPickingImage completion:^(NSArray<CWAlbumModel *> *models) {
        _albumArr = [NSMutableArray arrayWithArray:models];
        for (CWAlbumModel *albumModel in _albumArr) {
            albumModel.selectedModels = imagePickerVc.selectedModels;
        }
        if (!_tableView) {
            CGFloat top = 44;
            if (IOS7) top += 20;
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.cw_width, self.view.cw_height - top) style:UITableViewStylePlain];
            _tableView.rowHeight = 70;
            _tableView.tableFooterView = [[UIView alloc] init];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [_tableView registerClass:[CWAlbumCell class] forCellReuseIdentifier:@"CWAlbumCell"];
            [self.view addSubview:_tableView];
        } else {
            [_tableView reloadData];
        }
    }];
}

#pragma mark - Click Event

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [imagePickerVc.pickerDelegate imagePickerControllerDidCancel:imagePickerVc];
    }
    if (imagePickerVc.imagePickerControllerDidCancelHandle) {
        imagePickerVc.imagePickerControllerDidCancelHandle();
    }
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CWAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CWAlbumCell"];
    CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
    cell.selectedCountButton.backgroundColor = imagePickerVc.oKButtonTitleColorNormal;
    cell.model = _albumArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CWPhotoPickerController *photoPickerVc = [[CWPhotoPickerController alloc] init];
    CWAlbumModel *model = _albumArr[indexPath.row];
    photoPickerVc.model = model;
    __weak typeof(self) weakSelf = self;
    [photoPickerVc setBackButtonClickHandle:^(CWAlbumModel *model) {
        [weakSelf.albumArr replaceObjectAtIndex:indexPath.row withObject:model];
    }];
    [self.navigationController pushViewController:photoPickerVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
