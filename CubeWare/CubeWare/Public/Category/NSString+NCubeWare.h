//
//  NSString+NCubeWare.h
//  CubeWare
//
//  Created by luchuan on 2018/1/9.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NCubeWare)

/**
 传入时间戳返回 返回00:00:00 格式的数据

 @param duration 时间戳
 @return HH:mm:ss 的格式化数据，UTC 时区
 */
+(instancetype)stringWithTimeInterval:(NSTimeInterval) duration;

@end
