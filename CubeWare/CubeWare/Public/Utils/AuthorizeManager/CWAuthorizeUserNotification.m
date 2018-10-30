//
//  CWAuthorizeUserNotification.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizeUserNotification.h"

@implementation CWAuthorizeUserNotification
+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed
{
    if(completed == nil){
        return;
    }
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    switch (settings.types)
    {
        case UIUserNotificationTypeNone:
            completed(NO,nil);
            break;
        case UIUserNotificationTypeAlert:
            completed(YES,nil);
            break;
        case UIUserNotificationTypeBadge:
            completed(YES,nil);
            break;
        case UIUserNotificationTypeSound:
            completed(YES,nil);
            break;
            
        default:
            break;
    }
    
    
}
+ (UIUserNotificationType)types
{
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return settings.types;
}
@end
