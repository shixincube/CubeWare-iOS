//
//  CWRecordView.h
//  CWRebuild
//
//  Created by luchuan on 2018/1/8.
//  Copyright © 2018年 luchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CWRecordView;

@protocol CWRecordViewDelegate<NSObject>

@optional
-(void)recordView:(CWRecordView *)recordView finshRecord:(NSString *)filePath andDuration:(CGFloat)duration;

@end

@interface CWRecordView : UIView

@property (nonatomic, weak) id<CWRecordViewDelegate> delegate;
@end
