//
//  UILabel+NCubeWare.h
//  CubeWare
//
//  Created by 美少女 on 2018/1/5.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (NCubeWare)

/**
 设置UILabel基本配置

 @param frame 大小
 @param backgroundColor 背景颜色
 @param font 字体
 @param textAlignment 文字排列方式
 @param color 字体颜色
 @param highlightedColor 高亮颜色
 @return self
 */
+ (UILabel *)labelWithFrame:(CGRect)frame
            backgroundColor:(UIColor *)backgroundColor
                       font:(UIFont *)font
              textAlignment:(NSTextAlignment)textAlignment
                  textColor:(UIColor *)color
       highlightedTextColor:(UIColor *)highlightedColor;

/**
 设置圆角

 @param radius 圆角弧度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)setCornerRadius:(CGFloat)radius
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor;
@end
