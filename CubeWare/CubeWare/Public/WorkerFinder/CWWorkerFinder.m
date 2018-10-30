//
//  CWWorkerFinder.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWWorkerFinder.h"

@interface CWWorkerFinder()

/**
 worker 注册记录表
 p:协议名
 w:worker
 ------------------------------
 |    p1   ->  [w1,w2,...,wn] |
 ----------------------------
 |    p2   ->  [w1,w2,...,wn] |
 ------------------------------
 |    ...  ->  [w1,w2,...,wn] |
 ------------------------------
 |    pn   ->  [w1,w2,...,wn] |
 ------------------------------
 */
@property (nonatomic, strong) NSMutableDictionary *workerRegistrationForm;

@end

@implementation CWWorkerFinder

+(instancetype)defaultFinder{
    static CWWorkerFinder *finder = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        finder = [[CWWorkerFinder alloc] init];
        finder.workerRegistrationForm = [NSMutableDictionary dictionary];
    });
    
    return finder;
}

-(void)registerWorker:(id)worker forProtocols:(NSArray<Protocol *> *)protocols{
    if(!worker || !protocols.count)
        return;
    
    for (Protocol *p in protocols) {
        NSPointerArray *workerArray = [self workerArrayForProtocol:p];
        if([[workerArray allObjects] indexOfObject:worker] == NSNotFound)
        {
            [workerArray addPointer:(__bridge void * _Nullable)(worker)];
        }
    }
}

-(NSArray *)findWorkerForProtocol:(Protocol *)protocol{
    return [[self workerArrayForProtocol:protocol] allObjects];
}

#pragma mark - private
-(NSPointerArray *)workerArrayForProtocol:(Protocol *)protocol{
    NSPointerArray *workerArray = [self.workerRegistrationForm objectForKey:NSStringFromProtocol(protocol)];
    [workerArray addPointer:NULL];
    [workerArray compact];
    if(!workerArray)
    {
        workerArray = [NSPointerArray weakObjectsPointerArray];
        [self.workerRegistrationForm setObject:workerArray forKey:NSStringFromProtocol(protocol)];
    }
    return workerArray;
}
@end
