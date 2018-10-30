//
//  CDGroupTipView.h
//  CubeEngineDemo
//  群提示框
//  Created by pretty on 2018/9/10.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _TipShowType
{
    TipShowVoiceConferece = 0,
    TipShowShareDesktop = 1,
    TipShowVideoConference = 2,
    TipShowWhiteBoard = 3,
}TipShowType;
@protocol CDGroupTipViewDelegate <NSObject>

/**
 点击提示条
 */
- (void)onTapTipView;
@end

@interface CDGroupTipView : UIView

/**
 参与人数
 */
@property (nonatomic,assign)NSInteger memberCount;

/**
 代理
 */
@property (nonatomic,weak) id<CDGroupTipViewDelegate> delegate;
/**
 初始化

 @param frame 尺寸
 @param showtype 显示类型
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame andShowType:(TipShowType)showtype;
@end
