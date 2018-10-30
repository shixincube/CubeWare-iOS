//
//  CDConferenceManager.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/10.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConferenceManager.h"
@interface CDConferenceManager ()

@end

@implementation CDConferenceManager

+ (CDConferenceManager *)shareInstance
{
    static CDConferenceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CDConferenceManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.conferenceList = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray  *)conferenceList
{
    return _conferenceList;
}

-(void)queryConferencesWithGroupIds:(NSArray *)groupIds
                         completion:(void(^)(NSArray *conferences))completion
                            failure:(void(^)(CubeError *error))failure
{
    //查询当前进行中的会议
    __block NSArray *array ;
    __weak typeof(self) weakSelf = self;
    [[CubeWare sharedSingleton].conferenceService queryConferenceWithConferenceType:@[]
                                                                           groupIds:groupIds
                                                                         completion:^(NSArray *conferences)
     {
         //存储当前进行中的会议
         if(conferences != nil)
         {
            array = conferences;
            self.conferenceList = array;
         }
         if(completion)
         {
             completion(array);
         }
     } failure:^(CubeError *error) {
         //获取失败
         CWLog(@"queryConference error = %@", error);
         if (failure) {
             failure(error);
         }
     }];

}
@end
