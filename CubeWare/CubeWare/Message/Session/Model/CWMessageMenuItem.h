//
//  CWMessageMenuItem.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/6.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWMessageMenuItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *identifier;

+(instancetype)itemWithTitle:(NSString *)title andIdentifier:(NSString *)identifier;

@end
