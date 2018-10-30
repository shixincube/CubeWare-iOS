//
//  CDHudUtil.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/4.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDHudUtil : NSObject

+ (void)showToastWithMessage:(NSString *)message
                    duration:(NSTimeInterval )duration
                  completion:(void(^)(void))block;
+ (void)showDefultHud;
+ (void)hideDefultHud;
@end
