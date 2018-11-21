//
//  CDHudUtil.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/4.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDHudUtil : NSObject

/**
 显示toast

 @param message 文字
 @param duration 显示时长
 @param block 回调
 */
+ (void)showToastWithMessage:(NSString *)message
                    duration:(NSTimeInterval )duration
                  completion:(void(^)(void))block;

/**
 显示
 */
+ (void)showDefultHud;

/**
 隐藏
 */
+ (void)hideDefultHud;
@end
