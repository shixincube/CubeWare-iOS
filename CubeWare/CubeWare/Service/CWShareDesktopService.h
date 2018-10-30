//
//  CWShareDesktopService.h
//  CubeWare
//
//  Created by pretty on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CWShareDesktopDelegate.h"
@interface CWShareDesktopService : NSObject <CubeShareDesktopServiceDelegate>

/**
 拒绝邀请

 @param shareDesktop 远程桌面
 */
- (void)rejectInvite:(CubeShareDesktop *)shareDesktop;

/**
 接收邀请

 @param shareDesktop 远程桌面
 */
- (void)acceptInvite:(CubeShareDesktop *)shareDesktop;


@end
