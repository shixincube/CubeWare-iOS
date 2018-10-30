//
//  CWAccountService.h
//  CubeWare
//
//  Created by 曾長歡 on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWUserModel.h"

@interface CWAccountService : NSObject<CubeUserServiceDelegate>

/**
 登入用户

 @param user 待登陆的用户
 @param token 动态token
 */

- (void)loginUser:(CWUserModel *)user withToken:(NSString *)token;

/**
 登出用户

 @param forceLogout 是否强制退出(在通话中的时候，使用forceLogout=YES，可以关闭通话，否则不能退出)
 */
- (void)logoutWithForce:(BOOL)forceLogout;

@end
