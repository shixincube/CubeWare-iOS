
//
//  CWAuthorizeAddressBook.m
//  CubeWare
//
//  Created by ZengChanghuan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWAuthorizeAddressBook.h"
//通讯录权限
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@implementation CWAuthorizeAddressBook

+ (void)authorizeCompleted:(CWAuthorizeCompleted)completed
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CNAuthorizationStatus cnAuthStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (cnAuthStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
            
            if (completed) { completed(granted,error);}
            
        }];
    } else if (cnAuthStatus == CNAuthorizationStatusRestricted || cnAuthStatus == CNAuthorizationStatusDenied) {
        
        if (completed){completed(NO,nil);}
        
    } else {
        
        if (completed){completed(YES,nil);}
        
    }
#else
    //ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    if (completed)
                    {
                        completed(NO,(__bridge NSError *)error);
                        
                    }
                }
                else
                {
                    if (completed)
                    {
                        completed(YES,nil);
                    }
                }
            });
        });
    }
    else
    {
        
        if (completed){completed(YES,nil);}
        
    }
#endif
    
}
@end
