//
//  CWAuthorizeMIC.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizeMIC.h"
#import "CubeWareHeader.h"
@implementation CWAuthorizeMIC
+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            
            if (completed) { completed(granted,nil);}
            
        }];
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        
        if (completed){completed(NO,nil);}
        
    } else {
        
        if (completed){completed(YES,nil);}
        
    }
#else
    completed(NO,nil);
    
#endif
}
@end
