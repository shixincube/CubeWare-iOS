//
//  CWAuthorizeCamera.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizeCamera.h"
@implementation CWAuthorizeCamera
+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted
        || authStatus ==AVAuthorizationStatusDenied)
    {
        if (completed){completed(NO,nil);}
    }
    else if(authStatus == AVAuthorizationStatusAuthorized)
    {
        if (completed){completed(YES,nil);}
    }
    else
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
        {
            if (completed) { completed(granted,nil);}
        }];
    }
    
}
@end
