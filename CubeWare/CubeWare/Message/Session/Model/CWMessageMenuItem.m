//
//  CWMessageMenuItem.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/6.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWMessageMenuItem.h"

@implementation CWMessageMenuItem

+(instancetype)itemWithTitle:(NSString *)title andIdentifier:(NSString *)identifier{
    CWMessageMenuItem *item = [[CWMessageMenuItem alloc] init];
    
    item.title = title;
    item.identifier = identifier;
    
    return item;
}

@end
