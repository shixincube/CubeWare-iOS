//
//  CWMoreBoardView.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWToolBarItemModel.h"

@class CWMoreBoardView;

@protocol CWMoreBoardViewDelegate<NSObject>

@optional

/**
 选中某一个按钮

 @param moreBoardView moreBoardView
 @param index 选中索引
 */
- (void)moreBoardView:(CWMoreBoardView *)moreBoardView didSelectAtIndex:(NSInteger) index;

@end

@interface CWMoreBoardView : UIView

@property (nonatomic, strong) NSArray<CWToolBarItemModel *> *moreItemsArr;
@property (nonatomic, weak) id<CWMoreBoardViewDelegate> delegate;
@end
