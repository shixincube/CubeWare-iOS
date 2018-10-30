//
//  CWAuthorizePhotoLibrary.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/7.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizePhotoLibrary.h"
#import "CubeWareHeader.h"
#import <Photos/Photos.h>
@implementation CWAuthorizePhotoLibrary
+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed{
    BOOL isOpen;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    isOpen = YES;
    if (authStatus == PHAuthorizationStatusRestricted
        || authStatus == PHAuthorizationStatusDenied) {
        //无权限
        if (completed){completed(NO,nil);}
        
    }else if(authStatus == PHAuthorizationStatusAuthorized){
        
        if (completed){completed(YES,nil);}
        
    }else{
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            BOOL isAuthorized = (status == PHAuthorizationStatusAuthorized);
            if (completed){completed(isAuthorized,nil);}
            
        }];
    }
#else
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限
        if (completed){completed(NO,nil);}
        
    }else if(author == kCLAuthorizationStatusAuthorized){
        
        if (completed){completed(YES,nil);}
        
        
    }else if(author == kCLAuthorizationStatusNotDetermined){
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (*stop) {
                return;
            }
            *stop = TRUE;//不能省略
            if (completed){completed(YES,nil);}
            
        } failureBlock:^(NSError *error) {
            
            if (completed){completed(NO,nil);}
            
        }];
    }
    /*
     typedef enum {
     kCLAuthorizationStatusNotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
     kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
     kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
     kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据} CLAuthorizationStatus;
     }*/
    
#endif
}
@end
