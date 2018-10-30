//
//  CWEmojiBoardView.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWEmojiPackageModel.h"
@class CWEmojiBoardView;
@protocol CWEmojiBoardViewDelegate<NSObject>

@optional

/**
 点击一个表情
 
 @param emojiBoardView emojiview
 @param indexPath 索引
 */
- (void)emojiBoardView:(CWEmojiBoardView *)emojiBoardView didSelectEmojiAtIndex:(NSIndexPath *) indexPath;

/**
 点击了删除按钮

 @param emojiBoardView emojiBoardView
 */
- (void)emojiBoardViewClickDeleteAction:(CWEmojiBoardView *)emojiBoardView;

/**
 选中表情的标签栏

 @param emojiBoardView emojiView
 @param indexPath index
 */
- (void)emojiBoardView:(CWEmojiBoardView *)emojiBoardView didSelectEmojiTabEmojiAtIndex:(NSIndexPath *) indexPath;

/**
 点击了发送按钮

 @param emojiBoardView emojiBoardView
 */
-(void)emojiBoardViewClickSend:(CWEmojiBoardView *)emojiBoardView;

/**
 增加表情

 @param emojiBoardView emojiBoardView
 */
-(void)emojiBoardViewClickAddEmojiPackage:(CWEmojiBoardView *)emojiBoardView;

@end

@interface CWEmojiBoardView : UIView

@property (nonatomic, strong) NSArray<CWEmojiPackageModel *> *emojiPackageArr;
@property (nonatomic, weak) id<CWEmojiBoardViewDelegate> delegate;
/**
 发送表情
 */
@property (nonatomic, strong) UIButton *sendBtn;
/**
 发送表情
 */
@property (nonatomic, strong) UIButton *addEmojiBtn;

@end
