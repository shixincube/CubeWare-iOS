 //
//  CWFilePickerController.m
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWFilePickerController.h"
#import "CWSegmentedControl.h"
#import "CWFileTableViewCell.h"
#import "CWFileCollectionViewCell.h"

#import "CWFileContentModel.h"
#import "CWFilePHAsssetModel.h"
#import "CWAssetModel.h"
#import "CWImageManager.h"
#import "CWAssetCell.h"
#import "AFNetworking.h"
//#import <MWPhotoBrowser.h>
#import "CubeWareHeader.h"
#import "CWUtils.h"
//#import "CWNResourceUtil.h"
//#import "UIView+CWNPresent.h"
//#import "CWNUtils.h"
#import "CWToastUtil.h"
//#import "CWNCustomAlertView.h"
//#import "CWNMessageDBProtocol.h"
//#import "CWNWorkerFinder.h"
#define BottomBarHeight 44.f
#define SegmenteViewHeight 45.f
#define EmptyTipViewMargin 10.f

typedef NS_ENUM (NSInteger ,CWFileSelectedType){
    /**
     *  增加File
     */
    CWFileSelectedAddFileMType = 0,
    /**
     *  增加PHAsset
     */
    CWFileSelectedAddPHAssetType = 1,
    /**
     *  减少File
     */
    CWFileSelectedCutDownFileMType = 2,
    /**
     *  减少PHAsset
     */
    CWFileSelectedCutDownPHAssetType = 3,
};

@interface CWFilePickerController ()<UITableViewDataSource, UITableViewDelegate, CWSegmentedControlDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *emptyTipView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *otherTableView;//其他
@property (nonatomic, strong) UITableView *videoTableView;//视频列表
@property (nonatomic, strong) UICollectionView *collectionView;//图片列表
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *numberLable;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIImageView *numberImageView;
@property (nonatomic, strong) NSMutableArray *filePHAssetArr;
@property (nonatomic, strong) NSMutableArray *filePickerArray;
@property (nonatomic, strong) NSMutableArray *selectedPHAssetArr;
@property (nonatomic, strong) NSMutableArray *selectedFileArr;
@property (nonatomic, strong) NSMutableArray *fileDataSourceArr;
@property (nonatomic, strong) NSMutableArray *statePHAssetArr;
@property (nonatomic, strong) NSMutableArray *stateFileArr;
@property (nonatomic, strong) NSMutableArray *videoDataArr;//视频资源列表
@property (nonatomic, strong) NSMutableArray *stateVideoArr;//视频选中状态列表
@property (nonatomic, strong) NSMutableArray *selectVideoArr;//已选
@property (nonatomic, strong) NSMutableArray *videoDataSourceArr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) CWFilePHAsssetModel *selectedAssetModel;
@property (nonatomic, strong) CWFileManagerModel *selectedFileModel;
@property (nonatomic, strong) CWAlbumModel *model;
@property (nonatomic, assign) CWFileSelectedType selectedType;
@property (nonatomic, assign) long long totalSize;
@property (nonatomic, assign) BOOL isReloadData;
@property (nonatomic, assign) BOOL is24HourSystem;
@property (nonatomic, assign) NSInteger currentIndex;
//@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@end

@implementation CWFilePickerController

- (id)init
{
    self = [super init];
    if (self) {
        _fileDataSourceArr = [[NSMutableArray alloc] init];
        _filePHAssetArr = [[NSMutableArray alloc] init];
        _selectedPHAssetArr = [[NSMutableArray alloc] init];
        _selectedFileArr = [[NSMutableArray alloc] init];
        _statePHAssetArr = [[NSMutableArray alloc] init];
        _stateFileArr = [[NSMutableArray alloc] init];
        _videoDataArr = [[NSMutableArray alloc] init];
        _stateVideoArr = [[NSMutableArray alloc] init];
        _selectVideoArr = [[NSMutableArray alloc] init];
        _videoDataSourceArr = [[NSMutableArray alloc] init];
    }
    return self;
}

//- (MWPhotoBrowser *)photoBrowser{
//    _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    _photoBrowser.displayActionButton = NO;
//    _photoBrowser.enableGrid = YES;
//    _photoBrowser.displayNavArrows = NO;
//    _photoBrowser.zoomPhotosToFill = YES;
//    [_photoBrowser showNextPhotoAnimated:YES];
//    [_photoBrowser showPreviousPhotoAnimated:YES];
//    [_photoBrowser setCurrentPhotoIndex:self.currentIndex];
//    return _photoBrowser;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self setUpNotification];
    [self setUpBottomBar];
    [self setUpSegmentView];
    [self setUpTableView];
    [self setUpCollectionView];
    [self setupEmptyView];
    
    [self setUpData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshSubview];
}

- (void)dealloc{
    self.delegate = nil;
}

#pragma mark - private
-(void)setUpNav{
    self.view.backgroundColor = [UIColor whiteColor];
    //UIColorFromRGB(0x7a8fdf)
    self.title = @"本机文件";
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
    self.navigationItem.leftBarButtonItem = leftBarBtnItem;
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    rightBarBtnItem.tintColor = UIColorFromRGB(0x8a8fa4);
    [self.navigationItem setRightBarButtonItem:rightBarBtnItem animated:YES];
    _index = 0;
    _totalSize = 0;
    _isReloadData = NO;
}

- (void)setUpNotification{
    //系统进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

-(void)setUpSegmentView{
    CWSegmentedControl *_segmentControl = [[CWSegmentedControl alloc] initWithFrame:CGRectMake(0, CWTopSafeHeight, UIScreenWidth, SegmenteViewHeight) Titles:@[@"图片",@"视频",@"其他"] delegate:self];
    _segmentControl.delegate = self;
    [_segmentControl changeSegmentedControlWithIndex:_index];
    [self.view addSubview:_segmentControl];
}

- (void)setUpBottomBar {
    //底部视图
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.cw_height - BottomBarHeight - CWBootomSafeHeight, self.view.cw_width, BottomBarHeight)];
    bottomToolBar.backgroundColor = [UIColor clearColor];
    //预览按钮
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame = CGRectMake(10, 0, 44, BottomBarHeight);
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton setTitle:@"预览" forState:UIControlStateDisabled];
    [_previewButton setTitleColor:UIColorFromRGB(0x4393f9) forState:UIControlStateNormal];
    [_previewButton setTitleColor:UIColorFromRGB(0x4393f9) forState:UIControlStateSelected];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_previewButton addTarget:self action:@selector(preViewImage:) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.enabled = NO;
    _previewButton.hidden = YES;
    //已选文件大小Label
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, BottomBarHeight)];
    _sizeLabel.font = [UIFont systemFontOfSize:15.f];
    _sizeLabel.textColor = UIColorFromRGB(0x8a8fa4);
    _sizeLabel.text = @"已选0KB";
    //发送Button
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(self.view.cw_width - 102, 7, 86, 30);
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateDisabled];
     _sendButton.backgroundColor = UIColorFromRGBA(0x4393f9,0.5);
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _sendButton.layer.cornerRadius = self.sendButton.frame.size.height / 2 ;
    _sendButton.enabled = (_selectedFileArr.count + _selectedPHAssetArr.count) > 0;
    //发送View
    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_number_icon.png"]];
    _numberImageView.frame = CGRectMake(self.view.cw_width - 56 - 16, 12, 19, 19);
    _numberImageView.hidden = (_selectedFileArr.count + _selectedPHAssetArr.count) <= 0;
    _numberImageView.backgroundColor = [UIColor clearColor];
    _numberImageView.cw_centerY = _sendButton.cw_centerY;
    //发送Label
    _numberLable = [[UILabel alloc] init];
    _numberLable.frame = _numberImageView.frame;
    _numberLable.font = [UIFont systemFontOfSize:15];
    _numberLable.textColor = [UIColor whiteColor];
    _numberLable.textAlignment = NSTextAlignmentCenter;
    _numberLable.text = [NSString stringWithFormat:@"%zd",_selectedFileArr.count + _selectedPHAssetArr.count];
    _numberLable.hidden = (_selectedFileArr.count + _selectedPHAssetArr.count) <= 0;
    _numberLable.backgroundColor = [UIColor clearColor];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xdedede);
    lineView.frame = CGRectMake(0, 0, self.view.cw_width, 1);
    [bottomToolBar addSubview:lineView];
    [bottomToolBar addSubview:_sizeLabel];
    [bottomToolBar addSubview:_sendButton];
    [bottomToolBar addSubview:_numberImageView];
    [bottomToolBar addSubview:_numberLable];
    [bottomToolBar addSubview:_previewButton];
    [self.view addSubview:bottomToolBar];
}

-(void)setUpData{
#warning wait to do zhangdi
//    id<CWNMessageDBProtocol> messageDB = [[CWNWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWNMessageDBProtocol)].firstObject;
//    __weak typeof(self) weakSelf = self;
//   [messageDB messagesWithType:CubeMessageTypeFile andTimestamp:0 relatedBy:CWNTimeRelationGreaterThanOrEqual andLimit:-1 andSortBy:CWNSortTypeDESC forSession:nil withCompleteHandler:^(NSMutableArray<MessageEntity *> *msgArr) {
//       __strong typeof(weakSelf) strongSelf = weakSelf;
//       [msgArr enumerateObjectsUsingBlock:^(MessageEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//           if(![obj isKindOfClass:[CubeFileMessage class]])return ;
//           CubeFileMessage *fileMsg = (CubeFileMessage *)obj;
//           if(fileMsg.filePath){
//               CWFileManagerModel *fileManagerModel = [[CWFileManagerModel alloc] init];
//               fileManagerModel.filePath   = fileMsg.filePath;
//               fileManagerModel.nameString = fileMsg.fileName;
//               fileManagerModel.timeString = [@(fileMsg.receiveTime) stringValue];
//               fileManagerModel.sizeString = [@(fileMsg.fileSize) stringValue];
//               fileManagerModel.fileImage = [CWNResourceUtil imageNamed:[CWNUtils getImageWithFileName:fileManagerModel.nameString]];
//               [strongSelf.fileDataSourceArr addObject:fileManagerModel];
//               [strongSelf.stateFileArr addObject:@0];
//           }
//       }];
//       dispatch_async(dispatch_get_main_queue(), ^{
//           if (strongSelf.fileDataSourceArr.count) {
//               [strongSelf.otherTableView reloadData];
//           }else{
//               strongSelf.otherTableView.hidden = YES;
//           }
//           [strongSelf setupUnallowAccessPhotosTitle];
//           [strongSelf getVideoData];
//       });
//    }];



    
    
//    NSArray *fileArray = [[CubeMessageDBManager defaultManager] isExistFilePathOfFileMessageContentModels];
//
//    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
//    //去重(去掉filepath相同的)
//    [fileArray enumerateObjectsUsingBlock:^(CWBaseSessionContentModel *  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
//        CWFileContentModel *fileModel1 = (CWFileContentModel *)obj1;
//        __block BOOL isExist = NO;
//        [categoryArray enumerateObjectsUsingBlock:^(CWBaseSessionContentModel *  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
//            CWFileContentModel *fileModel2 = (CWFileContentModel *)obj2;
//            if ([fileModel1.filePath isEqualToString:fileModel2.filePath]) {
//                isExist = YES;
//            }
//        }];
//        if (!isExist) {
//            [categoryArray addObject:obj1];
//        }
//    }];
//
//
//    for (CWBaseSessionContentModel *model in categoryArray) {
//        CWFileContentModel *fileModel = (CWFileContentModel *)model;
//        CWFileManagerModel *fileManagerModel = [[CWFileManagerModel alloc] init];
//        fileManagerModel.filePath   = fileModel.filePath;
//        fileManagerModel.nameString = fileModel.text;
//        fileManagerModel.timeString = [@(fileModel.timestamp) stringValue];
//        fileManagerModel.sizeString = [@(fileModel.total) stringValue];
//        fileManagerModel.fileImage = [CWNUtils getImageWithFileName:fileManagerModel.nameString];
//        [_fileDataSourceArr addObject:fileManagerModel];
//        [_stateFileArr addObject:@0];
//    }
//    if (_fileDataSourceArr.count) {
//        [_otherTableView reloadData];
//    }else{
//        _otherTableView.hidden = YES;
//    }
//    [self setupUnallowAccessPhotosTitle];
    [self getVideoData];

}

- (void)getVideoData
{
    self.videoDataArr = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获得相机胶卷
        PHAssetCollection *collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil].lastObject;
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        // 获得某个相簿中的所有PHAsset对象
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        for (PHAsset *phasset in assets) {
            CWFilePHAsssetModel *assetModel = [[CWFilePHAsssetModel alloc] init];
            if (phasset.mediaType == PHAssetMediaTypeVideo)
            {
                [[PHImageManager defaultManager] requestAVAssetForVideo:phasset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                    assetModel.result = phasset;
                    assetModel.thumbImage = [UIImage imageNamed:@"img_file_video.png"];
                    if ([[asset class] isEqual:[AVURLAsset class]])
                    {
                        AVURLAsset *urlAsset = (AVURLAsset *)asset;
                        NSURL *url = urlAsset.URL;
                        NSNumber *size;
                        NSString *name;
                        [urlAsset.URL getResourceValue:&name forKey:NSURLNameKey error:nil];
                        [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                        assetModel.timeString = [size stringValue];
                        
                        NSDate *date = phasset.creationDate;
                        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
                        NSString *dateStr = [formatter stringFromDate:date];
                        assetModel.timeString = dateStr;
                        
                        CWFileManagerModel *fileManagerModel = [[CWFileManagerModel alloc] init];
                        fileManagerModel.filePath   = [url relativePath];
                        fileManagerModel.nameString = name;
                        fileManagerModel.timeString = dateStr;
                        
                        fileManagerModel.sizeString =  [size stringValue];
                        fileManagerModel.fileImage = [UIImage imageNamed:@"img_file_video.png"];
                        [_videoDataArr addObject:fileManagerModel];
                        [_videoDataSourceArr addObject:assetModel];
                        [_stateVideoArr addObject:@0];
                    }
                }];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_videoDataArr.count) {
                [_videoTableView reloadData];
            }else{
                _videoTableView.hidden = YES;
            }
        });
        
    });
}

-(void)getPhotoAlbumData{
    self.filePickerArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获得相机胶卷
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        // 遍历相机胶卷,获取大图
        [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_filePHAssetArr.count) {
                [_collectionView reloadData];
            }else{
                _collectionView.hidden = YES;
            }
            self.emptyTipView.hidden = _filePHAssetArr.count;
            NSLog(@" _filePHAssetArr.count : %lu", (unsigned long)_filePHAssetArr.count);
        });
        
    });

}

-(void)setUpTableView{
    _otherTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, CWTopSafeHeight + SegmenteViewHeight + 1 - CWBootomSafeHeight, UIScreenWidth, UIScreenHeight - CWTopSafeHeight - SegmenteViewHeight - 1 - BottomBarHeight  - CWBootomSafeHeight ) style:UITableViewStylePlain];
    _otherTableView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    _otherTableView.dataSource = self;
    _otherTableView.delegate = self;
    _otherTableView.userInteractionEnabled = YES;
    _otherTableView.showsVerticalScrollIndicator = YES;
    _otherTableView.scrollEnabled = YES;
    _otherTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _otherTableView.tableFooterView = [[UIView alloc] init];

    _otherTableView.hidden = YES;
    [self.view addSubview:_otherTableView];
    self.allFileDataArr = [[NSMutableArray alloc] init];
    _is24HourSystem = [CWUtils is24HourSystem];
    
    _videoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CWTopSafeHeight + SegmenteViewHeight + 1, UIScreenWidth, UIScreenHeight - CWTopSafeHeight - SegmenteViewHeight - 1 - BottomBarHeight- CWBootomSafeHeight ) style:UITableViewStylePlain];
    _videoTableView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    _videoTableView.dataSource = self;
    _videoTableView.delegate = self;
    _videoTableView.userInteractionEnabled = YES;
    _videoTableView.showsVerticalScrollIndicator = YES;
    _videoTableView.scrollEnabled = YES;
    _videoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _videoTableView.tableFooterView = [[UIView alloc] init];
    _videoTableView.hidden = YES;
    [self.view addSubview:_videoTableView];
    
}

-(void)setUpCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (self.view.cw_width - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    CGFloat top = margin + 44;
    if (IOS7) top += 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, CWTopSafeHeight + SegmenteViewHeight, self.view.cw_width - 2 * margin, self.view.cw_height - SegmenteViewHeight - BottomBarHeight - CWTopSafeHeight - CWBootomSafeHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.userInteractionEnabled = YES;
    _collectionView.alwaysBounceHorizontal = NO;
    if (IOS7) _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.contentSize = CGSizeMake(self.view.cw_width, ((_model.count + 3) / 4) * self.view.cw_width);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CWFileCollectionViewCell class] forCellWithReuseIdentifier:@"collect"];
    [self.view addSubview:_collectionView];
}

-(void)setupEmptyView{
    self.emptyTipView = [[UIView alloc] init];
    self.emptyTipView.center = CGPointMake(self.view.cw_width * .5f, self.otherTableView.cw_height * .5f);
    UIImageView *emptyTipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_filebackgroundImg_default.png"]];
    emptyTipImgV.cw_width = 110.f;
    emptyTipImgV.cw_height = 110.f;
    emptyTipImgV.cw_centerX = self.emptyTipView.cw_centerX;
    emptyTipImgV.cw_top = 0.f;
    
    UILabel *emptyTipLabel = [[UILabel alloc] init];
    emptyTipLabel.text = @"无文件";
    emptyTipLabel.font = [UIFont systemFontOfSize:15.f];
    emptyTipLabel.textColor = UIColorFromRGB(0x999999);
    [emptyTipLabel sizeToFit];
    emptyTipLabel.cw_centerX = self.view.cw_width * .5f;
    emptyTipLabel.cw_top = emptyTipImgV.cw_bottom + EmptyTipViewMargin;
    
    self.emptyTipView.cw_width = UIScreenWidth;
    self.emptyTipView.cw_height = emptyTipImgV.cw_height + emptyTipLabel.cw_height+ EmptyTipViewMargin;
    self.emptyTipView.hidden = YES;
    [self.emptyTipView addSubview:emptyTipLabel];
    [self.emptyTipView addSubview:emptyTipImgV];
    [self.view addSubview:self.emptyTipView];
}

- (void)refreshSubview{
    [self.titleLabel sizeToFit];
    self.titleLabel.cw_centerX   = self.navigationItem.titleView.cw_width * .5f;
    self.emptyTipView.cw_centerX = self.view.cw_width * .5f;
    self.emptyTipView.cw_centerY = self.otherTableView.cw_height * .5f;
}

- (void)refreshBottomToolBarStatus {
    _sendButton.enabled = (_selectedFileArr.count + _selectedPHAssetArr.count + _selectVideoArr.count) > 0;
    _sendButton.backgroundColor = (_selectedFileArr.count + _selectedPHAssetArr.count + _selectVideoArr.count) > 0 ? UIColorFromRGB(0x4393f9) : UIColorFromRGBA(0x4393f9, 0.5);
    _numberLable.hidden = _numberImageView.hidden = YES;
    [_sendButton setTitle:[NSString stringWithFormat:@"发送(%zd)",_selectedFileArr.count + _selectedPHAssetArr.count + _selectVideoArr.count] forState:UIControlStateNormal];
    if(_index == 0)
    {
        _sizeLabel.cw_left =  _previewButton.cw_left + _previewButton.cw_size.width;
        _previewButton.hidden = NO;
        if (_selectedPHAssetArr.count) {
            _previewButton.enabled = YES;
        }
        else
        {
            _previewButton.enabled = NO;
        }
    }
    else
    {
        _previewButton.hidden = YES;
        _sizeLabel.cw_left = 10;
    }
}

- (void)setupUnallowAccessPhotosTitle{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!_isReloadData) {
                        [self getPhotoAlbumData];
                        _isReloadData = YES;
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlertWithTitle:kCWPhotoLibraryAccessFailDescription];
                });
            }
        }];
    }else if (authStatus == PHAuthorizationStatusAuthorized){
        if (!_isReloadData) {
            [self getPhotoAlbumData];
            _isReloadData = YES;
        }
    }else{
        [self showAlertWithTitle:kCWPhotoLibraryAccessFailDescription];
    }
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            CWFilePHAsssetModel *assetModel = [[CWFilePHAsssetModel alloc] init];
            // 是否要原图
            CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                //            NSLog(@"%@", result);
                assetModel.result = asset;
                assetModel.thumbImage = result;
                int seconds = asset.duration;
                NSString *timeString = nil;
                if (seconds >= 60) {
                    timeString = [NSString stringWithFormat:@"%02d:%02d", seconds/60, seconds%60];
                }else{
                    timeString = [NSString stringWithFormat:@"00:%02d", seconds%60];
                }
                assetModel.timeString = timeString;
                [_filePHAssetArr addObject:assetModel];
            }];
            [self.statePHAssetArr addObject:@0];
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title {
//    [CWNCustomAlertView showNormalAlertWithTitle:@"" message:title leftTitle:@"" rightTitle:@"我知道了" hanle:^(NSString *buttonTitle) {
//        if ([buttonTitle isEqualToString:@"我知道了"]) {
//
//        }
//    }];

}

- (void)refreshSizeLabel{
    if (self.selectedType == CWFileSelectedAddFileMType) {
        _totalSize = _totalSize + [self.selectedFileModel.sizeString longLongValue];
        _sizeLabel.text = [NSString stringWithFormat:@"已选%@", [CWUtils stringForamtWithFileSize:_totalSize]];
    }else if (self.selectedType == CWFileSelectedAddPHAssetType) {
        PHAsset *asset = self.selectedAssetModel.result;
        if (asset.mediaType == PHAssetMediaTypeImage) {
//            CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
            // 从asset中获得图片
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            options.version = PHImageRequestOptionsVersionOriginal;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                long long imageSize = imageData.length;
                _totalSize = _totalSize + imageSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _sizeLabel.text = [NSString stringWithFormat:@"已选%@", [CWUtils stringForamtWithFileSize:_totalSize]];;
                });
            }];
        }else if (asset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHVideoRequestOptionsVersionOriginal;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                if ([asset isKindOfClass:[AVURLAsset class]]) {
                    AVURLAsset* urlAsset = (AVURLAsset*)asset;
                    NSNumber *size;
                    [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                    _totalSize = _totalSize + [size longLongValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _sizeLabel.text = [NSString stringWithFormat:@"已选%@", [CWUtils stringForamtWithFileSize:_totalSize]];
                    });
                }
            }];
        }
    }else if (self.selectedType == CWFileSelectedCutDownFileMType) {
        _totalSize = _totalSize - [self.selectedFileModel.sizeString longLongValue];
        _sizeLabel.text = [NSString stringWithFormat:@"已选%@", [CWUtils stringForamtWithFileSize:_totalSize]];
    }else if (self.selectedType == CWFileSelectedCutDownPHAssetType) {
        PHAsset *asset = self.selectedAssetModel.result;
        if (asset.mediaType == PHAssetMediaTypeImage) {
//            CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
            // 从asset中获得图片
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            options.version = PHImageRequestOptionsVersionOriginal;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                long long imageSize = imageData.length;
                _totalSize = _totalSize - imageSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _sizeLabel.text = [NSString stringWithFormat:@"已选%@", [CWUtils stringForamtWithFileSize:_totalSize]];
                });
            }];
        }else if (asset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHVideoRequestOptionsVersionOriginal;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                if ([asset isKindOfClass:[AVURLAsset class]]) {
                    AVURLAsset* urlAsset = (AVURLAsset*)asset;
                    NSNumber *size;
                    [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                    _totalSize = _totalSize - [size longLongValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _sizeLabel.text = [NSString stringWithFormat:@"已选%@", [CWUtils stringForamtWithFileSize:_totalSize]];
                    });
                }
            }];
        }
    }
}

#pragma mark - NSNotificationCenter
-(void)systemWillEnterForeground:(NSNotification *)notify{
    BOOL is24Hour = [CWUtils is24HourSystem];
    if (![[NSNumber numberWithBool:_is24HourSystem] isEqualToNumber:[NSNumber numberWithBool:is24Hour]]) {
        _is24HourSystem = is24Hour;
        [self.otherTableView reloadData];
    }
}

#pragma mark - Selector
- (void)preViewImage:(id)Sender
{
    //预览图片
    self.photos = [NSMutableArray array];
    self.thumbs = [NSMutableArray array];
    for (CWFilePHAsssetModel *model in _selectedPHAssetArr) {
        UIScreen *screen = [UIScreen mainScreen];
        CGFloat scale = screen.scale;
        CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
        CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
        CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
#warning wait to do zhangdi
//        MWPhoto *photo = [MWPhoto photoWithAsset:model.result targetSize:imageTargetSize];
//        MWPhoto *thumb = [MWPhoto photoWithAsset:model.result targetSize:thumbTargetSize];
//        [self.photos addObject:photo];
//        [self.thumbs addObject:thumb];
    }
    
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
//    nc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

-(void)rightBtnAction:(id)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendButtonClick:(id)sender{
    
    //判断是否是蜂窝上网
    if ([AFNetworkReachabilityManager sharedManager].reachableViaWWAN) {
        
        NSString *title = @"流量提醒";
        NSString *message = @"当前在非WiFi环境，上传文件将消耗一定流量，是否继续？";
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherTitle = NSLocalizedString(@"继续", nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self onSendFiles];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }else{//WiFi网络
        [self onSendFiles];
    }

}

- (void)onSendFiles{
    
    if (_selectedFileArr.count + _selectedPHAssetArr.count + _selectVideoArr.count > 0) {
        if (_totalSize > 9 * 100 * 1024 * 1024) {
            [CWToastUtil showTextMessage:@"发送文件单次大小不能超出9*99M,请重新选择" andDelay:1.0f];
        }else{
            NSMutableDictionary *filePickerDic = [[NSMutableDictionary alloc]init];
            NSMutableArray *PHAssetArray = [NSMutableArray array];
            [PHAssetArray addObjectsFromArray:_selectedPHAssetArr];
            for (int i = 0; i < _videoDataSourceArr.count; i++) {
                if ([[_stateVideoArr objectAtIndex:i] isEqualToNumber:@1]) {
                    [PHAssetArray addObject:_videoDataSourceArr[i]];
                }
            }
            [filePickerDic setObject:_selectedFileArr forKey:@"file"];
            [filePickerDic setObject:PHAssetArray forKey:@"asset"];
            
            if ([self.delegate respondsToSelector:@selector(filePickerControllerWithDic:andController:)]) {
                [self.delegate filePickerControllerWithDic:filePickerDic andController:self];
            }
        }
    }else{
        [CWToastUtil showTextMessage:@"请选择文件" andDelay:1.f];
    }
}

#pragma mark - CWSegmentedControlDelegate
-(void)segmentedControlSelectAtIndex:(NSInteger)index{
    if (index == 0)
    {
        _index = 0;
        [self setupUnallowAccessPhotosTitle];
        [self.view bringSubviewToFront:_collectionView];
        _otherTableView.hidden = YES;
        if (_filePHAssetArr.count) {
            _collectionView.hidden = NO;
            [_collectionView reloadData];
        }else{
            _collectionView.hidden = YES;
        }
        _videoTableView.hidden = YES;
//        self.emptyTipView.hidden = _filePHAssetArr.count;
    }
    else if (index == 2)
    {
        _index = 2;
        [self.view bringSubviewToFront:_otherTableView];
        _collectionView.hidden = YES;
        if (_fileDataSourceArr.count) {
            _otherTableView.hidden = NO;
            [_otherTableView reloadData];
        }else{
            _otherTableView.hidden = YES;
        }
        _videoTableView.hidden = YES;
//        self.emptyTipView.hidden = _fileDataSourceArr.count;
    }
    else if (index == 1)
    {
        _index = 1;
        _collectionView.hidden = YES;
        _otherTableView.hidden = YES;
        [self.view bringSubviewToFront:_videoTableView];
        
        
        _videoTableView.hidden = NO;
        [_videoTableView reloadData];
    }
    [self refreshBottomToolBarStatus];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_videoTableView == tableView)
    {//视频
        return _videoDataArr.count;
    }
    else
    {//其他
        return _fileDataSourceArr.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    CWFileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CWFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if(_videoTableView == tableView)
    {//视频
        CWFileManagerModel *model  = _videoDataArr[indexPath.row];
        if ([_stateVideoArr[indexPath.row] isEqualToNumber:@0]) {
            cell.selectedButton.selected = NO;
        }else {
            cell.selectedButton.selected = YES;
        }
        cell.nameLabel.text = model.nameString;
        [cell.nameLabel sizeToFit];
        cell.timeLabel.text = model.timeString;
        [cell.timeLabel sizeToFit];
        cell.avatarImageView.image = model.fileImage;
        cell.sizeLabel.text = [CWUtils stringForamtWithFileSize:[model.sizeString longLongValue]];
        [cell.sizeLabel sizeToFit];
        [cell refresh];
    }
    else
    {//其他
        CWFileManagerModel *model = _fileDataSourceArr[indexPath.row];
        model = _fileDataSourceArr[indexPath.row];
        if ([_stateFileArr[indexPath.row] isEqualToNumber:@0]) {
            cell.selectedButton.selected = NO;
        }else {
            cell.selectedButton.selected = YES;
        }
        cell.avatarImageView.image = model.fileImage;
        cell.nameLabel.text = model.nameString;
        [cell.nameLabel sizeToFit];
        cell.timeLabel.text = [CWUtils showTime:[model.timeString longLongValue]/1000 showDetail:YES is24HourSystem:_is24HourSystem];
        [cell.timeLabel sizeToFit];
        cell.sizeLabel.text = [CWUtils stringForamtWithFileSize:[model.sizeString longLongValue]];
        [cell.sizeLabel sizeToFit];
        [cell refresh];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *dataSourceArray;
    NSMutableArray *stateArray;
    NSMutableArray *selectArray;
    if(_videoTableView == tableView)
    {
        stateArray = _stateVideoArr;
        dataSourceArray = _videoDataArr;
        selectArray = _selectVideoArr;
    }
    else
    {
        stateArray = _stateFileArr;
        dataSourceArray = _fileDataSourceArr;
        selectArray = _selectedFileArr;
    }
        CWFileTableViewCell * cell = (CWFileTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        CWFileManagerModel *model = dataSourceArray[indexPath.row];
        NSInteger tableIndex = indexPath.row;
        if ((_selectedFileArr.count > 0 || _selectedPHAssetArr.count > 0 || _selectVideoArr.count > 0) && (_selectedFileArr.count + _selectVideoArr.count + _selectedPHAssetArr.count >= 9)) {
            if ([stateArray[tableIndex] isEqualToNumber:@0]) {
                [self showAlertWithTitle:[NSString stringWithFormat:@"你最多可以选择%d个文件",9]];
            }else{
                stateArray[tableIndex] = @0;
                [selectArray removeObject:model];
                self.selectedType = CWFileSelectedCutDownFileMType;
                self.selectedFileModel = model;
                [self refreshSizeLabel];
                cell.selectedButton.selected = !cell.selectedButton.selected;
                [self refreshBottomToolBarStatus];
                [UIView showOscillatoryAnimationWithLayer:cell.selectedImgView.layer type:CWOscillatoryAnimationToBigger];
                [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:CWOscillatoryAnimationToSmaller];
            }
        }else{
            if ([stateArray[tableIndex] isEqualToNumber:@0]) {
                if ([model.sizeString longLongValue] > 100 * 1024 * 1024) {
                    [CWToastUtil showTextMessage:@"发送单个文件大小不能超出100M,请重新选择" andDelay:1.0f];
                    return;
                }
                stateArray[tableIndex] = @1;
                [selectArray addObject:model];
                self.selectedType = CWFileSelectedAddFileMType;
                self.selectedFileModel = model;
            }else {
                stateArray[tableIndex] = @0;
                [selectArray removeObject:model];
                self.selectedType = CWFileSelectedCutDownFileMType;
                self.selectedFileModel = model;
            }
            [self refreshSizeLabel];
            cell.selectedButton.selected = !cell.selectedButton.selected;
            [self refreshBottomToolBarStatus];
            [UIView showOscillatoryAnimationWithLayer:cell.selectedImgView.layer type:CWOscillatoryAnimationToBigger];
            [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:CWOscillatoryAnimationToSmaller];
        }
    
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_filePHAssetArr count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * string = @"collect";
    CWFileCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    if (!cell) {
        cell = [[CWFileCollectionViewCell alloc] init];
    }
    CWFilePHAsssetModel *model = [_filePHAssetArr objectAtIndex:indexPath.row];
    cell.assetImageView.image = model.thumbImage;
    if ([self.statePHAssetArr[indexPath.row] isEqualToNumber:@0]) {
        cell.selectedButton.selected = NO;
    }
    else {
        cell.selectedButton.selected = YES;
    }
    cell.videoImageView.image = [UIImage imageNamed:@"img_video_mark.png"];
    cell.selectedImgView.image = cell.selectedButton.isSelected ? [UIImage imageNamed:@"img_choose.png"] : [UIImage imageNamed:@"img_nochoose.png"];
    cell.timeLabel.text = model.timeString;
    [cell refreshData:model.result];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CWFileCollectionViewCell * cell = (CWFileCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CWFilePHAsssetModel *model = [_filePHAssetArr objectAtIndex:indexPath.row];
    NSInteger collectionIndex = indexPath.row;
    if ((_selectedFileArr.count > 0 || _selectedPHAssetArr.count > 0 || _selectVideoArr.count > 0) && (_selectedFileArr.count + _selectVideoArr.count + _selectedPHAssetArr.count >= 9)) {
        if ([self.statePHAssetArr[collectionIndex] isEqualToNumber:@0]) {
            [self showAlertWithTitle:[NSString stringWithFormat:@"你最多可以选择%d个文件",9]];
        }else {
            self.statePHAssetArr[collectionIndex] = @0;
            [_selectedPHAssetArr removeObject:model];
            self.selectedType = CWFileSelectedCutDownPHAssetType;
            self.selectedAssetModel = model;
            [self refreshSizeLabel];
            cell.selectedButton.selected = !cell.selectedButton.selected;
            cell.selectedImgView.image = cell.selectedButton.isSelected ? [UIImage imageNamed:@"img_choose.png"] : [UIImage imageNamed:@"img_nochoose.png"];
            [self refreshBottomToolBarStatus];
            [UIView showOscillatoryAnimationWithLayer:cell.selectedImgView.layer type:CWOscillatoryAnimationToBigger];
            [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:CWOscillatoryAnimationToSmaller];
        }

    }else{
        if ([self.statePHAssetArr[collectionIndex] isEqualToNumber:@0]) {
            PHAsset *asset = model.result;
            if (asset.mediaType == PHAssetMediaTypeImage) {
                //            CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                // 从asset中获得图片
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = YES;
                options.version = PHImageRequestOptionsVersionOriginal;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                    long long imageSize = imageData.length;
                    if (imageSize > 100 * 1024 * 1024) {
                        [CWToastUtil showTextMessage:@"发送单个文件大小不能超出100M,请重新选择" andDelay:1.0f];
                        return;
                    }else{
                        self.statePHAssetArr[collectionIndex] = @1;
                        [self.selectedPHAssetArr addObject:model];
                        self.selectedType = CWFileSelectedAddPHAssetType;
                        self.selectedAssetModel = model;
                        [self refreshSizeLabel];
                        cell.selectedButton.selected = !cell.selectedButton.selected;
                        cell.selectedImgView.image = cell.selectedButton.isSelected ? [UIImage imageNamed:@"img_choose.png"] : [UIImage imageNamed:@"img_nochoose.png"];
                        [self refreshBottomToolBarStatus];
                        [UIView showOscillatoryAnimationWithLayer:cell.selectedImgView.layer type:CWOscillatoryAnimationToBigger];
                        [UIView showOscillatoryAnimationWithLayer:self.numberImageView.layer type:CWOscillatoryAnimationToSmaller];
                    }
                }];
            }else if (asset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHVideoRequestOptionsVersionOriginal;
                [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                    if ([asset isKindOfClass:[AVURLAsset class]]) {
                        AVURLAsset* urlAsset = (AVURLAsset*)asset;
                        NSNumber *size;
                        [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                        if ([size longLongValue] > 100 * 1024 * 1024) {
                            [CWToastUtil showTextMessage:@"发送单个文件大小不能超出100M,请重新选择" andDelay:1.0f];
                            return;
                        }else{
                            self.statePHAssetArr[collectionIndex] = @1;
                            [self.selectedPHAssetArr addObject:model];
                            self.selectedType = CWFileSelectedAddPHAssetType;
                            self.selectedAssetModel = model;
                            [self refreshSizeLabel];
                            cell.selectedButton.selected = !cell.selectedButton.selected;
                            cell.selectedImgView.image = cell.selectedButton.isSelected ? [UIImage imageNamed:@"img_choose.png"] : [UIImage imageNamed:@"img_nochoose.png"];
                            [self refreshBottomToolBarStatus];
                            [UIView showOscillatoryAnimationWithLayer:cell.selectedImgView.layer type:CWOscillatoryAnimationToBigger];
                            [UIView showOscillatoryAnimationWithLayer:self.numberImageView.layer type:CWOscillatoryAnimationToSmaller];
                        }
                    }
                }];
            }
        }else {
            self.statePHAssetArr[collectionIndex] = @0;
            [self.selectedPHAssetArr removeObject:model];
            self.selectedType = CWFileSelectedCutDownPHAssetType;
            self.selectedAssetModel = model;
            [self refreshSizeLabel];
            cell.selectedButton.selected = !cell.selectedButton.selected;
            cell.selectedImgView.image = cell.selectedButton.isSelected ? [UIImage  imageNamed:@"img_choose.png"] : [UIImage imageNamed:@"img_nochoose.png"];
            [self refreshBottomToolBarStatus];
            [UIView showOscillatoryAnimationWithLayer:cell.selectedImgView.layer type:CWOscillatoryAnimationToBigger];
            [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:CWOscillatoryAnimationToSmaller];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - MWPhotoBrowserDelegate
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
//    return self.photos.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
//    if (index < _photos.count)
//        return [_photos objectAtIndex:index];
//    return nil;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    if (index < _thumbs.count)
//        return [_thumbs objectAtIndex:index];
//    return nil;
//}
//
//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
//    // If we subscribe to this method we must dismiss the view controller ourselves
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


@end
