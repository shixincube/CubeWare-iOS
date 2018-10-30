//
//  CDInfoTopView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDInfoTopViewDelegate<NSObject>
/**
 点击聊天按钮
 */
- (void)onClickChatButton;
@end
@interface CDInfoTopView : UIView
/**
 图标
 */
@property (nonatomic,strong) UIImageView *iconView;

/**
 标题
 */
@property (nonatomic,strong) UILabel *title;

/**
 跳转聊天按钮
 */
@property (nonatomic,strong) UIButton *chatButton;

/**
 是否是我自己
 */
@property (nonatomic,assign) BOOL isMySelf;
/**
 代理
 */
@property (nonatomic,weak) id <CDInfoTopViewDelegate> delegate;
@end
