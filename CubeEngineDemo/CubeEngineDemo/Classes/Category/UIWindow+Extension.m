//
//  UIWindow+Extension.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "UIWindow+Extension.h"
//#import "XZTabBarViewController.h"
//#import "XZNewFeatureViewController.h"
@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    //上一次的使用的版本（存储在沙盒中的版本号）
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //当前软件的版本号
    NSString *currVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currVersion isEqualToString:lastVersion]) {
//        self.rootViewController = [XZTabBarViewController new];
    } else {
//        self.rootViewController = [[XZNewFeatureViewController alloc] init];
        //将版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
@end
