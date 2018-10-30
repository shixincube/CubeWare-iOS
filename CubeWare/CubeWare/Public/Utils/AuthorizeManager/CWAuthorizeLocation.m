//
//  CWAuthorizeLocation.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/7.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizeLocation.h"
@interface CWAuthorizeLocation ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,copy) void(^location_completed)(BOOL isAllow,NSError *error);

@end

@implementation CWAuthorizeLocation
+ (instancetype)global
{
    static CWAuthorizeLocation *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[CWAuthorizeLocation alloc] init];
    });
    return obj;
}

+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed
{
    //检测的是整个的iOS系统的定位服务是否开启
    if (![CLLocationManager locationServicesEnabled])
    {
        if (completed){
            completed(NO,nil);
        }
        return;
    }
    CLLocationManager *temp = [[CLLocationManager alloc] init];
    [[self global] setLocationManager:temp];
    [[self global] setLocation_completed:[completed copy]];
    temp.delegate = [self global];
    
    [temp requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    manager.delegate = nil;
    [self setLocationManager:nil];
    
    if (!self.location_completed){return ;}
    self.location_completed(YES,nil);
    self.location_completed = nil;
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined){return;}
    
    manager.delegate = nil;
    [self setLocationManager:nil];
    
    if (!self.location_completed){return ;}
    
    if (status != kCLAuthorizationStatusAuthorizedAlways
        && status != kCLAuthorizationStatusAuthorizedWhenInUse){
        
        self.location_completed(NO,nil);
        
    }else{
        self.location_completed(YES,nil);
    }
    self.location_completed = nil;
    
}
@end
