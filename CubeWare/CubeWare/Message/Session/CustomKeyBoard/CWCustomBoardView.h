//
//  CWCustomBoardView.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/29.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWToolBarItemModel.h"
#import "CWToolBarView.h"

@class CWCustomBoardView;

@protocol CWCustomBoardViewDelegate <NSObject>
@optional
/**
 点击了某一个 toolBar

 @param customBoardView  自定义键盘
 @param index  如果 index = -1 表示 更多Bar
 */
- (void)customBoardView:(CWCustomBoardView *)customBoardView didSelectAtIndex:(NSInteger) index;


/**
 点击发送按钮

 @param customBoardView 自定义键盘
 @param text 发送的文本
 */
- (void)customBoardView:(CWCustomBoardView *)customBoardView didClickToolBarTextViewSend:(NSString *)text;

/**
 文本输入框将要改变

 @param customBoardView <#customBoardView description#>
 @param textView <#textView description#>
 @param height <#height description#>
 */
- (void)customBoardView:(CWCustomBoardView *)customBoardView textViewHeightDidChange:(CWSessionTextView *)textView height:(CGFloat)height;

- (void)customBoardView:(CWCustomBoardView *)customBoardView HeightWillChange:(CGFloat)height duration:(NSTimeInterval) duration;

@end

@protocol CWCustomBoardViewDataSource <NSObject>

@optional
- (UIView *)customBoardView:(CWCustomBoardView *)customBoardView itemViewAtIndex:(NSInteger) index;

- (CGFloat)customBoardView:(CWCustomBoardView *)customBoardView itemHeightAtIndex:(NSInteger) index;

@end

@interface CWCustomBoardView : UIView

@property (nonatomic, strong) NSArray<CWToolBarItemModel *> *toolBarItemModelArr;
//@property (nonatomic, strong) CWToolBarItemModel *moreItemModel;
@property (nonatomic, weak) id<CWCustomBoardViewDelegate> delegate;
@property (nonatomic, weak) id<CWCustomBoardViewDataSource> dataSource;
/**
 工具栏
 */
@property (nonatomic, strong) CWToolBarView *toolBarView;


//-(void)setContainerHeight:(CGFloat)containerHeight duration:(NSTimeInterval)duration;

/**
 隐藏键盘
 */
- (void)hideKeyBoard;
/**
 显示键盘
 */
- (void)showKeyBoard;

/**
 在光标处插入文字

 @param text 插入的内容
 */
-(void)insertTextIntoTextView:(NSString *)text;

-(void)deleteTextFromTextView;

@end
