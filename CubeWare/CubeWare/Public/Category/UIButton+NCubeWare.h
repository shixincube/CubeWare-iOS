//
//  UIButton+NCubeWare.h
//  CubeWare
//
//  Created by Mario on 2017/6/29.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NCubeWare)
/**
 *  设置按钮标题颜色
 *
 *  @param color 颜色对象
 */
- (void)setTitleColor:(UIColor *)color;
/**
 *  设置按钮标题颜色
 *
 *  @param color          颜色对象
 *  @param selectedColor 点击后的颜色对象
 */
- (void)setTitleColor:(UIColor *)color
        selectedColor:(UIColor *)selectedColor;
/**
 *  设置按钮的标题
 *
 *  @param title 标题
 */
- (void)setTitle:(NSString *)title;
/**
 *  设置按钮的标题
 *
 *  @param title         标题
 *  @param selectedTitle 点击后的标题
 */
- (void)setTitle:(NSString *)title
   selectedTitle:(NSString *)selectedTitle;
/**
 *  设置点击事件
 *
 *  @param target target
 *  @param action action
 */
- (void)addTarget:(id)target action:(SEL)action;
/**
 *  移除点击事件
 *
 *  @param target target
 *  @param action action
 */
- (void)removeTarget:(id)target action:(SEL)action;

/**
 设置按钮的图片
 
 @param name 图片名字
 */
- (void)setImageWithName:(NSString *)name;

/**
 设置按钮被点击的图片
 
 @param selectedName 图片名字
 */
- (void)setSelectedImageWithName:(NSString *)selectedName;

/**
 设置按钮高亮的图片
 
 @param highlightedName 高亮图片名字
 */
- (void)setHighlightedImageWithName:(NSString *)highlightedName;


/**
 设置背景图片
 
 @param name 背景图片
 */
- (void)setBackgroundWithImageName:(NSString *)name;

/**
 设置背景图片
 
 @param name 背景图片
 @param selectedImageName 被选背景图片
 */
- (void)setBackgroundWithImageName:(NSString *)name
                 selectedImageName:(NSString *)selectedImageName;

/**
 设置背景图片
 
 @param name 背景图片
 @param insets 偏移量
 */
- (void)setBackgroundWithImageName:(NSString *)name
                         capInsets:(UIEdgeInsets)insets;

/**
 设置背景图片
 
 @param name 背景图片
 @param selectedImageName 被选背景图片
 @param insets 偏移量
 */
- (void)setBackgroundWithImageName:(NSString *)name
                 selectedImageName:(NSString *)selectedImageName
                         capInsets:(UIEdgeInsets)insets;

/**
 设置背景图片
 
 @param imageName 正常背景图片
 @param selectedImageName 被选背景图片
 @param highlightedImageName 高亮背景图片
 @param disabledImageName 失效背景图片
 @param insets 偏移量
 */
- (void)setBackgroundWithImageName:(NSString *)imageName
                 selectedImageName:(NSString *)selectedImageName
              highlightedImageName:(NSString *)highlightedImageName
                 disabledImageName:(NSString *)disabledImageName
                         capInsets:(UIEdgeInsets)insets;

/**
 设置子视图高亮显示
 */
- (void)enableHighlightedForSubView;

@property (nonatomic, strong) UIFont *titleFont;

@end
