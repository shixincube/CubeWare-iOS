//
//  CWUserModel.h
//  CubeWare
//
//  Created by 曾長歡 on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CubeUser CWUserModel;

@interface CubeUser(CubeWare)

/**
 备注名(备注名优先于用户名使用)
 */
@property (nonatomic, copy) NSString *remarkName;

/**
 获取合适的名称
 */
@property (nonatomic, readonly) NSString *appropriateName;

/**
 获取当前的用户
 
 @return 当前用户
 */
+(CWUserModel *)currentUser;

@end


