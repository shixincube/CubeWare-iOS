//
//  CDJoinView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/10.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDJoinView : UIView
/**
 会议
 */
@property (nonatomic,strong) CubeConference *conference;

/**
 显示
 */
- (void)showView;
@end
