//
//  CWMoreBoardView.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWMoreBoardView.h"
#import "CWMoreItemCell.h"
#import "CWPageWithSizeFlowLayout.h"
#import "CWColorUtil.h"
#define rows 2
#define columns 4
static NSString *toolBarCellID = @"toolBarCellID";
@interface CWMoreBoardView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CWPageWithSizeFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIPageControl *pageCtl;
@property (nonatomic, strong) CWPageWithSizeFlowLayout *layout;

@end
@implementation CWMoreBoardView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self addSubview:self.collectionView];
        [self.collectionView addSubview:self.pageCtl];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.pageCtl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CWMoreItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:toolBarCellID forIndexPath:indexPath];
    cell.toolBarItemModel = self.moreItemsArr[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.moreItemsArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_delegate && [_delegate respondsToSelector:@selector(moreBoardView:didSelectAtIndex:)]){
        [_delegate moreBoardView:self didSelectAtIndex:indexPath.row];
    }
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentX = scrollView.contentOffset.x;
    __block NSInteger currentSection = 0;
    __block CGFloat currentSectionX = 0;
    [self.layout.sectionStartPositionXArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat sectionX = [obj floatValue];
        if (currentX >= sectionX) {
            currentSection = idx;
            currentSectionX = sectionX;
            *stop = YES;
        }
    }];
    NSInteger currentSectionPage = [self.layout.sectionPageCountArr[currentSection] integerValue];// 当前section 的页数
    NSInteger currentPage = (scrollView.contentOffset.x - currentSectionX) / scrollView.frame.size.width;
    self.pageCtl.numberOfPages = currentSectionPage;
    self.pageCtl.currentPage = currentPage;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = self.collectionView.frame.size.width / columns;
    CGFloat h = self.collectionView.frame.size.height / rows;
    return CGSizeMake(w, h);
}
#pragma mark - getters and setters
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[CWMoreItemCell class] forCellWithReuseIdentifier: toolBarCellID];
        
    }
    return _collectionView;
}

-(UIPageControl *)pageCtl{
    if (!_pageCtl) {
        _pageCtl = [[UIPageControl alloc] init];
        _pageCtl.pageIndicatorTintColor = [CWColorUtil colorWithRGB:0xcccccc andAlpha:1];
        _pageCtl.currentPageIndicatorTintColor = [CWColorUtil colorWithRGB:0x8a8fa4 andAlpha:1];
        _pageCtl.hidesForSinglePage = YES;
    }
    return _pageCtl;
}

-(CWPageWithSizeFlowLayout *)layout{
    if (!_layout) {
        _layout = [[CWPageWithSizeFlowLayout alloc] init];
        _layout.delegate = self;
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (void)setMoreItemsArr:(NSArray<CWToolBarItemModel *> *)moreItemsArr{
    _moreItemsArr = moreItemsArr;
    NSInteger numberofPages = (int)ceil((float) moreItemsArr.count / (columns * rows));
    self.pageCtl.hidesForSinglePage = YES;
    [self.collectionView reloadData];
}

@end
