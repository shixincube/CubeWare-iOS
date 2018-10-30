//
//  CWHttpClient.h
//  CubeWare
//
//  Created by Mario on 17/2/14.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWHttpClient : NSObject

+ (CWHttpClient *)defaultClient;

/**
 * @brief 判断网络连接接口
 * @return 判断网络连接
 */
- (BOOL)isConnectionAvailable;

@end
