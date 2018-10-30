//
//  CWAuthorize.h
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/7.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CWAuthorizeCompleted)(BOOL isAllow,NSError *error);

@interface CWAuthorize : NSObject

+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed;

@end
