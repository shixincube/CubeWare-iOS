//
//  CWWorkerFinder.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWWorkerFinder : NSObject

/**
 获取默认的查找器

 @return finder
 */
+(instancetype)defaultFinder;

/**
 注册worker
 此方法不会对worker造成强引用，所以不用主动移除
 @param worker 待处理的worker
 @param protocols worker所提供的功能协议
 */
-(void)registerWorker:(id)worker forProtocols:(NSArray<Protocol *> *)protocols;

/**
 查找worker

 @param protocol 查找协议
 @return 实现了指定协议的worker列表
 */
-(NSArray *)findWorkerForProtocol:(Protocol *)protocol;

@end
