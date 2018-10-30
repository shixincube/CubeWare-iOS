//
//  CWColorUtil.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>
@interface CWColorUtil : NSObject

/**
 rgb颜色
 
 @param rgbValue rgb 16进制值
 @param alpha alpha description
 @return return UIColor
 */
+ (UIColor*)colorWithRGB:(int)rgbValue andAlpha:(CGFloat)alpha;


/**
 获取颜色

 @param hexString rgb16进制字符串
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;

@end
