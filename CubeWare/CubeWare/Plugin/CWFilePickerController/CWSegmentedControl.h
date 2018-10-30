//
//  CWSegmentedControl.h
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWSegmentedControlDelegate <NSObject>

@required

- (void)segmentedControlSelectAtIndex:(NSInteger)index;

@end

@interface CWSegmentedControl : UIView

@property (assign, nonatomic) id<CWSegmentedControlDelegate>delegate;

- (id)initWithFrame:(CGRect)frame Titles:(NSArray *)titles delegate:(id)delegate;

- (void)changeSegmentedControlWithIndex:(NSInteger)index;

@end
