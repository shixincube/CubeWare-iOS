//
//  CWAVSessionManager.h
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/16.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CWAVSessionManagerDelegate <NSObject>

@optional
/**
 耳机已经插入/拔出

 @param input yes: 插入 NO： 拔出
 */
- (void)avSessionManagerHandSpeakInput:(BOOL)input;
@end

@interface CWAVSessionManager : NSObject

@property (nonatomic, weak) id<CWAVSessionManagerDelegate> delegate;

+ (instancetype)shareInstance;
/**
 打开和关闭扬声器

 @param open YES 打开扬声器
 */
- (void)openSpeaker:(BOOL)open;

/**
 当前耳机已经插入

 @return yes ： 耳机已插入
 */
- (BOOL)areHeadphonesPluggedIn;


@end
