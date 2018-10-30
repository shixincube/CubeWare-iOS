//
//  CWButton.h
//  CubeWare
//
//  Created by Mario on 2017/9/5.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIButtonTouchAction)(UIButton* sender);

@interface CWButton : UIButton

@property (nonatomic, copy) UIButtonTouchAction clickedAction;

/**
 初始化方法

 @param frame 尺寸
 @param title 标题
 @param titlecolor 标题颜色
 @param fontsize 字体大小
 @param radius 圆角弧度
 @param backcolor 背景颜色
 @param backgroundimage 背景图片
 @param image 图片
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                   titleColor:(UIColor *)titlecolor
                    titleFont:(CGFloat)fontsize
                 cornerRadius:(CGFloat)radius
              backgroundColor:(UIColor *)backcolor
              backgroundImage:(UIImage *)backgroundimage
                        image:(UIImage *)image;

//展示左右上下线
- (void)showRightLine:(CGFloat)height;

@end
