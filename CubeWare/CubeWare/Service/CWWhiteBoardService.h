//
//  CWWhiteBoardService.h
//  CubeWare
//
//  Created by Ashine on 2018/9/13.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWWhiteBoardDelegate.h"


@interface CWWhiteBoardService : NSObject <CubeWhiteBoardServiceDelegate>



/**
 加入白板

 @param whiteBoardId 白板id
 */
- (void)joinWhiteBoard:(NSString *)whiteBoardId;

/**
 退出白板

 @param whiteBoardId 白板id
 */
- (void)quitWhiteBoard:(NSString *)whiteBoardId;

/**
 接受白板邀请

 @param whiteboardId 白板id
 @param cubeId 邀请者id
 */
-(void)acceptInviteWhiteBoard:(NSString *)whiteboardId andInviter:(NSString *)cubeId;

/**
 拒绝白板邀请

 @param whiteboardId 白板id
 @param cubeId 邀请者id
 */
- (void)rejectInviteWhiteBoard:(NSString *)whiteboardId andInviter:(NSString *)cubeId;

/**
 邀请白板成员

 @param whiteBoardId 白板id
 @param members 成员cubeId数组
 */
- (void)inviteMemberInWhiteBoardId:(NSString *)whiteBoardId andMembers:(NSArray<NSString *> *)members;


/**
 当前是否正在进行白板演示

 @return 当前是否进行白板演示
 */
- (BOOL)currentWhiteboardActing;


@end
