//
//  CWAuthorizeTelephony.h
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorize.h"

@interface CWAuthorizeTelephony : CWAuthorize
/*
 联网状态检测
 返回： 无网络/2G/3G/4G/wifi(wifi路由无网络时不做区分)
 */
+ (NSString *)networkStatus;

@end
