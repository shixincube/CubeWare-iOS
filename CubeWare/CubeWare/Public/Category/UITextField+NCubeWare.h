//
//  UITextField+NCubeWare.h
//  CubeWare
//
//  Created by Mario on 2017/6/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (NCubeWare)
/**
 限制字数限制
 
 @param length 指定字数限制
 */
- (void)textInputLimitWithLength:(NSInteger)length;

@end
