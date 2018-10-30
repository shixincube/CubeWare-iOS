//
//  CWAuthorizeManager.h
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWAuthorize+Factory.h"

@interface CWAuthorizeManager : NSObject

+ (void)authorizeForType:(CWAuthorizeType)type
               completed:(CWAuthorizeCompleted)completed;

@end
