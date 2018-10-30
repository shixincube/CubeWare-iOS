//
//  CWMessageCell.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWContentCell.h"
#import "CWMessageMenuItem.h"
#import "CubeWareHeader.h"
#import "CWMessageCellConfig.h"

@class CWMessageCell;

/**消息事件代理*/
@protocol CWMessageCellDelegate <NSObject>

@optional

#pragma mark - event
/**头像点击事件*/
- (void)didClickedAvatarOnCell:(CWMessageCell *)cell;
/**点击重发按钮*/
- (void)didClickedRetryButtonOnCell:(CWMessageCell *)cell;
/**点击气泡*/
- (void)didClickedBubbleOnCell:(CWMessageCell *)cell;
/**长按头像*/
- (void)didLongPressedAvatarOnCell:(CWMessageCell *)cell;

#pragma mark - menu

/**
 长按消息气泡弹出菜单的选项

 @param cell 气泡所属cell
 @return 菜单列表,返回空则不显示
 */
- (NSArray <CWMessageMenuItem *> *)menuItemsForCell:(CWMessageCell *)cell;

/**
 选择菜单回掉

 @param item 选择的选项
 @param cell 相关cell
 */
- (void)didSelectedMenuItem:(CWMessageMenuItem *)item onCell:(CWMessageCell *)cell;

@end

@interface CWMessageCell : CWContentCell

@property (nonatomic, weak) id<CWMessageCellDelegate> delegate;

#pragma mark - view
/**头像*/
@property (nonatomic, strong) UIButton *avatarButton;
/**显示名称*/
@property (nonatomic, strong) UILabel *displayNameLabel;
/**气泡内容区*/
@property (nonatomic, strong) UIView *bubbleView;

#pragma mark - content

/**当前显示内容*/
@property (nonatomic, weak) CubeMessageEntity *currentContent;

#pragma mark - setting

/**
 是否展示在左边,左边为收到的消息，右边为发送的消息
 */
@property (nonatomic, assign) BOOL showLeft;

/**设置消息状态*/
@property (nonatomic, assign) CubeMessageStatus messageStatus;

/**头像url(http地址或者本地路径)*/
@property (nonatomic, copy) NSString *avatarUrl;
/**头像图片*/
@property (nonatomic, strong) UIImage *avatarImage;
/**显示名*/
@property (nonatomic, copy) NSString *displayName;
/**是否显示名称,默认为NO*/
@property (nonatomic, assign) BOOL enableDisplayName;
/**
 是否开启默认的气泡Mask,默认YES. 设置过后下一次显示时生效
 */
@property (nonatomic, assign) BOOL enableDefaultBubbleMask;

/**
 计算气泡高度
 
 @note cell高度 = 气泡高度 + 气泡向下偏移距离 ( + 昵称高度)
 
 @param content 待显示的内容
 @param session 所在session
 @return 气泡高度
 */
+(CGFloat)bubbleHeightForContent:(id)content inSession:(CWSession *)session;

@end
