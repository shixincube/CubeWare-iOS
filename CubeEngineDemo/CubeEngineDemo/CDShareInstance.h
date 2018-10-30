//
//  CDShareInstance.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDLoginAccountModel.h"

@interface CDShareInstance : NSObject

@property (nonatomic,strong) CDLoginAccountModel *loginModel;

@property (nonatomic,strong) NSArray *friendList; // 同appId下的其他账号充当好友列表

+ (CDShareInstance *)sharedSingleton;

@end
