//
//  UILabel+NCubeWare.m
//  CubeWare
//
//  Created by 美少女 on 2018/1/5.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "UILabel+NCubeWare.h"

@implementation UILabel (NCubeWare)

+ (UILabel *)labelWithFrame:(CGRect)frame
            backgroundColor:(UIColor *)backgroundColor
                       font:(UIFont *)font
              textAlignment:(NSTextAlignment)textAlignment
                  textColor:(UIColor *)color
       highlightedTextColor:(UIColor *)highlightedColor{

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backgroundColor;
    label.font = font;
    label.textAlignment = textAlignment;
    label.textColor = color;
    if (!highlightedColor) {
        highlightedColor = [UIColor whiteColor];
    }
    label.highlightedTextColor = highlightedColor;
    return label;
}

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{

    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.clipsToBounds = YES;

}
@end
