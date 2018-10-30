//
//  CWDatabaseModelProtocol.h
//  CubeWare_new
//
//  Created by jianchengpan on 2017/10/21.
//  Copyright © 2017年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CWDiskCacheProtocol

/**
 该类对应的表名

 @return 表名
 */
+(NSString *)tableName;

@optional

/**
 表对应的类
 用以解决WCDB无法使用实现相关协议类的子类来操作的问题，不实现改协议则使用当前类
 @return 实现WCDB相关协议的类
 */
+(Class)tableClass;

@end
