//
//  CWProgressHudTool.m
//  CubeWare
//
//  Created by Mario on 2017/7/7.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWProgressHudTool.h"
#import "UIView+NCubeWare.h"
#import "CWBezierView.h"
#import "CWUtils.h"
#import "CubeWareHeader.h"

#define DEFULT_TAG  89757

@implementation CWProgressHudTool

+ (void)showDefultHud{
    
    [CWProgressHudTool showProgressHudWithStyle:CWProgressHudStyleActivityIndicator];
}
+ (void)showProgressHudWithStyle:(CWProgressHudStyle)style {
    
    switch (style) {
        case CWProgressHudStyleActivityIndicator:
        {
            
            [CWProgressHudTool initActivityIndicatorView];
            
        }
            break;
        case CWProgressHudStyleRonateIndicator:
        {
            
            [CWProgressHudTool initRonateIndicatorView];
        }
            break;
        default:
            break;
    }
}

+ (void)showProgressHudWithTitle:(NSString *)title delay:(NSInteger)deleay{
    
    [CWProgressHudTool initTitleIndicatorView:title delay:deleay];
    
}
+ (void)hideCureentProgressHud
{
    UIWindow *  window = [self CWKeyWindow];
    UIView * backView = [window viewWithTag:DEFULT_TAG];
    [backView removeFromSuperview];
    
}
#pragma mark --Private Method
+ (UIWindow *)CWKeyWindow
{
    UIWindow * CWWindow = [[UIApplication sharedApplication].delegate window];
    return  CWWindow;
}
//初始菊花view
+ (void)initActivityIndicatorView{
    
    UIWindow * window = [self CWKeyWindow];
    //注意，坐标中的window 貌似不止一个，这个获取到的window 是空的，其他项目就是用上面这个window
    UIView * backView;
    if ([window viewWithTag:DEFULT_TAG]) {
        backView = [window viewWithTag:DEFULT_TAG];
        [[window viewWithTag:DEFULT_TAG] removeFromSuperview];
        [window addSubview:backView];
    }
    else
    {
        backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        backView.tag = DEFULT_TAG;
        [window addSubview:backView];
    }
    
    UIView  * loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingView.layer.cornerRadius = 15;
    loadingView.center = window.center;
    loadingView.backgroundColor = [UIColor grayColor];
    loadingView.clipsToBounds = YES;
    
    
    //菊花
    UIActivityIndicatorView * juhuaView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [juhuaView startAnimating];
    juhuaView.center = CGPointMake(50, 50);
    [loadingView addSubview:juhuaView];
    [backView addSubview:loadingView];
    
    
    
}
//初始化旋转view
+ (void)initRonateIndicatorView{
    
    UIWindow * window = [self CWKeyWindow];
    //注意，坐标中的window 貌似不止一个，这个获取到的window 是空的，其他项目就是用上面这个window
    UIView * backView;
    if ([window viewWithTag:DEFULT_TAG]) {
        backView = [window viewWithTag:DEFULT_TAG];
        [[window viewWithTag:DEFULT_TAG] removeFromSuperview];
        [window addSubview:backView];
    }
    else
    {
        backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        backView.tag = DEFULT_TAG;
        [window addSubview:backView];
    }
    
    CWBezierView  * loadingView = [[CWBezierView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    loadingView.layer.cornerRadius = 10;
    loadingView.clipsToBounds = YES;
    loadingView.center = window.center;
    loadingView.backgroundColor = [UIColor clearColor];
    
    
    
    
    [backView addSubview:loadingView];
    [window addSubview:backView];
    
}
//一闪而过的提示
+ (void)initTitleIndicatorView:(NSString*)title delay:(NSInteger)delay{
    
    UIWindow * window = [self CWKeyWindow];
    //注意，坐标中的window 貌似不止一个，这个获取到的window 是空的，其他项目就是用上面这个window
    UIView * backView;
    if ([window viewWithTag:DEFULT_TAG]) {
        backView = [window viewWithTag:DEFULT_TAG];
        [[window viewWithTag:DEFULT_TAG] removeFromSuperview];
        [window addSubview:backView];
    }
    else
    {
        backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        backView.tag = DEFULT_TAG;
        [window addSubview:backView];
    }
    
    UILabel  * loadingLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
    loadingLable.layer.cornerRadius = 3;
    loadingLable.center = window.center;
    loadingLable.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:1];
    loadingLable.textColor = UIColorFromRGB(0x333333);
    loadingLable.font = [UIFont systemFontOfSize:16];
    loadingLable.text = title;
    loadingLable.numberOfLines = 0;
    loadingLable.textAlignment = NSTextAlignmentCenter;
    loadingLable.clipsToBounds = YES;
    CGFloat maxWitdh = UIScreenWidth - 100;
    if ([CWUtils widthWithheight:16 font:16 andTitle:title] > maxWitdh) {
        
        loadingLable.cw_width = maxWitdh + 20;
        loadingLable.cw_height = [CWUtils heigthWithwidth:maxWitdh font:16 andTitle:title] + 3;
        loadingLable.center = window.center;
    }
    else
    {
        loadingLable.cw_width = [CWUtils widthWithheight:16 font:16 andTitle:title] + 5;
        loadingLable.center = window.center;
    }
    [backView addSubview:loadingLable];
    [window addSubview:backView];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backView removeFromSuperview];
    });
}



@end
