//
//  CubeFileMessage+CWFileMessage.m
//  CubeWare
//
//  Created by jianchengpan on 2018/9/5.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CubeFileMessage+CWFileMessage.h"
#import <objc/runtime.h>

static const char * CWFileMessageReadedKey = "CWFileMessage_Readed";

@implementation CubeFileMessage (CWFileMessage)

- (BOOL)readed{
	return [objc_getAssociatedObject(self, CWFileMessageReadedKey) boolValue];
}

-(void)setReaded:(BOOL)readed{
	objc_setAssociatedObject(self, CWFileMessageReadedKey, @(readed), OBJC_ASSOCIATION_RETAIN);
}

@end
