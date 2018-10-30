//
//  UIView+NCubeWare.h
//  CubeWare
//
//  Created by guoqiangzhu on 17/1/10.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CWOscillatoryAnimationToBigger,
    CWOscillatoryAnimationToSmaller,
} CWOscillatoryAnimationType;

@interface UIView (NCubeWare)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat cw_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat cw_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat cw_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat cw_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat cw_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat cw_height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat cw_centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat cw_centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat cw_ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat cw_ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat cw_screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat cw_screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect cw_screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint cw_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize cw_size;

//找到自己的vc
- (UIViewController *)viewController;

- (void)cw_setFrameInSuperViewCenterWithSize:(CGSize)size;

@end

@interface UIView (CWPresent)

//弹出一个类似present效果的窗口
- (void)presentView:(UIView*)view animated:(BOOL)animated complete:(void(^)()) complete;

//获取一个view上正在被present的view
- (UIView *)presentedView;

- (void)dismissPresentedView:(BOOL)animated complete:(void(^)()) complete;

//这个是被present的窗口本身的方法
//如果自己是被present出来的，消失掉
- (void)hideSelf:(BOOL)animated complete:(void(^)()) complete;

//图片放大缩小震荡动画
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(CWOscillatoryAnimationType)type;
@end
