//
//  UIButton+CubeWare.m
//  CubeWare
//
//  Created by Mario on 2017/6/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "UIButton+NCubeWare.h"

//判断一个对象是否为空
#define CW_CHECK_NIL(_object) \
(_object == nil || [_object isKindOfClass:[NSNull class]])

//判断一个对象是否属于指定类型
#define CW_CHECK_CLASS(_object, _class) \
(!CW_CHECK_NIL(_object) \
&& [_object isKindOfClass:[_class class]])

@implementation UIButton (NCubeWare)
#pragma mark - Title
- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color selectedColor:color];
}

- (void)setTitleColor:(UIColor *)color
        selectedColor:(UIColor *)selectedColor
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:selectedColor forState:UIControlStateDisabled];
    [self setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
}

- (void)setTitle:(NSString*)title
{
    [self setTitle:title selectedTitle:title];
}

- (void)setTitle:(NSString *)title
   selectedTitle:(NSString *)selectedTitle
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

#pragma mark - image
- (void)setImageWithName:(NSString *)name{
    [self setImage:[self packupImageWithName:name]
          forState:UIControlStateNormal];
}

- (void)setSelectedImageWithName:(NSString *)selectedName{
    [self setImage:[self packupImageWithName:selectedName]
          forState:UIControlStateSelected];
}

- (void)setHighlightedImageWithName:(NSString *)highlightedName{
    [self setImage:[self packupImageWithName:highlightedName]
          forState:UIControlStateHighlighted];
}

- (void)setBackgroundWithImageName:(NSString *)name{
    [self setBackgroundWithImageName:name
                           capInsets:UIEdgeInsetsZero];
}

- (void)setBackgroundWithImageName:(NSString *)name
                 selectedImageName:(NSString *)selectedImageName{
    [self setBackgroundWithImageName:name
                   selectedImageName:selectedImageName
                highlightedImageName:nil
                   disabledImageName:nil
                           capInsets:UIEdgeInsetsZero];
}

- (void)setBackgroundWithImageName:(NSString *)name
                         capInsets:(UIEdgeInsets)insets{
    
    UIImage *normalImage = [self packupImageWithName:name];
    if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        [normalImage resizableImageWithCapInsets:insets];
    }
    [self setBackgroundImage:normalImage
                    forState:UIControlStateNormal];
}

- (void)setBackgroundWithImageName:(NSString *)name
                 selectedImageName:(NSString *)selectedImageName
                         capInsets:(UIEdgeInsets)insets{
    [self setBackgroundWithImageName:name
                   selectedImageName:selectedImageName
                highlightedImageName:nil
                   disabledImageName:nil
                           capInsets:insets];
}

- (void)setBackgroundWithImageName:(NSString *)imageName
                 selectedImageName:(NSString *)selectedImageName
              highlightedImageName:(NSString *)highlightedImageName
                 disabledImageName:(NSString *)disabledImageName
                         capInsets:(UIEdgeInsets)insets{
    
    UIImage *normalImage = [self packupImageWithName:imageName];
    UIImage *selectedImage = [self packupImageWithName:selectedImageName];
    UIImage *highlightedImage = [self packupImageWithName:highlightedImageName];
    UIImage *disabledImage = [self packupImageWithName:disabledImageName];
    
    if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        [normalImage resizableImageWithCapInsets:insets];
        [selectedImage resizableImageWithCapInsets:insets];
        [highlightedImage resizableImageWithCapInsets:insets];
        [disabledImage resizableImageWithCapInsets:insets];
    }
    
    if (!selectedImage) {
        selectedImage = normalImage;
    }
    
    if (!highlightedImage) {
        highlightedImage = normalImage;
    }
    
    if (!disabledImage) {
        disabledImage = normalImage;
    }
    
    [self setBackgroundImage:normalImage
                    forState:UIControlStateNormal];
    [self setBackgroundImage:selectedImage
                    forState:UIControlStateSelected];
    [self setBackgroundImage:highlightedImage
                    forState:UIControlStateHighlighted];
    [self setBackgroundImage:disabledImage
                    forState:UIControlStateDisabled];
}

- (UIImage *)packupImageWithName:(NSString *)name{
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target
             action:action
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeTarget:(id)target action:(SEL)action
{
    [self removeTarget:target
                action:action
      forControlEvents:UIControlEventTouchUpInside];
}

- (void)enableHighlightedForSubView
{
    [self addTarget:self
             action:@selector(onTouchForSelection:)
   forControlEvents:UIControlEventTouchDown];
    [self addTarget:self
             action:@selector(onTouchForDeselect:)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self
             action:@selector(onTouchForSelection:)
   forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self
             action:@selector(onTouchForDeselect:)
   forControlEvents:UIControlEventTouchDragExit];
}

- (void)onTouchForSelection:(id)sender
{
    [self setHighlightedForSubView:YES];
}

- (void)onTouchForDeselect:(id)sender
{
    [self setHighlightedForSubView:NO];
}

- (void)setHighlightedForSubView:(BOOL)highlighted
{
    for (UIView *view in self.subviews) {
        if (CW_CHECK_CLASS(view, UILabel)) {
            UILabel *label = (UILabel *)view;
            label.highlighted = highlighted;
        } else if (CW_CHECK_CLASS(view, UIImageView)) {
            UIImageView *imageView = (UIImageView *)view;
            imageView.highlighted = highlighted;
        }
    }
}

- (UIFont *)titleFont
{
    return self.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

@end
