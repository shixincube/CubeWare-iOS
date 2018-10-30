//
//  CWUserDelegate.h
//  CubeWare
//
//  Created by pretty on 2018/10/11.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#ifndef CWUserDelegate_h
#define CWUserDelegate_h
@protocol CWUserServiceDelegate <NSObject>
@optional
/**
  更新成功

 @param user 用户信息
 */
- (void)updateUserSuccess:(CubeUser *)user;

/**
 更新失败

 @param error 错误信息
 */
- (void)updateUserFailed:(CubeError *)error;
@end

#endif /* CWUserDelegate_h */
