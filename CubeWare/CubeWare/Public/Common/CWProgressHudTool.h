//
//  CWProgressHudTool.h
//  CubeWare
//
//  Created by Mario on 2017/7/7.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CWProgressHudStyle) {
    CWProgressHudStyleActivityIndicator = 0,//菊花指示器
    CWProgressHudStyleRonateIndicator,//无限旋转指示器
};

@interface CWProgressHudTool : NSObject

+ (void)showDefultHud;

+ (void)showProgressHudWithStyle:(CWProgressHudStyle)style;

+ (void)hideCureentProgressHud;

+ (void)showProgressHudWithTitle:(NSString*)title delay:(NSInteger)deleay;

@end
