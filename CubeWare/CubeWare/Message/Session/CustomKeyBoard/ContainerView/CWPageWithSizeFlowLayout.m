//
//  CWPageWithSizeFlowLayout.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/30.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWPageWithSizeFlowLayout.h"

@interface CWPageWithSizeFlowLayout()

@property (nonatomic, strong) NSMutableArray<NSArray<UICollectionViewLayoutAttributes *> *> *attributesArrayM;

@end

@implementation CWPageWithSizeFlowLayout
/** 布局前做一些准备工作 */
- (void)prepareLayout
{
    [super prepareLayout];
    [self.sectionPageCountArr removeAllObjects];
    [self.sectionStartPositionXArr removeAllObjects];
    NSInteger sectionsCount = self.collectionView.numberOfSections;
    CGFloat totalWidth = 0;
    [self.sectionStartPositionXArr addObject:@(totalWidth)];
    for (int section = 0; section < sectionsCount; section ++) {
        NSMutableArray * sectionAttrbutesArr = [NSMutableArray array];
        // 从collectionView中获取到有多少个item
        NSInteger itemCountInSection = [self.collectionView numberOfItemsInSection:section];
        // 遍历出item的attributes,把它添加到管理它的属性数组中去
        for (int row = 0; row < itemCountInSection; row++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
            [sectionAttrbutesArr addObject:attributes];
        }
        [self.attributesArrayM addObject:sectionAttrbutesArr];
        
        // 计算每个section的宽度
        NSInteger rowCount = [self rowCountInSection:section];
        NSInteger columnCount = [self columnCountInSection:section];
        NSInteger itemCount = rowCount * columnCount;
        NSInteger pageNumber = (NSInteger)ceil((CGFloat)itemCountInSection / itemCount);
        CGFloat currentSectonWith = pageNumber * self.collectionView.frame.size.width;
        totalWidth = totalWidth + currentSectonWith;
        [self.sectionStartPositionXArr addObject:@(totalWidth)];
        [self.sectionPageCountArr addObject:@(pageNumber)];
    }
    
}

/** 设置每个item的属性(主要是frame) */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    CGSize itemSize = [self itemSizeAtSection:indexPath.section];
    NSInteger realRow = [self rowCountInSection:section];
    NSInteger realColumn = [self columnCountInSection:section];
    UIEdgeInsets edgeInsets = [self edgeInsetsInSection:section];
    CGFloat interitemSpacing = [self interitemSpacingInSection:section];
    CGFloat LineSpacing = [self LineSpacingInSection:section];
    
    if (realRow == 1) {//强制垂直居中
        CGFloat space = (self.collectionView.frame.size.height - itemSize.height) / 2;
        edgeInsets = UIEdgeInsetsMake(space, edgeInsets.left, space, edgeInsets.right);
    }
    if (realColumn == 1) {//强制水平居中
         CGFloat space = (self.collectionView.frame.size.width - itemSize.width) / 2;
        edgeInsets = UIEdgeInsetsMake(edgeInsets.top, space, edgeInsets.bottom, space);
    }
    
    
    CGFloat itemWidth = itemSize.width;
    CGFloat itemHeight = itemSize.height;
    
    NSInteger item = indexPath.row;
    // 当前item所在的页
    NSInteger itemsCountInPage = realColumn * realRow;
    NSInteger pageNumber = item / itemsCountInPage;
    NSInteger currentPageIndex = item % (itemsCountInPage);
    NSInteger x = currentPageIndex % realColumn;
    NSInteger y = currentPageIndex / realColumn;
    
    // 计算坐标
    CGFloat itemX = self.collectionView.frame.size.width * pageNumber + edgeInsets.left + (interitemSpacing + itemWidth) * x + [self.sectionStartPositionXArr[indexPath.section]  floatValue];
    CGFloat itemY = edgeInsets.top + (LineSpacing + itemHeight) * y;
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 每个item的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attributes;
}

/** 计算collectionView的滚动范围 */
- (CGSize)collectionViewContentSize
{
    NSInteger sectionCount = self.collectionView.numberOfSections;
    CGFloat totalWidth = 0;
    for (int section = 0; section < sectionCount; section ++) {
        // 从collectionView中获取到有多少个item
        NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:section];
        // 理论上每页展示的item数目
        NSInteger rowCount = [self rowCountInSection:section];
        NSInteger column = [self columnCountInSection:section];
        NSInteger itemCount = rowCount * column;
        // 除数（用于判断页数）
        NSInteger pageNumber = (NSInteger)ceil((CGFloat)itemTotalCount / itemCount);
        CGFloat currentSectonWith = pageNumber * self.collectionView.frame.size.width;
        totalWidth = totalWidth + currentSectonWith;
    }
    
    // 只支持水平方向上的滚动
    return CGSizeMake(totalWidth, 0);
}



/** 返回collectionView视图中所有视图的属性数组 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * arr = [NSMutableArray array];
    [self.attributesArrayM enumerateObjectsUsingBlock:^(NSArray<UICollectionViewLayoutAttributes *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull LayoutAttributes, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:LayoutAttributes];
        }];
    }];
    return arr.copy;
}
//真实的行间距
-(CGFloat)LineSpacingInSection:(NSInteger)section{
    NSInteger realRowCount = [self rowCountInSection:section];
    if (realRowCount == 1) return 0;
    UIEdgeInsets edgeInsets = [self edgeInsetsInSection:section];
    CGSize itemSize = [self itemSizeAtSection:section];
     CGFloat LineSpacing = (self.collectionView.frame.size.height - edgeInsets.top - edgeInsets.bottom - realRowCount * itemSize.height) / (realRowCount - 1);
    return LineSpacing;
}
//真实的列间距
-(CGFloat)interitemSpacingInSection:(NSInteger)section{
    NSInteger realColumnCount = [self columnCountInSection:section];
    if (realColumnCount == 1) return 0;
    UIEdgeInsets edgeInsets = [self edgeInsetsInSection:section];
    CGSize itemSize = [self itemSizeAtSection:section];
     CGFloat interitemSpacing = (self.collectionView.frame.size.width - edgeInsets.right - edgeInsets.left - realColumnCount * itemSize.width) / (realColumnCount - 1);
    return interitemSpacing;
}
//行数
-(NSInteger)rowCountInSection:(NSInteger)section{
    UIEdgeInsets edgeInsets = [self edgeInsetsInSection:section];
    CGFloat minimumLineSpacing = [self minimumLineSpacingInSection:section];
    CGSize itemSize = [self itemSizeAtSection:section];
    //        self.collectionView.frame.size.height = edgeInsets.top + edgeInsets.top + (n -1) * minimumLineSpacing + n *itemSize.heightx
    CGFloat reckonRow = (self.collectionView.frame.size.height - edgeInsets.top - edgeInsets.bottom + minimumLineSpacing) / (itemSize.height + minimumLineSpacing);
    NSInteger realRow = (NSInteger)floorf(reckonRow);
    return realRow;
}
//列数
-(NSInteger)columnCountInSection:(NSInteger)section{
    UIEdgeInsets edgeInsets = [self edgeInsetsInSection:section];
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingInSection:section];
    CGSize itemSize = [self itemSizeAtSection:section];
    //    self.collectionView.frame.size.width = edgeInsets.right + edgeInsets.left + (n -1) * minimumInteritemSpacing + n *itemSize.width
    CGFloat reckonColumn = (self.collectionView.frame.size.width - edgeInsets.right - edgeInsets.left + minimumInteritemSpacing) / (itemSize.width + minimumInteritemSpacing);
    NSInteger realColumn = (NSInteger)floorf(reckonColumn);
    return realColumn;
}

-(CGFloat)minimumLineSpacingInSection:(NSInteger)section{
    CGFloat minimumLineSpacing;
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimumLineSpacing = [_delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }else{
        minimumLineSpacing = self.minimumLineSpacing;
    }
    return minimumLineSpacing;
}

-(CGFloat)minimumInteritemSpacingInSection:(NSInteger)section{
    CGFloat minimumInteritemSpacing;
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [_delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }else{
        minimumInteritemSpacing = self.minimumInteritemSpacing;
    }
    return minimumInteritemSpacing;
}

-(UIEdgeInsets)edgeInsetsInSection:(NSInteger)section{
    UIEdgeInsets edgeInsets;
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        edgeInsets = [_delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }else{
        edgeInsets = self.sectionInset;
    }
    return edgeInsets;
}

-(CGSize)itemSizeAtSection:(NSInteger)section{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    CGSize itemSize ;
    if (_delegate && [_delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        itemSize = [_delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }else{
        itemSize = self.itemSize;
    }
    UIEdgeInsets edgeInsets = [self edgeInsetsInSection:indexPath.section];
    CGFloat maxH = self.collectionView.frame.size.height - edgeInsets.top - edgeInsets.bottom;
    CGFloat maxW = self.collectionView.frame.size.width - edgeInsets.right - edgeInsets.left;
    itemSize.height = itemSize.height < maxH ? itemSize.height : maxH;
    itemSize.width = itemSize.width < maxW ? itemSize.width :maxW;
    return itemSize;
}
#pragma mark - Lazy
- (NSMutableArray *)attributesArrayM
{
    if (!_attributesArrayM) {
        _attributesArrayM = [NSMutableArray array];
    }
    return _attributesArrayM;
}
-(NSMutableArray *)sectionStartPositionXArr{
    if (!_sectionStartPositionXArr) {
        _sectionStartPositionXArr = [NSMutableArray array];
    }
    return _sectionStartPositionXArr;
}
-(NSMutableArray *)sectionPageCountArr{
    if (!_sectionPageCountArr){
        _sectionPageCountArr = [NSMutableArray array];
    }
    return _sectionPageCountArr;
}
@end
