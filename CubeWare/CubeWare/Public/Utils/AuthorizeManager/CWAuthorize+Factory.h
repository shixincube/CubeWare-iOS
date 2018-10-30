//
//  CWAuthorize+Factory.h
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorize.h"
typedef NS_ENUM(NSUInteger,CWAuthorizeType){
    
    CWAuthorizeTypeLocatioin,//位置
    CWAuthorizeTypePhotoLibrary,//相册
    CWAuthorizeTypeCamera,//相机
    CWAuthorizeTypeMIC,//麦克风
    CWAuthorizeTypeAddressBook,//通讯录
    
};

@interface CWAuthorize (Factory)

+ (void)authorizeForType:(CWAuthorizeType)type
               completed:(CWAuthorizeCompleted)completed;

@end
