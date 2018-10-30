//
//  CDMessageHelper.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/10/23.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWMessageService.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CDMessageHelperDelegate <NSObject>

@end

@interface CDMessageHelper : NSObject <CWMessageServiceDelegate>
+(CDMessageHelper *)instance;
@end

NS_ASSUME_NONNULL_END
