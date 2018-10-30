//
//  CWTimeUtil.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWTimeSystemHR.h"

@interface CWTimeUtil : NSObject

/**
 获取当前时间戳(ms)
 
 @return 当前时间戳
 */
+(long long)currentTimestampe;

/**
  获取当前系统的时制
 
 @return 当前系统的时制
 */
+(CWTimeSystemHR)getTimeSystemHR;

@end
