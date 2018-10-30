//
//  CWFilePHAsssetModel.h
//  CubeWare
//
//  Created by Mario on 17/4/21.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface CWFilePHAsssetModel : NSObject

@property (nonatomic, strong) PHAsset *result;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, strong) NSString *timeString;

@end
