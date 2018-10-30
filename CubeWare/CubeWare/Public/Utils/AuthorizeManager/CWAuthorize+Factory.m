//
//  CWAuthorize+Factory.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorize+Factory.h"
#import "CWAuthorizeLocation.h"
#import "CWAuthorizePhotoLibrary.h"
#import "CWAuthorizeCamera.h"
#import "CWAuthorizeMIC.h"
#import "CWAuthorizeAddressBook.h"

@implementation CWAuthorize (Factory)

+ (void)authorizeForType:(CWAuthorizeType)type
               completed:(CWAuthorizeCompleted)completed
{
    
    switch (type) {
        case CWAuthorizeTypeLocatioin:{
            [CWAuthorizeLocation authorizeCompleted:completed];
            break;
        }
        case CWAuthorizeTypePhotoLibrary:{
            [CWAuthorizePhotoLibrary authorizeCompleted:completed];
            break;
        }
        case CWAuthorizeTypeCamera:{
            [CWAuthorizeCamera authorizeCompleted:completed];
            break;
        }
        case CWAuthorizeTypeMIC:{
            [CWAuthorizeMIC authorizeCompleted:completed];
            break;
        }
        case CWAuthorizeTypeAddressBook:{
            [CWAuthorizeAddressBook authorizeCompleted:completed];
            break;
        }
            
        default:
            break;
    }
    
    
}
@end
