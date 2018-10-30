//
//  CWToastUtil.h
//  CubeWare
//
//  Created by 美少女 on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWToastUtil : NSObject

+ (void)showTextMessage:(NSString*)text andDelay:(int)time;

+ (void)showDefultHud;

+ (void)hideDefultHud;

@end
