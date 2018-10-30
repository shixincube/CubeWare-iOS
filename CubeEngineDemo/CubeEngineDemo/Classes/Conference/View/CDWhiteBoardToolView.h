//
//  CDWhiteBoardToolView.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/18.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDWhiteBoardToolViewDelegate <NSObject>

@optional
- (void)onCilckTapBtn;
- (void)onClickEllipseBtn;
- (void)onClickPencilBtn;
- (void)onClickArrowBtn;
- (void)onClickFileBtn;
- (void)onClickCleanUpBtn;

@end

@interface CDWhiteBoardToolView : UIView

/**
 代理
 */
@property (nonatomic,weak) id<CDWhiteBoardToolViewDelegate> delegate;

@end
