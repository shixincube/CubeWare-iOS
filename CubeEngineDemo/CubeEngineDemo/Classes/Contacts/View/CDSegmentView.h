//
//  CDSegmentTableView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDSegmentViewDelegate<NSObject>
@required;

/**
 切换tab

 @param index 选中index
 */
- (void)didSelectedIndex:(NSInteger)index;
@end

@interface CDSegmentView : UIView

/**
 代理
 */
@property (nonatomic,weak) id<CDSegmentViewDelegate> segmentDelegate;

/**
 功能标题
 */
@property (nonatomic,strong) NSArray *titles;

/**
 角标
 */
@property (nonatomic,assign) NSInteger segIndex;

@end
