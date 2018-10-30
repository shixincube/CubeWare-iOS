//
//  CWAuthorizeManager.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizeManager.h"
@interface CWAuthorizeManager()

@property (nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation CWAuthorizeManager

+ (instancetype)global
{
    static CWAuthorizeManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[CWAuthorizeManager alloc] initInner];
    });
    return obj;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initInner
{
    if (self = [super init])
    {
        self.semaphore = dispatch_semaphore_create(1);
        self.queue = dispatch_queue_create(@"CWAuthorizeManager".lowercaseString.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
+ (void)authorizeForType:(CWAuthorizeType)type
               completed:(CWAuthorizeCompleted)completed
{
    dispatch_async([[self global] queue], ^{
        dispatch_semaphore_wait([[self global] semaphore], DISPATCH_TIME_FOREVER);
        CWAuthorizeCompleted block = ^(BOOL isAllow,NSError *error) {
            if (completed)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completed(isAllow,error);
                });
            }
            dispatch_semaphore_signal([[self global] semaphore]);
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [CWAuthorize authorizeForType:type completed:block];
        });
    });
}
@end


















