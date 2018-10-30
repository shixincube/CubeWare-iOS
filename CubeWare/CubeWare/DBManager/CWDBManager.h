//
//  CWDBManager.h
//  CubeWare
//
//  Created by 曾長歡 on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CWDiskCacheProtocol.h"
#import "CWMessageDBProtocol.h"
#import "CWSessionDBProtocol.h"
#import "CWInfoRefreshDelegate.h"

@class WCTDatabase;
@protocol CWDBManagerDelegate<NSObject>

@optional

/**
 当需要自己提供数据库时，实现此方法
 
 @note 实现此方法后，内部不在提供数据库
 @return 数据库
 */
-(WCTDatabase *)customDataBase;

@end

@interface CWDBManager : NSObject<CWMessageDBProtocol,CWSessionDBProtocol,CWInfoRefreshDelegate>

@property (nonatomic, weak) id<CWDBManagerDelegate> delegate;

@property (nonatomic, strong) WCTDatabase *database;

+(instancetype)shareManager;

#pragma mark - manage table

/**
 添加并创建表

 @param classes 实现了创建表协议的类
 */
-(void)addTableOfClass:(NSArray<Class<CWDiskCacheProtocol>> *)classes;

/**
 重新创建/刷新 表
 */
-(void)creatTableForCurrentDatabase;

@end
