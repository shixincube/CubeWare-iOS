//
//  CWActionSheet.h
//  CubeWare
//
//  Created by Mario on 17/2/8.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CubeWareGlobalMacro.h"
@class CWActionSheet;

@protocol CWActionSheetDelegate <NSObject>

@optional

/**
 *  点击了 buttonIndex处 的按钮
 */
- (void)actionSheet:(CWActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CWActionSheet : UIView
/**
 *  返回一个 ActionSheet 对象, 类方法
 *
 *  @param title 提示标题
 *
 *  @param titles 所有按钮的标题
 *
 *  @param buttonIndex 红色按钮的index
 *
 *  @param delegate 代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
+ (instancetype)sheetWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)titles
                redButtonIndex:(NSInteger)buttonIndex
                      delegate:(id<CWActionSheetDelegate>)delegate;

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title 提示标题
 *
 *  @param titles 所有按钮的标题
 *
 *  @param buttonIndex 红色按钮的index
 *
 *  @param delegate 代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)titles
               redButtonIndex:(NSInteger)buttonIndex
                     delegate:(id<CWActionSheetDelegate>)delegate;

/**
 *  显示 ActionSheet
 */
- (void)show;

- (void)normalButton:(UIButton *)btn andSelected:(BOOL)selected andNormalLabel:(UILabel *)lbl andHighlighted:(BOOL)hilighted;

@end
