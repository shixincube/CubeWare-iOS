//
//  CWSpectrumView.h
//  CubeWare
//
//  Created by zhuguoqiang on 17/2/22.
//  Copyright © 2017年 shixinyun. All rights reserved.//

#import <UIKit/UIKit.h>

@interface CWSpectrumView : UIView

@property (nonatomic, copy) void (^itemLevelCallback)(void);

@property (nonatomic) NSUInteger numberOfItems;

@property (nonatomic) UIColor * itemColor;

@property (nonatomic) CGFloat level;

@property (nonatomic) NSString *text;

- (BOOL)startUpdateMeter;

- (void)stopUpdateMeter;

@end
