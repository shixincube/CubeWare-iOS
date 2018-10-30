//
//  CWCustomAlertView.h
//  CubeWare
//
//  Created by Mario on 2017/6/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWCustomAlertView;
typedef void (^CWCustomAlertBlock) (CWCustomAlertView *alertView, UITextField *textfield, NSInteger buttonIndex);

@protocol CWCustomAlertViewDelegate <NSObject>

@optional
- (void)customAlertView:(CWCustomAlertView *)alertView textField:(UITextField *)textField clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CWCustomAlertView : UIView

/**
 文本输入框
 */
@property (nonatomic, strong) UITextField *inputTextField;

/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *confirmButton;

/**
 文本的字数控制（默认20字符）
 */
@property (nonatomic, assign) NSInteger textLimitLength;

/**
 是否点击背景隐藏弹窗，默认NO
 */
@property (nonatomic, assign) BOOL shouldHideViewWhenTapBackground;

/**
 初始化自定义弹窗（含有TextField）类方法
 
 @param title 名称
 @param message 提示内容
 @param text textfield显示的文本信息
 @param placeholder textfield placeHolder
 @param delegate 代理
 @param buttonTitileAarray buttonTitileAarray 按钮标题数组(只支持2个button)
 @return 自定义弹窗对象
 */
+ (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                           delegate:(id <CWCustomAlertViewDelegate>)delegate
                                       buttonTitles:(NSArray *)buttonTitileAarray;
/**
 初始化自定义弹窗（含有TextField）实例方法
 
 @param title 名称
 @param message 提示内容
 @param text textfield显示的文本信息
 @param placeholder textfield placeHolder
 @param delegate 代理
 @param buttonTitileAarray 按钮标题数组
 @return 自定义弹窗对象
 */
- (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                           delegate:(id <CWCustomAlertViewDelegate>)delegate
                                       buttonTitles:(NSArray *)buttonTitileAarray;

//类方法
+ (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                       buttonTitles:(NSArray *)buttonTitileAarray
                                   customAlertBlock:(CWCustomAlertBlock)alertBlock;

/**
 初始化自定义弹窗（含有TextField）实例方法 Block回调
 
 @param title 名称
 @param message 提示内容
 @param text textfield显示的文本信息
 @param placeholder textfield placeHolder
 @param buttonTitileAarray 按钮标题数组
 @param alertBlock Block回调
 @return 自定义弹窗对象
 */
- (instancetype)initAlertViewWithTextFieldWithTitle:(NSString *)title
                                            message:(NSString *)message
                                               text:(NSString *)text
                                   placeholderTitle:(NSString *)placeholder
                                       buttonTitles:(NSArray *)buttonTitileAarray
                                   customAlertBlock:(CWCustomAlertBlock)alertBlock;
/**
 显示弹窗
 */
- (void)show;

+ (void)showNormalAlertWithTitle:(NSString*)title
                         message:(NSString*)message
                       leftTitle:(NSString*)leftTitle
                      rightTitle:(NSString*)rightTitle
                           hanle:(void(^)(NSString * buttonTitle))hanle;

@end
