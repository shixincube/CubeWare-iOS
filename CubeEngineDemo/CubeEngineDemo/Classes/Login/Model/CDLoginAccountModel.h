//
//  CDLoginAccountModel.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CubeEngineFoundationKit/CubeJsonObject.h>
#import <CubeEngineFoundationKit/CubeUser.h>

@interface CDLoginAccountModel : CubeUser 
@property (nonatomic,strong) NSString *appId;
@property (nonatomic,strong) NSString *testAppId;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger testTokenState;

@end
