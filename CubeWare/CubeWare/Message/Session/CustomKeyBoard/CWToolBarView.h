//
//  CWToolBarView.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/27.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWToolBarItemModel.h"
#import "CWSessionTextView.h"

@class CWToolBarView;
@protocol CWToolBarViewDelegate <NSObject>

@optional
/**
 点击工具栏

 @param toolBarView <#toolBarView description#>
 @param index <#index description#>
 */
- (void)toolBarView:(CWToolBarView *)toolBarView didSelectToolBarAtIndex:(NSInteger) index;
/**
 点击发送文件
 */
- (void)toolBarView:(CWToolBarView *)toolBarView didClickSend:(NSString *)text;
/**
 textView高度发生变化
 */
- (void)toolBarView:(CWToolBarView *)toolBarView textViewHeightDidChange:(CWSessionTextView *)textView height:(CGFloat)height;

- (void)toolBarView:(CWToolBarView *)toolBarView heightWillChange:(CGFloat)height;
@end

@interface CWToolBarView : UIView

@property (nonatomic, strong) CWSessionTextView * textView;
@property (nonatomic, strong) UICollectionView *toolCollectionView;
@property (nonatomic, weak) id<CWToolBarViewDelegate> delegate;
@property (nonatomic, strong) NSArray<CWToolBarItemModel *> *toolBarItemsArr;

/**
 在光标处插入文字

 @param text 插入的内容
 */
-(void)insertTextIntoTextView:(NSString *)text;
/**
 删除光标前的内容
 */
-(void)deleteText;

+(instancetype)initToolBarItemWith:(NSArray<CWToolBarItemModel *> *) toolBarItemsArr;

- (void)clearToolBarSelectState;
@end
