//
//  CDHudUtil.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/4.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDHudUtil.h"
#define DEFULT_TAG  89757
@implementation CDHudUtil

+ (void)showToastWithMessage:(NSString *)message
                    duration:(NSTimeInterval )duration
                  completion:(void(^)(void))block{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];
    
    UIView *toastView = [[UIView alloc] init];
    toastView.layer.cornerRadius = 10;
    toastView.layer.masksToBounds = YES;
    toastView.backgroundColor = KWhiteColor;
    [bgView addSubview:toastView];
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(200, 80));
    }];
    
    UILabel *showMessage = [[UILabel alloc] init];
    showMessage.text = message;
    showMessage.font = [UIFont boldSystemFontOfSize:15];
    showMessage.textColor = RGBA(33, 33, 33, 1.f);
    [toastView addSubview:showMessage];
    
    [showMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toastView);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bgView removeFromSuperview];
        if (block) {
            block();
        }
    });
}

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

+ (void)showDefultHud
{
    [CDHudUtil initActivityIndicatorView];
}

+ (void)hideDefultHud
{
    UIWindow *  window = [self CWKeyWindow];
    UIView * backView = [window viewWithTag:DEFULT_TAG];
    [backView removeFromSuperview];
}
@end
