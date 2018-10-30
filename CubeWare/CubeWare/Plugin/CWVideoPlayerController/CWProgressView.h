//
//  CWProgressView.h
//  CubeWare
//
//  Created by Mario on 17/3/3.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWProgressViewDelegate  <NSObject>

- (void)tapProgressView;

@end

@interface CWProgressView : UIView

@property (nonatomic, weak) id <CWProgressViewDelegate> delegate;

- (void)setProgress:(CGFloat)progress;

- (void)dismiss;

+ (id)progressView;

@end

