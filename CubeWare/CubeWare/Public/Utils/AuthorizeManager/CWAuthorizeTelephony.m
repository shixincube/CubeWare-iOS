//
//  CWAuthorizeTelephony.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizeTelephony.h"
#import <CoreTelephony/CTCellularData.h>
#import <UIKit/UIKit.h>

@implementation CWAuthorizeTelephony
+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed
{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState _state = cellularData.restrictedState;
    if(_state == kCTCellularDataRestrictedStateUnknown)
    {
        cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state)
        {
            //获取联网状态
            switch (state) {
                case kCTCellularDataRestricted:
                    if(completed){completed(NO,nil);}
                    break;
                case kCTCellularDataNotRestricted:
                    if(completed){completed(YES,nil);}
                    break;
                case kCTCellularDataRestrictedStateUnknown:
                    if(completed){completed(NO,nil);}
                    break;
                default:
                    break;
            };
        };
    }
    else
    {
        if(completed == nil)
        {
            return;
        }
        if (_state == kCTCellularDataRestricted)
        {
            completed(NO,nil);
        }
        else if (_state == kCTCellularDataNotRestricted)
        {
            completed(YES,nil);
        }
    }
}

+ (NSString *)networkStatus
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
        //根据状态选择
    }
    return state;
}

@end
