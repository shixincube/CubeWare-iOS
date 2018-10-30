//
//  CWToastUtil.m
//  CubeWare
//
//  Created by 美少女 on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWToastUtil.h"
#import "CWColorUtil.h"
#import "CWUtils.h"
#import "CubeWareHeader.h"

#define CW_INDICATORVIEW  123321

@implementation CWToastUtil
+ (CGFloat)widthWithheight:(CGFloat)height font:(CGFloat)font andTitle:(NSString *)title
{
    NSString * str =title ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
    
}

+ (CGFloat)heigthWithwidth:(CGFloat)width font:(CGFloat)font andTitle:(NSString *)title
{
    NSString * str =title ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

+ (void)showTextMessage:(NSString*)text andDelay:(int)time{
    //统一time为2s
    time = 2;
    UIView * backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor clearColor];
    UIView * customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 39)];
    customView.backgroundColor = [CWColorUtil colorWithRGB:0x000000 andAlpha:0.8];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, [CWUtils widthWithheight:14 font:14 andTitle:text], 15)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:14];
    lable.text = text;
    lable.numberOfLines = 0;
    [customView addSubview:lable];

    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;
    customView.frame = CGRectMake(0, 0, 20 + lable.frame.size.width, 39);
    if (customView.frame.size.width >= UIScreenWidth - 30) {
        lable.frame = CGRectMake(10, 12,  UIScreenWidth - 30 - 20, [CWUtils heigthWithwidth:UIScreenWidth - 30 - 20 font:14 andTitle:text]);
        customView.frame = CGRectMake(0, 0, UIScreenWidth - 30, 24 + lable.frame.size.height);
    }
    customView.center = CGPointMake(UIScreenWidth/2, UIScreenHeight/2);
    UIWindow * window = [CWUtils CWKeyWindow];
    [backView addSubview:customView];
    [window addSubview:backView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backView removeFromSuperview];
    });
}




//初始菊花view
+ (void)initActivityIndicatorView{
    
    UIWindow * window = [CWUtils CWKeyWindow];
    //注意，坐标中的window 貌似不止一个，这个获取到的window 是空的，其他项目就是用上面这个window
    UIView * backView;
    if ([window viewWithTag:CW_INDICATORVIEW]) {
        backView = [window viewWithTag:CW_INDICATORVIEW];
        [[window viewWithTag:CW_INDICATORVIEW] removeFromSuperview];
        [window addSubview:backView];
    }
    else
    {
        backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        backView.tag = CW_INDICATORVIEW;
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

+ (void)showDefultHud
{
    [CWToastUtil initActivityIndicatorView];
}

+ (void)hideDefultHud
{
    UIWindow *  window = [CWUtils CWKeyWindow];
    UIView * backView = [window viewWithTag:CW_INDICATORVIEW];
    [backView removeFromSuperview];
}

@end
