//
//  CWPopView.h
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/22.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDPopView;

@protocol PopViewDelegate <NSObject>

@optional

/**
 选择选项

 @param popView 弹框
 @param selectedIndex 选项角标
 */
- (void)popView:(CDPopView *)popView didSelectedIndex:(NSInteger)selectedIndex;

/**
 隐藏弹出框
 */
- (void)hidePopView;

@end

@interface CDPopView : UIView

@property (nonatomic, weak) id <PopViewDelegate> popDelegate;

/**
 显示弹出框
 */
- (void)showPop;

@end
