//
//  CWSessionViewController.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSession.h"
#import "CWEmojiPackageModel.h"
#import "CWEmojiBoardView.h"
#import "CWMoreBoardView.h"
#import "CWContentCellDatasourceDelegate.h"

@protocol CWContentCellProtocol;
@protocol CWMessageCellDelegate;
@protocol CWSessionRefreshProtocol;


@protocol CWSessionViewControllerDelegate<CWContentCellDatasourceDelegate>


@end;


/**
 会话controller，默认实现 CWMessageCellDelegate 中的气泡长按，点击和重发消息按钮
 */
@interface CWSessionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CWMessageCellDelegate,CWEmojiBoardViewDelegate,CWSessionRefreshProtocol,CWMoreBoardViewDelegate>

/**消息数组*/
@property (nonatomic, strong) NSMutableArray *msgsArray;

/**显示消息的tableview*/
@property (nonatomic, strong) UITableView *msgList;
/** 更多键盘内容 */
@property (nonatomic, strong) NSArray<CWToolBarItemModel *> *moreItemArr;

/** 贴图表情 */
@property (nonatomic, strong) NSArray<CWEmojiPackageModel *> *facialEmojiPackageArr;
/**当前会话*/
@property (nonatomic, strong) CWSession *session;
/** 表情键盘 */
@property (nonatomic, strong) CWEmojiBoardView *emojiBoardView;
/** 更多键盘 */
@property (nonatomic, strong) CWMoreBoardView *moreBoardView;
@property (nonatomic, weak) id<CWSessionViewControllerDelegate> delegate;

-(instancetype)initWithSession:(CWSession *)session;

#pragma mark - load message

/**
 加载更多消息

 @param limit 需要加载消息的数量
 @param handler 加载完成回掉 loadcount:实际加载数量
 */
-(void)loadMoreDataWithLimit:(int)limit andCompleteHandler:(void(^)(int loadCount)) handler;

@end
