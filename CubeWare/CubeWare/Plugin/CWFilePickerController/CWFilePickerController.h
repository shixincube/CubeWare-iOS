//
//  CWFilePickerController.h
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CWFileManagerModel.h"
#import "CWFilePHAsssetModel.h"
@class CWFilePickerController, CWSegmentedControl;

@protocol CWFilePickerDelegate <NSObject>

- (void)filePickerControllerWithDic:(NSMutableDictionary *)mutableDic andController:(CWFilePickerController *)controller;

@end

@interface CWFilePickerController : UIViewController

@property (nonatomic, weak) id<CWFilePickerDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *allFileDataArr;

@end
