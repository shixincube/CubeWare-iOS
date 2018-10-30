//
//  CWPhotoPreviewController.m
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWPhotoPreviewController.h"
#import "CWPhotoPreviewCell.h"
#import "CWAssetModel.h"
#import "UIView+NCubeWare.h"
#import "CWResourceUtil.h"
#import "CWImagePickerController.h"
#import "CWImageManager.h"
#import "CubeWareHeader.h"

@interface CWPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    BOOL _isHideNaviBar;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UIView *_toolBar;
    UIButton *_okButton;
    UIImageView *_numberImageView;
    UILabel *_numberLable;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLable;
}

@end

@implementation CWPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    CWImagePickerController *_CWImagePickerVc = (CWImagePickerController *)weakSelf.navigationController;
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithArray:_CWImagePickerVc.selectedModels];
        _assetsTemp = [NSMutableArray arrayWithArray:_CWImagePickerVc.selectedAssets];
        self.isSelectOriginalPhoto = _CWImagePickerVc.isSelectOriginalPhoto;
    }
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (IOS7) [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.cw_width) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (IOS7) [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)configCustomNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cw_width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    _naviBar.alpha = 0.7;
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [_backButton setImage:[CWResourceUtil imageNamed:@"img_return_normal.png"] forState:UIControlStateNormal];
    [_backButton setImage:[CWResourceUtil imageNamed:@"img_return_selected.png"] forState:UIControlStateSelected];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.cw_width - 54, 20, 42, 42)];
    [_selectButton setImage:[CWResourceUtil imageNamed:@"img_nochoose_other.png"] forState:UIControlStateNormal];
    [_selectButton setImage:[CWResourceUtil imageNamed:@"img_choose.png"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.cw_centerY = _backButton.cw_centerY;
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.cw_height - 44 - CWBootomSafeHeight, self.view.cw_width, 44)];
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _toolBar.alpha = 0.7;
    CWImagePickerController *_CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    if (_CWImagePickerVc.allowPickingOriginalPhoto) {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _originalPhotoButton.selected = NO;
        _originalPhotoButton.frame = CGRectMake(5, 0, 120, 44);
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _originalPhotoButton.contentEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        _originalPhotoButton.backgroundColor = [UIColor clearColor];
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:@"原图" forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[CWResourceUtil imageNamed:@"img_nochoose_other.png"] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[CWResourceUtil imageNamed:@"img_choose.png"] forState:UIControlStateSelected];
        
        _originalPhotoLable = [[UILabel alloc] init];
        _originalPhotoLable.frame = CGRectMake(60, 0, 70, 44);
        _originalPhotoLable.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLable.font = [UIFont systemFontOfSize:13];
        _originalPhotoLable.textColor = [UIColor whiteColor];
        _originalPhotoLable.backgroundColor = [UIColor clearColor];
        if (_isSelectOriginalPhoto) [self showPhotoBytes];
    }
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.frame = CGRectMake(self.view.cw_width - 44 - 12, 0, 44, 44);
    _okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_okButton setTitle:_CWImagePickerVc.confirmTitle forState:UIControlStateNormal];
    [_okButton setTitleColor:_CWImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
    [_okButton setTitleColor:_CWImagePickerVc.oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    _numberImageView = [[UIImageView alloc] initWithImage:[CWResourceUtil imageNamed:@"img_number_icon.png"]];
    _numberImageView.backgroundColor = [UIColor clearColor];
    _numberImageView.frame = CGRectMake(self.view.cw_width - 56 - 24, 9, 26, 26);
    _numberImageView.hidden = _CWImagePickerVc.selectedModels.count <= 0;
    
    _numberLable = [[UILabel alloc] init];
    _numberLable.frame = _numberImageView.frame;
    _numberLable.font = [UIFont systemFontOfSize:16];
    _numberLable.textColor = [UIColor whiteColor];
    _numberLable.textAlignment = NSTextAlignmentCenter;
    _numberLable.text = [NSString stringWithFormat:@"%zd",_CWImagePickerVc.selectedModels.count];
    _numberLable.hidden = _CWImagePickerVc.selectedModels.count <= 0;
    _numberLable.backgroundColor = [UIColor clearColor];
    
    [_originalPhotoButton addSubview:_originalPhotoLable];
    [_toolBar addSubview:_okButton];
    [_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLable];
    [self.view addSubview:_toolBar];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.cw_width, self.view.cw_height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.cw_width , self.view.cw_height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.view.cw_width * _models.count, self.view.cw_height);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CWPhotoPreviewCell class] forCellWithReuseIdentifier:@"CWPhotoPreviewCell"];
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    CWImagePickerController *_CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    CWAssetModel *model = _models[_currentIndex];
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_CWImagePickerVc.selectedModels.count >= _CWImagePickerVc.maxImagesCount) {
            [_CWImagePickerVc showAlertWithTitle:[NSString stringWithFormat:@"你最多可以选择%zd张照片",_CWImagePickerVc.maxImagesCount]];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [[CWImageManager manager] getTipWithAsset:model imageOverSize:_CWImagePickerVc.imageSize imageOverLength:_CWImagePickerVc.imageLength isSelectOriginal:!_isSelectOriginalPhoto completion:^(NSString *tip) {
                if (!tip) {
                    [_CWImagePickerVc.selectedModels addObject:model];
                    if (self.photos) {
                        [_CWImagePickerVc.selectedAssets addObject:_assetsTemp[_currentIndex]];
                        [self.photos addObject:_photosTemp[_currentIndex]];
                    }
                    if (model.type == CWAssetModelMediaTypeVideo) {
                        [_CWImagePickerVc showAlertWithTitle:@"多选状态下选择视频，默认将视频当图片发送"];
                    }
                    model.isSelected = !selectButton.isSelected;
                    [self refreshNaviBarAndBottomBarState];
                    if (model.isSelected) {
                        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:CWOscillatoryAnimationToBigger];
                    }
                    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:CWOscillatoryAnimationToSmaller];
                }else{
                    [_CWImagePickerVc showAlertWithTitle:tip];
                }
            }];
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_CWImagePickerVc.selectedModels];
        for (CWAssetModel *model_item in selectedModels) {
            if ([model.asset isEqual:model_item.asset]) {
                [_CWImagePickerVc.selectedModels removeObject:model_item];
                if (self.photos) {
                    [_CWImagePickerVc.selectedAssets removeObject:_assetsTemp[_currentIndex]];
                    [self.photos removeObject:_photosTemp[_currentIndex]];
                }
            }
        }
        model.isSelected = !selectButton.isSelected;
        [self refreshNaviBarAndBottomBarState];
        if (model.isSelected) {
            [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:CWOscillatoryAnimationToBigger];
        }
        [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:CWOscillatoryAnimationToSmaller];
    }
}

- (void)back {
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)okButtonClick {
    CWImagePickerController *_CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    if (_CWImagePickerVc.selectedModels.count == 0) {
        return;
//        CWAssetModel *model = _models[_currentIndex];
//        [_CWImagePickerVc.selectedModels addObject:model];
    }
    if (self.okButtonClickBlock) {
        self.okButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.okButtonClickBlockWithPreviewType) {
        self.okButtonClickBlockWithPreviewType(self.photos,_CWImagePickerVc.selectedAssets,self.isSelectOriginalPhoto);
    }
}

- (void)originalPhotoButtonClick {
    if (!_originalPhotoButton.isSelected) {
        __weak typeof(self) weakSelf = self;
        CWAssetModel *model = _models[_currentIndex];
        CWImagePickerController *CWImagePickerVc = (CWImagePickerController *)weakSelf.navigationController;

        [[CWImageManager manager] getTipWithAsset:model imageOverSize:CWImagePickerVc.imageSize imageOverLength:CWImagePickerVc.imageLength isSelectOriginal:!_isSelectOriginalPhoto completion:^(NSString *tip) {
            if (!tip) {
                _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
                _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
                _originalPhotoLable.hidden = !_originalPhotoButton.isSelected;
                if (_isSelectOriginalPhoto) {
                    [self showPhotoBytes];
                    if (!_selectButton.isSelected) [self select:_selectButton];
                }
            }else{
                [CWImagePickerVc showAlertWithTitle:tip];
            }
        }];
    }else{
        _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
        _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
        _originalPhotoLable.hidden = !_originalPhotoButton.isSelected;
        if (_isSelectOriginalPhoto) {
            [self showPhotoBytes];
            if (!_selectButton.isSelected) [self select:_selectButton];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _currentIndex = (offSet.x + (self.view.cw_width * 0.5)) / self.view.cw_width;
    [self refreshNaviBarAndBottomBarState];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CWPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CWPhotoPreviewCell" forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    
    __block BOOL _weakIsHideNaviBar = _isHideNaviBar;
    __weak typeof(_naviBar) weakNaviBar = _naviBar;
    __weak typeof(_toolBar) weakToolBar = _toolBar;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            _weakIsHideNaviBar = !_weakIsHideNaviBar;
            weakNaviBar.hidden = _weakIsHideNaviBar;
            weakToolBar.hidden = _weakIsHideNaviBar;
        };
    }
    return cell;
}

#pragma mark - Private Method

- (void)refreshNaviBarAndBottomBarState {
    CWImagePickerController *_CWImagePickerVc = (CWImagePickerController *)self.navigationController;
    CWAssetModel *model = _models[_currentIndex];
    _selectButton.selected = model.isSelected;
    _numberLable.text = [NSString stringWithFormat:@"%zd",_CWImagePickerVc.selectedModels.count];
    _numberImageView.hidden = (_CWImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar);
    _numberLable.hidden = (_CWImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar);
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLable.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (_isHideNaviBar) return;
    if (model.type == CWAssetModelMediaTypeVideo) {
        _originalPhotoButton.hidden = YES;
        _originalPhotoLable.hidden = YES;
    } else {
        _originalPhotoButton.hidden = NO;
        if (_isSelectOriginalPhoto)  _originalPhotoLable.hidden = NO;
    }
}

- (void)showPhotoBytes {
    [[CWImageManager manager] getPhotosBytesWithArray:@[_models[_currentIndex]] completion:^(NSString *totalBytes, NSInteger totalLength) {
        _originalPhotoLable.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

@end
