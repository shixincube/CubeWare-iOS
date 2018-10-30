//
//  CWPageWithSizeFlowLayout.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/30.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWPageWithSizeFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

@end

@interface CWPageWithSizeFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CWPageWithSizeFlowLayoutDelegate> delegate;





/**
 每个section的开始位置，最后一个元素存放的是最后最后一页的结束位置
 */
@property (nonatomic, strong) NSMutableArray *sectionStartPositionXArr;
/**
 每个section 的页数
 */
@property (nonatomic, strong) NSMutableArray *sectionPageCountArr;

@end
