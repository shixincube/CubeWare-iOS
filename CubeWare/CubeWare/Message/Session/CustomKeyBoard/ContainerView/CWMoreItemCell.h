//
//  CWMoreItemCell.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWToolBarItemModel.h"
@interface CWMoreItemCell : UICollectionViewCell

/**
 期望的字号
 */
@property (nonatomic, assign) CGFloat expectFont;
/**
 期望的图片和文字间距
 */
@property (nonatomic, assign) CGFloat expectSpace;
/**
 CWToolBarItemModel
 */
@property (nonatomic, strong) CWToolBarItemModel *toolBarItemModel;

@end
