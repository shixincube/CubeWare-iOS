//
//  CDContactsManager.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/14.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDContactsManager : NSObject
+ (CDContactsManager *)shareInstance;

/**
 群组列表
 */
@property (nonatomic,strong) NSMutableArray * grouplist;

/**
 获取群组列表
 */
- (void)getGroupList;

/**
获取好友列表
 */
- (void)getFriendList;
@end
