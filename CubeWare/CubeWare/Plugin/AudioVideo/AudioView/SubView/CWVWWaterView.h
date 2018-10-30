//
//  CWVWWaterView.h
//  CubeWare
//
//  Created by Mario on 17/2/13.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWVWWaterView : UIView

@property (nonatomic, assign) float currentLinePointY;

@property (nonatomic, retain) UIColor *currentWaterColor;

- (id)initWithFrame:(CGRect)frame andLineColor:(UIColor *)color andA:(float)a andB:(float)b;

#pragma mark - animation manage

-(void)startAnimation;

-(void)stopAnimation;

@end
