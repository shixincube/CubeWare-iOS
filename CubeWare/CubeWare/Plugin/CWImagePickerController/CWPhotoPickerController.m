//
//  CWPhotoPickerController.m
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWPhotoPickerController.h"
#import "CWImagePickerController.h"
#import "CWPhotoPreviewController.h"
#import "CWAssetCell.h"
#import "CWAssetModel.h"
#import "UIView+NCubeWare.h"
#import "CWResourceUtil.h"
#import "CWImageManager.h"
#import "CWVideoPlayerController.h"
#import "CWToastUtil.h"
#import "CubeWareHeader.h"
#import "CWColorUtil.h"
@interface CWPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_models;
    UIButton *_previewButton;
    UIButton *_okButton;
    UIImageView *_numberImageView;
    UILabel *_numberLable;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLable;
    BOOL _shouldScrollToBottom;
}
@property CGRect previousPreheatRect;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

static CGSize AssetGridThumbnailSize;

@implementation CWPhotoPickerController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *CWBarItem, *BarItem;
#ifdef __IPHONE_9_0
            CWBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[CWImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
#else
            CWBarItem = [UIBarButtonItem appearanceWhenContainedIn:[CWImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#endif
        NSDictionary *titleTextAttributes = [CWBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    _isSelectOriginalPhoto = CWImagePickerVc.isSelectOriginalPhoto;
    _shouldScrollToBottom = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _model.name;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    rightItem.tintColor = UIColorFromRGB(0x8a8fa4);
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
    if ([_model.name isEqualToString:@"相机胶卷"]
        || [_model.name isEqualToString:@"Camera Roll"]
        ||  [_model.name isEqualToString:@"所有照片"]
        || !IOS8) {
        [[CWImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:CWImagePickerVc.allowPickingVideo allowPickingImage:CWImagePickerVc.allowPickingImage completion:^(NSArray<CWAssetModel *> *models) {
            _models = [NSMutableArray arrayWithArray:models];
            [self initSubviews];
        }];
    } else {
        _models = [NSMutableArray arrayWithArray:_model.models];
        [self initSubviews];
    }
    // [self resetCachedAssets];
}

- (void)initSubviews {
    [self checkSelectedModels];
    [self configCollectionView];
    [self configBottomToolBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    CWImagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (self.backButtonClickHandle) {
        self.backButtonClickHandle(_model);
    }
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (self.view.cw_width - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    CGFloat top = margin + 44;
    if (IOS7) top += 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, top, self.view.cw_width - 2 * margin, self.view.cw_height - 50 - top) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    if (IOS7) _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    if (([_model.name isEqualToString:@"相机胶卷"] || [_model.name isEqualToString:@"Camera Roll"] ||  [_model.name isEqualToString:@"所有照片"]) && CWImagePickerVc.allowTakePicture ) {
        _collectionView.contentSize = CGSizeMake(self.view.cw_width, ((_model.count + 4) / 4) * self.view.cw_width);
    } else {
        _collectionView.contentSize = CGSizeMake(self.view.cw_width, ((_model.count + 3) / 4) * self.view.cw_width);
    }
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CWAssetCell class] forCellWithReuseIdentifier:@"CWAssetCell"];
    [_collectionView registerClass:[CWAssetCameraCell class] forCellWithReuseIdentifier:@"CWAssetCameraCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollCollectionViewToBottom];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = 2.0;
    if ([UIScreen mainScreen].bounds.size.width > 600) {
        scale = 1.0;
    }
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (IOS8) {
        // [self updateCachedAssets];
    }
}

- (void)configBottomToolBar {
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.cw_height - 50 - CWBootomSafeHeight, self.view.cw_width, 50)];
    CGFloat rgb = 253 / 255.0;
    bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame = CGRectMake(10, 3, 44, 44);
    [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton setTitle:@"预览" forState:UIControlStateDisabled];
    [_previewButton setTitleColor:UIColorFromRGB(0x8a8fa4) forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = CWImagePickerVc.selectedModels.count;
    
    if (CWImagePickerVc.allowPickingOriginalPhoto) {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.frame = CGRectMake(50, self.view.cw_height - 50 - CWBootomSafeHeight, 130, 50);
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _originalPhotoButton.contentEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 0);
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[CWResourceUtil imageNamed:@"img_nochoose_other.png"] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[CWResourceUtil imageNamed:@"img_choose.png"] forState:UIControlStateSelected];
        _originalPhotoButton.selected = _isSelectOriginalPhoto;
        _originalPhotoButton.enabled = CWImagePickerVc.selectedModels.count > 0;
        //        _originalPhotoButton.hidden = YES;
        _originalPhotoLable = [[UILabel alloc] init];
        _originalPhotoLable.frame = CGRectMake(70, 0, 60, 50);
        _originalPhotoLable.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLable.font = [UIFont systemFontOfSize:16];
        _originalPhotoLable.textColor = [UIColor blackColor];
        if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
    }
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.frame = CGRectMake(self.view.cw_width - 102, 10, 86, 30);
    _okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_okButton setTitle:@"发送" forState:UIControlStateNormal];
    [_okButton setTitle:@"发送" forState:UIControlStateDisabled];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _okButton.backgroundColor = [CWColorUtil colorWithRGB:0x4393f9 andAlpha:1];
    _okButton.enabled = CWImagePickerVc.selectedModels.count;
    _okButton.layer.cornerRadius = _okButton.frame.size.height / 2;
    
    _numberImageView = [[UIImageView alloc] initWithImage:[CWResourceUtil imageNamed:@"img_number_icon.png"]];
    _numberImageView.frame = CGRectMake(self.view.cw_width - 56 - 24, 12, 26, 26);
    _numberImageView.hidden = CWImagePickerVc.selectedModels.count <= 0;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLable = [[UILabel alloc] init];
    _numberLable.frame = _numberImageView.frame;
    _numberLable.font = [UIFont systemFontOfSize:16];
    _numberLable.textColor = [UIColor whiteColor];
    _numberLable.textAlignment = NSTextAlignmentCenter;
    _numberLable.text = [NSString stringWithFormat:@"%zd",CWImagePickerVc.selectedModels.count];
    _numberLable.hidden = CWImagePickerVc.selectedModels.count <= 0;
    _numberLable.backgroundColor = [UIColor clearColor];
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, self.view.cw_width, 1);
    
    [bottomToolBar addSubview:divide];
    [bottomToolBar addSubview:_previewButton];
    [bottomToolBar addSubview:_okButton];
    [bottomToolBar addSubview:_numberImageView];
    [bottomToolBar addSubview:_numberLable];
    [self.view addSubview:bottomToolBar];
    [self.view addSubview:_originalPhotoButton];
    [_originalPhotoButton addSubview:_originalPhotoLable];
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

- (void)previewButtonClick {
    CWPhotoPreviewController *photoPreviewVc = [[CWPhotoPreviewController alloc] init];
    [self pushPhotoPrevireViewController:photoPreviewVc];
}

- (void)originalPhotoButtonClick {
    if (!_originalPhotoButton.isSelected) {
        __weak typeof(self) weakSelf = self;
        CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
        
        [[CWImageManager manager] getTipWithAsset:nil imageOverSize:CWImagePickerVc.imageSize imageOverLength:CWImagePickerVc.imageLength isSelectOriginal:!_isSelectOriginalPhoto completion:^(NSString *tip) {
            if (!tip) {
                _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
                _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
                _originalPhotoLable.hidden = !_originalPhotoButton.isSelected;
                if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
            }else{
                CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)weakSelf.navigationController;
                [CWImagePickerVc showAlertWithTitle:tip];
            }
        }];
    }else{
        _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
        _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
        _originalPhotoLable.hidden = !_originalPhotoButton.isSelected;
        if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
    }
}

- (void)okButtonClick {
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    
    CGFloat totalImageLength = CWImagePickerVc.totalImageLength;
    CGFloat currentImageLength = CWImagePickerVc.currentImageLength;
    [[CWImageManager manager] getPhotosBytesWithArray:CWImagePickerVc.selectedModels completion:^(NSString *totalBytes, NSInteger totalLength) {
        if (totalLength + currentImageLength >= totalImageLength) {
            NSString *totalLength = [NSString stringWithFormat:@"附件总大小不超过%@", [[CWImageManager manager] getIntBytesFromDataLength:totalImageLength]];
            [CWToastUtil showTextMessage:totalLength andDelay:2.0f];
//            [CWUtils showTextMessage:totalLength onView:self.view andDelay:2.f];
        }else{
            [self transformData];
        }
    }];
}
- (void)transformData{
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    [CWImagePickerVc showProgressHUD];
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *infoArr = [NSMutableArray array];
    for (NSInteger i = 0; i < CWImagePickerVc.selectedModels.count; i++) { [photos addObject:@1];[assets addObject:@1];[infoArr addObject:@1]; }
    
    [CWImageManager manager].shouldFixOrientation = YES;
    for (NSInteger i = 0; i < CWImagePickerVc.selectedModels.count; i++) {
        CWAssetModel *model = CWImagePickerVc.selectedModels[i];
        [[CWImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) return;
            
            if (photo) {
                photo = [self scaleImage:photo toSize:CGSizeMake(CWImagePickerVc.photoWidth, CWImagePickerVc.photoWidth * photo.size.height / photo.size.width)];
                [photos replaceObjectAtIndex:i withObject:photo];
            }
            if (info)  [infoArr replaceObjectAtIndex:i withObject:info];
            [assets replaceObjectAtIndex:i withObject:model.asset];
            
            for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }
            
            if ([CWImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
                [CWImagePickerVc.pickerDelegate imagePickerController:CWImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
            }
            if ([CWImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
                [CWImagePickerVc.pickerDelegate imagePickerController:CWImagePickerVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
            }
            if (CWImagePickerVc.didFinishPickingPhotosHandle) {
                CWImagePickerVc.didFinishPickingPhotosHandle(photos,assets,_isSelectOriginalPhoto);
            }
            if (CWImagePickerVc.didFinishPickingPhotosWithInfosHandle) {
                CWImagePickerVc.didFinishPickingPhotosWithInfosHandle(photos,assets,_isSelectOriginalPhoto,infoArr);
            }
            [CWImagePickerVc hideProgressHUD];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}
#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_model.name isEqualToString:@"相机胶卷"] || [_model.name isEqualToString:@"Camera Roll"] ||  [_model.name isEqualToString:@"所有照片"] ) {
        CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
        if (CWImagePickerVc.allowPickingImage && CWImagePickerVc.allowTakePicture) {
            return _models.count + 1;
        }
    }
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // the cell lead to take a picture / 去拍照的cell
    if (indexPath.row >= _models.count) {
        CWAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CWAssetCameraCell" forIndexPath:indexPath];
#warning 图片资源找不到
        cell.imageView.image = [CWResourceUtil imageNamed:@"takePicture.png"];
        return cell;
    }
    // the cell dipaly photo or video / 展示照片或视频的cell
    CWAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CWAssetCell" forIndexPath:indexPath];
    CWAssetModel *model = _models[indexPath.row];
    cell.model = model;
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;

    cell.imageSize = CWImagePickerVc.imageSize;
    cell.imageLength = CWImagePickerVc.imageLength;
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    __weak typeof(_numberImageView.layer) weakLayer = _numberImageView.layer;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
//        CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)weakSelf.navigationController;
        // 1. cancel select / 取消选择
        if (isSelected) {
            
            [[CWImageManager manager] getTipWithAsset:model imageOverSize:CWImagePickerVc.imageSize imageOverLength:CWImagePickerVc.imageLength isSelectOriginal:!_isSelectOriginalPhoto completion:^(NSString *tip) {
                if (!tip) {
                    weakCell.selectPhotoButton.selected = NO;
                    model.isSelected = NO;
                    NSArray *selectedModels = [NSArray arrayWithArray:CWImagePickerVc.selectedModels];
                    for (CWAssetModel *model_item in selectedModels) {
                        if ([model.asset isEqual:model_item.asset]) {
                            [CWImagePickerVc.selectedModels removeObject:model_item];
                        }
                    }
                    [weakSelf refreshBottomToolBarStatus];
                }else{
                    [CWImagePickerVc showAlertWithTitle:tip];
                }
            }];
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            
            if (CWImagePickerVc.selectedModels.count < CWImagePickerVc.maxImagesCount) {
//                weakCell.selectPhotoButton.selected = YES;
//                model.isSelected = YES;
//                [CWImagePickerVc.selectedModels addObject:model];
//                [weakSelf refreshBottomToolBarStatus];
                [[CWImageManager manager] getTipWithAsset:model imageOverSize:CWImagePickerVc.imageSize imageOverLength:CWImagePickerVc.imageLength isSelectOriginal:!_isSelectOriginalPhoto completion:^(NSString *tip) {
                    if (!tip) {
                        weakCell.selectPhotoButton.selected = YES;
                        model.isSelected = YES;
                        [CWImagePickerVc.selectedModels addObject:model];
                        [weakSelf refreshBottomToolBarStatus];
                    }else{
                        [CWImagePickerVc showAlertWithTitle:tip];
                    }
                }];
            } else {
                [CWImagePickerVc showAlertWithTitle:[NSString stringWithFormat:@"你最多可以选择%zd张照片",CWImagePickerVc.maxImagesCount]];
            }
        }
        [UIView showOscillatoryAnimationWithLayer:weakLayer type:CWOscillatoryAnimationToSmaller];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // take a picture / 去拍照
    if (indexPath.row >= _models.count) {
        [self takePicture]; return;
    }
    // preview phote or video / 预览照片或视频
    CWAssetModel *model = _models[indexPath.row];
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    if (model.type == CWAssetModelMediaTypeVideo) {
        if (CWImagePickerVc.selectedModels.count > 0) {
            CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
            [imagePickerVc showAlertWithTitle:@"选择照片时不能选择视频"];
        } else {
            CWVideoPlayerController *videoPlayerVc = [[CWVideoPlayerController alloc] init];
            videoPlayerVc.model = model;
            [self.navigationController pushViewController:videoPlayerVc animated:YES];
        }
    } else {
        CWPhotoPreviewController *photoPreviewVc = [[CWPhotoPreviewController alloc] init];
        photoPreviewVc.currentIndex = indexPath.row;
        photoPreviewVc.models = _models;
        [self pushPhotoPrevireViewController:photoPreviewVc];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (IOS8) {
        // [self updateCachedAssets];
    }
}

#pragma mark - Private Method

- (void)takePicture {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(IOS8) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)refreshBottomToolBarStatus {
    CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
    
    _previewButton.enabled = imagePickerVc.selectedModels.count > 0;
    _okButton.enabled = imagePickerVc.selectedModels.count > 0;
    
//    _numberImageView.hidden = imagePickerVc.selectedModels.count <= 0;
//    _numberLable.hidden = imagePickerVc.selectedModels.count <= 0;
//    _numberLable.text = [NSString stringWithFormat:@"%zd",imagePickerVc.selectedModels.count];
    _numberLable.hidden = _numberImageView.hidden = YES;
    [_okButton setTitle:[NSString stringWithFormat:@"发送(%zd)",imagePickerVc.selectedModels.count] forState:UIControlStateNormal];
    _originalPhotoButton.enabled = imagePickerVc.selectedModels.count > 0;
    _originalPhotoButton.selected = (_isSelectOriginalPhoto && _originalPhotoButton.enabled);
    _originalPhotoLable.hidden = (!_originalPhotoButton.isSelected);
    if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
}

- (void)pushPhotoPrevireViewController:(CWPhotoPreviewController *)photoPreviewVc {
    __weak typeof(self) weakSelf = self;
    photoPreviewVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    photoPreviewVc.backButtonClickBlock = ^(BOOL isSelectOriginalPhoto) {
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf checkSelectedModels];
        [weakSelf.collectionView reloadData];
        [weakSelf refreshBottomToolBarStatus];
    };
    photoPreviewVc.okButtonClickBlock = ^(BOOL isSelectOriginalPhoto){
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf okButtonClick];
    };
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}

- (void)getSelectedPhotoBytes {
    CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
    [[CWImageManager manager] getPhotosBytesWithArray:imagePickerVc.selectedModels completion:^(NSString *totalBytes, NSInteger totalLength) {
        _originalPhotoLable.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

/// Scale image / 缩放图片
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width < size.width) {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)scrollCollectionViewToBottom {
    if (_shouldScrollToBottom && _models.count > 0) {
        NSInteger item = _models.count - 1;
        if ([_model.name isEqualToString:@"相机胶卷"] || [_model.name isEqualToString:@"Camera Roll"] ||  [_model.name isEqualToString:@"所有照片"] ) {
            CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
            if (CWImagePickerVc.allowPickingImage && CWImagePickerVc.allowTakePicture) {
                item += 1;
            }
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        _shouldScrollToBottom = NO;
    }
}

- (void)checkSelectedModels {
    for (CWAssetModel *model in _models) {
        model.isSelected = NO;
        NSMutableArray *selectedAssets = [NSMutableArray array];
        CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
        for (CWAssetModel *model in CWImagePickerVc.selectedModels) {
            [selectedAssets addObject:model.asset];
        }
        if ([[CWImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            model.isSelected = YES;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //    if ([type isEqualToString:@"public.image"]) {
    //        CWImagePickerController *imagePickerVc = (CWImagePickerController *)self.navigationController;
    //        [imagePickerVc showProgressHUD];
    //        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //        [[CWImageManager manager] savePhotoWithImage:image completion:^{
    //            [self reloadPhotoArray];
    //        }];
    //    }
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    if ([CWImagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotoWithInfo:)]) {
        [CWImagePickerVc.pickerDelegate imagePickerController:CWImagePickerVc didFinishPickingPhotoWithInfo:info];
    }
}

- (void)reloadPhotoArray {
    CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    [[CWImageManager manager] getCameraRollAlbum:CWImagePickerVc.allowPickingVideo allowPickingImage:CWImagePickerVc.allowPickingImage completion:^(CWAlbumModel *model) {
        _model = model;
        [[CWImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:CWImagePickerVc.allowPickingVideo allowPickingImage:CWImagePickerVc.allowPickingImage completion:^(NSArray<CWAssetModel *> *models) {
            [CWImagePickerVc hideProgressHUD];
            
            CWAssetModel *model = [models lastObject];
            [_models addObject:model];
            if (CWImagePickerVc.selectedModels.count < CWImagePickerVc.maxImagesCount) {
                model.isSelected = YES;
                [CWImagePickerVc.selectedModels addObject:model];
                [self refreshBottomToolBarStatus];
            }
            [_collectionView reloadData];
            
            _shouldScrollToBottom = YES;
            [self scrollCollectionViewToBottom];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [[CWImageManager manager].cachingImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = _collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(_collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [[CWImageManager manager].cachingImageManager startCachingImagesForAssets:assetsToStartCaching
                                                                       targetSize:AssetGridThumbnailSize
                                                                      contentMode:PHImageContentModeAspectFill
                                                                          options:nil];
        [[CWImageManager manager].cachingImageManager stopCachingImagesForAssets:assetsToStopCaching
                                                                      targetSize:AssetGridThumbnailSize
                                                                     contentMode:PHImageContentModeAspectFill
                                                                         options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < _models.count) {
            CWAssetModel *model = _models[indexPath.item];
            [assets addObject:model.asset];
        }
    }
    
    return assets;
}

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [_collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end
