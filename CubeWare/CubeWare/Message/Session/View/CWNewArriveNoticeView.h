//
//  CWNewArriveNoticeView.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/8.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWNewArriveNoticeView : UIView

@property (nonatomic, assign) int unreadCount;

@property (nonatomic, copy) void(^didClickedHandler)(void);

/**
 创建视图，并添加约束
 */
-(void)initView;

@end
