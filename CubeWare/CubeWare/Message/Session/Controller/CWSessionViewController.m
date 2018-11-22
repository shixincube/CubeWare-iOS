//
//  CWSessionViewController.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSessionViewController.h"
#import "CWSessionUtil.h"
#import "CWContentCellProtocol.h"
#import "CWMessageDBProtocol.h"
#import "CWCustomBoardView.h"
#import "CWSessionRefreshDelegate.h"
#import "CWSessionViewDataConfig.h"
#import "CWMessageCell.h"
#import "CWAudioMessageCell.h"
#import "CWImageMessageCell.h"
#import "CWVideoMessageCell.h"
#import "CWMessageService.h"
#import "CWAudioRootView.h"
#import "CWToastUtil.h"
#import "CWColorUtil.h"
#import "CWResourceUtil.h"
#import "CWChooseContactController.h"
#import "CWAlertView.h"
#import "CWVideoRootView.h"

#import "CWHistoryNoticeView.h"
#import "CWNewArriveNoticeView.h"
#import "CWPlayerView.h"

#import "CWHttpClient.h"
#import "CWRecordView.h"

#import "CWImagePickerController.h"
#import "CWCameraViewController.h"
#import "CWGroupAVManager.h"
#import "CWUtils.h"
#import "CWAuthorizeManager.h"
#import "CubeWareHeader.h"
#import "JGPhotoBrowser.h"
#import "CWWorkerFinder.h"
#import "CWMessageDBProtocol.h"
#import "CWMessageRinging.h"
#import "CWTipModel.h"
#import "CWInfoRefreshDelegate.h"
#import "CWFilePickerController.h"
//#import "CWVideoAndAudioManager.h"
#define CustomKeyBoardHeigth ([UIScreen mainScreen].bounds.size.height * 0.32)


@interface CWSessionViewController ()<CWCustomBoardViewDelegate,CWCustomBoardViewDataSource,CWEmojiBoardViewDelegate,CWImagePickerControllerDelegate,CWCameraPickerDelegate,CWRecordViewDelegate,CWInfoRefreshDelegate,JGPhotoBrowseDelegate,CWVideoPlayerCloseProtocal,UIDocumentInteractionControllerDelegate,CWFilePickerDelegate>{
    BOOL _clickToolBarItem;
    CGFloat _textViewHeight;
    CGFloat _containerHeight;
    NSInteger _selectToolBarItem;
    CGFloat _oldContentOffestY;
    CGFloat _startContentOffestY;
}


@property (nonatomic, strong) NSArray<CWToolBarItemModel *> *toolBarItemsArr;

@property (nonatomic, strong) CWCustomBoardView *customBoardView;
/**
 是否在在最底部
 */
@property (nonatomic, assign) BOOL tableViewIsScrollToBottom;

/**
 录音键盘
 */
@property (nonatomic, strong) CWRecordView *recordBoardView;


@property (nonatomic, strong) NSMutableArray<CWEmojiPackageModel *> *emojiPackageModelArr;

@property (nonatomic, strong) CWHistoryNoticeView *historyNoticeView;//历史消息提示
@property (nonatomic, strong) CWNewArriveNoticeView *newArriveNoticeView;//新消息提示

@property (nonatomic, assign) BOOL needScrollToBottom;//新消息是否需要滚动到底部

@property (nonatomic, strong) NSMutableArray *userUserInfoIds;

@property (nonatomic, strong) CWMessageCell *recordLastOnclickCell;//记录上一次点击的Cell
@property (nonatomic, strong) CWPlayerView *playerView;//视频播放
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;//文档预览
@property (nonatomic, strong) NSDate *lastShakeDate;// 上一次抖动的时间
@end

@implementation CWSessionViewController{
    volatile BOOL scrollingToBottom;
}

#pragma mark - init
-(instancetype)initWithSession:(CWSession *)session{
    if(self = [super init])
    {
        
        self.session = session;
		self.userUserInfoIds = [NSMutableArray array];
		self.title = session.appropriateName;
    }
    return self;
}

#pragma mark - - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.msgList];
    [self initlayout];
    
    _selectToolBarItem = -2;
    self.needScrollToBottom = YES;
    
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWSessionRefreshProtocol),@protocol(CWInfoRefreshDelegate)]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.msgsArray.count)
    {
        [self loadMoreDataWithLimit:20 andCompleteHandler:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showHistoryNoticeIfNeed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

-(void)initlayout{
    [self.customBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(-87-CWBootomSafeHeight);
    }];
    [self.msgList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self.msgList.superview);
        make.bottom.mas_equalTo(self.customBoardView.mas_top);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.msgsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id content = [self.msgsArray objectAtIndex:indexPath.row];
    
    if(indexPath.row  == self.msgsArray.count - 1)
    {
        self.newArriveNoticeView.unreadCount = 0;
    }
    
    Class cls = nil;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellClassForContent:)])
    {
        cls = [self.delegate cellClassForContent:content];
    }
	
	if(!cls)
    {
        [self checkResourceAvailable:content];
        cls = [CWSessionUtil cellClassForContent:content];
    }
    
    NSString *reuseIdentifier = [cls reuseIdentifier];
    [tableView registerClass:cls forCellReuseIdentifier:reuseIdentifier];
    
    UITableViewCell<CWContentCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if([cls isSubclassOfClass:[CWMessageCell class]])
    {
        [(CWMessageCell *)cell setDelegate:self];
		[(CWMessageCell *)cell setEnableDisplayName:self.session.showNickName];
       
    }

    [cell configUIWithContent:content];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id content = [self.msgsArray objectAtIndex:indexPath.row];
    Class cls = nil;
    if(self.delegate && [self.delegate respondsToSelector:@selector(cellClassForContent:)])
    {
        cls = [self.delegate cellClassForContent:content];
    }
    if(!cls){
        cls = [CWSessionUtil cellClassForContent:content];
    }
    return [cls cellHeigtForContent:content inSession:self.session];
}

#pragma mark - UIScrollerViewDelegate


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - _oldContentOffestY;
    _oldContentOffestY = contentOffset;
    if (distanceFromBottom < hight && contentOffset - _startContentOffestY  > 50) {
        [self.customBoardView showKeyBoard];
    }else if(contentOffset < _startContentOffestY){
        [self.customBoardView hideKeyBoard];
    }
    
    self.needScrollToBottom = self.msgList.contentSize.height - self.msgList.bounds.size.height - self.msgList.contentOffset.y < 80;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.needScrollToBottom = self.msgList.contentSize.height - self.msgList.bounds.size.height - self.msgList.contentOffset.y < 80;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startContentOffestY = scrollView.contentOffset.y;
    self.needScrollToBottom = NO;
}
#pragma mark - CWSessionRefreshProtocol

-(BOOL)messagesUpdated:(NSArray<CubeMessageEntity *> *)messages forSession:(CWSession *)session{
    BOOL canHandle = NO;
    if([session.sessionId isEqualToString:self.session.sessionId])
    {
        canHandle = YES;
		
		[self prepareBaseInfoForMessages:messages requireWhenNotExist:YES];
        
        int newMessageCount = 0;//统计新消息数量
        
        for(int i = messages.count - 1; i >= 0; i--)
        {
            CubeMessageEntity *message = messages[i];
            
            NSInteger location;
            for (location = self.msgsArray.count - 1; location >= 0; location --) {
                CubeMessageEntity *temp = self.msgsArray[location];
                if([temp isKindOfClass:[CubeMessageEntity class]] && temp.SN == message.SN){
                    break;
                }
            }
            
            if(message.needShow)
            {
                //获取当前session的消息
                long long latestMsgTime = [(CubeMessageEntity *)self.msgsArray.lastObject timestamp];
                long long firstMsgTime = [(CubeMessageEntity *)self.msgsArray.firstObject timestamp];
                if(location < 0 && message.timestamp > latestMsgTime)
                {
                    newMessageCount += 1;
                    //时间戳大于最新消息的时间戳，作为新消息插入
                    dispatch_async(dispatch_get_main_queue(), ^{
						if(self.msgsArray.lastObject && (message.timestamp - latestMsgTime > 180000)){
							CWTipModel *timeTip = [CWTipModel tipWithType:CWTipTypeTimeStamp andContent:nil andUserInfo:nil];
							timeTip.timestamp = message.timestamp;
							[self.msgsArray addObject:timeTip];
							[self.msgList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.msgsArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
						}
						[self.msgsArray addObject:message];
						[self.msgList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.msgsArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

						if(i == 0)
						{
							if(self.needScrollToBottom)
							{
								[self.msgList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgsArray.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
								self.newArriveNoticeView.unreadCount = 0;
							}
							else
							{
								self.newArriveNoticeView.unreadCount += newMessageCount;
							}
						}
                    });
                }else
				{
                    if(location >= 0 )
                    {
                        //更新旧消息
                        [self.msgsArray replaceObjectAtIndex:location withObject:message];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (message.recallTime != 0)
                            {
                                [self.msgList reloadData];
                            }
                            else
                            {
                                id<CWContentCellProtocol> cell = [self.msgList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:location inSection:0]];
                                if(cell)
                                {
                                    [cell configUIWithContent:message];
                                }
                            }
                        });
                        break;
                    }
                    else{
                        if(message.timestamp <= latestMsgTime && message.timestamp >= firstMsgTime){
                            // 收到消息时间比较晚的消息
                            message.timestamp = latestMsgTime + 1;
                            latestMsgTime = message.timestamp;
                            id<CWSessionRefreshProtocol> db = [[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionRefreshProtocol)].firstObject;
                            [self messagesUpdated:@[message] forSession:self.session];
                        }
                    }
                }
            }
            else
            {
                if(location >= 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.msgsArray removeObjectAtIndex:location];
                        [self.msgList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:location inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
            }
        }
        
    }
    return canHandle;
}

#pragma mark - CWInfoRefreshDelegate
-(void)changeCurrentUser:(CWUserModel *)user{
	
}

-(void)usersInfoUpdated:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session{
	BOOL needUpdataView = NO;
	for (CWUserModel *user in users)
	{
		if([self.userUserInfoIds containsObject:user.cubeId])
		{
			needUpdataView = YES;
			break;
		}
	}
	
	if(needUpdataView)
	{
		[self prepareBaseInfoForMessages:self.msgsArray requireWhenNotExist:NO];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.msgList reloadData];
		});
	}
}

/**
 添加require 防止一直循环申请信息
 */
-(void)prepareBaseInfoForMessages:(NSArray<CubeMessageEntity *> *)messages requireWhenNotExist:(BOOL)require{
	NSMutableArray *needBaseinfoCubes = [NSMutableArray array];
	NSMutableArray *messagesArray = [messages copy];//防止遍历时数组更改导致crash
	CWSession *tempSession = self.session.sessionType == CWSessionTypeP2P ? nil : self.session;
	for (CubeMessageEntity *message in messagesArray) {
		if([message isKindOfClass:[CubeMessageEntity class]])
		{
//			CWBaseInfoModel *baseInfo = nil;//[[CubeWare sharedSingleton].infoManager baseInfoForCubeId:message.sender.cubeId inSession:tempSession];
//			if(!baseInfo)
//			{
//				[self.userUserInfoIds addObject:message.sender.cubeId];
//			}
//			message.baseInfo = baseInfo;
			
			[message.parseInfo prepairAttibuteLabel];
		}
	}
	
	if(require && needBaseinfoCubes.count)
	{
		[[CubeWare sharedSingleton].infoManager.delegate needUsersInfoFor:needBaseinfoCubes inSession:self.session.sessionType == CWSessionTypeP2P ? nil : self.session];
	}
}

#pragma mark - CWMesaageCelldelegate
-(void)didClickedBubbleOnCell:(CWMessageCell *)cell{
    [self.customBoardView hideKeyBoard];
    CubeMessageEntity * msg = cell.currentContent;
    switch (msg.type) {
        case CubeMessageTypeCard:
            break;
        case CubeMessageTypeFile:
            [self fileMessageOnclick:cell];
            break;
        case CubeMessageTypeImage:
            [self imageMessageOnclick:cell];
            break;
        case CubeMessageTypeCustom:
            [self customMessageOnClick:cell];
            break;
        case CubeMessageTypeVideoClip:
            [self videoMessageOnclick:cell];
            break;
        case CubeMessageTypeVoiceClip:
            [self voiceClipMessageOnclick:msg onCell:cell];
            break;
        default:
            break;
    }
    self.recordLastOnclickCell = cell;//记录点击的cell
    
}

-(void)didClickedRetryButtonOnCell:(CWMessageCell *)cell{
    CubeMessageEntity *msg = [self.msgsArray objectAtIndex:[self.msgList indexPathForCell:cell].row];
    [[CubeWare sharedSingleton].messageService resendMessage:msg];
}

-(NSArray *)menuItemsForCell:(CWMessageCell *)cell{
    NSMutableArray *menuArray = [NSMutableArray array];
     CubeMessageEntity *msg = [self.msgsArray objectAtIndex:[self.msgList indexPathForCell:cell].row];
    if (msg.messageDirection == CubeMessageDirectionSent) {
        if (msg.type == CubeMessageTypeCustom) {
//            return @[[CWMessageMenuItem itemWithTitle:@"删除" andIdentifier:@"delete"],[CWMessageMenuItem itemWithTitle:@"复制" andIdentifier:@"copy"]];
            [menuArray addObjectsFromArray:@[]];
        }
        else if (msg.type == CubeMessageTypeText)
        {
            [menuArray addObjectsFromArray:@[[CWMessageMenuItem itemWithTitle:@"撤回" andIdentifier:@"recall"],[CWMessageMenuItem itemWithTitle:@"复制" andIdentifier:@"copy"]]];
        }
        else if (msg.type == CubeMessageTypeFile || msg.type == CubeMessageTypeImage)
        {
            [menuArray addObjectsFromArray:@[[CWMessageMenuItem itemWithTitle:@"撤回" andIdentifier:@"recall"]]];
        }
        else
        {
            [menuArray addObjectsFromArray:@[[CWMessageMenuItem itemWithTitle:@"撤回" andIdentifier:@"recall"]]];
        }
    }
    else
    {
        if (msg.type == CubeMessageTypeCustom) {

        }
        else if (msg.type == CubeMessageTypeText)
        {
            [menuArray addObjectsFromArray:@[[CWMessageMenuItem itemWithTitle:@"复制" andIdentifier:@"copy"]]];
        }
        else
        {
        }
    }
    [menuArray addObjectsFromArray:@[[CWMessageMenuItem itemWithTitle:@"删除" andIdentifier:@"delete"]]];
    return menuArray;
}

-(void)didSelectedMenuItem:(CWMessageMenuItem *)item onCell:(CWMessageCell *)cell{
    CubeMessageEntity *msg = [self.msgsArray objectAtIndex:[self.msgList indexPathForCell:cell].row];
    if([item.identifier isEqualToString:@"recall"])
    {
         [[CubeWare sharedSingleton].messageService recallMessage:msg];
    }
    else if([item.identifier isEqualToString:@"forward"])
    {
        
    }
    else if ([item.identifier isEqualToString:@"delete"])
    {
        [[CubeWare sharedSingleton].messageService  deleteMessage:msg forSession:self.session];
        
    }
    else if ([item.identifier isEqualToString:@"copy"])
    {
        CubeTextMessage *textMessage = (CubeTextMessage *)msg;
        if (textMessage.content.length) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *atString = textMessage.content;
            [pasteboard setString:atString];
        }
    }
}

#pragma mark - CWCustomBoardViewDataSource
-(UIView *)customBoardView:(CWCustomBoardView *)customBoardView itemViewAtIndex:(NSInteger)index{
    CWToolBarItemModel * toolBarItemModel =  self.toolBarItemsArr[index];
    switch (toolBarItemModel.tag) {
        case CWToolBarItemVoice://语音
            return self.recordBoardView;
            break;
        case CWToolBarItemEmoji://Emoji
            return self.emojiBoardView;
            break;
        case CWToolBarItemMore://更多
            return self.moreBoardView;
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

-(CGFloat)customBoardView:(CWCustomBoardView *)customBoardView itemHeightAtIndex:(NSInteger)index{
    CWToolBarItemModel * toolBarItemModel = self.toolBarItemsArr[index];
    switch (toolBarItemModel.tag) {
        case CWToolBarItemVoice://语音
        case CWToolBarItemEmoji://Emoji
        case CWToolBarItemMore://更多
            return CustomKeyBoardHeigth;
            break;
        default:
            return 0;
            break;
    }
}


#pragma mark - CWCustomBoardViewDelegate
-(void)customBoardView:(CWCustomBoardView *)customBoardView didSelectAtIndex:(NSInteger)index{
    
    CWToolBarItemModel * toolBarItemModel =  self.toolBarItemsArr[index];
    switch (toolBarItemModel.tag) {
        case CWToolBarItemVoice://语音
            break;
        case CWToolBarItemPicture: //图片浏览
            [self showImagePickerViewController];
            break;
        case CWToolBarItemPhoto://拍照
            [self showCameraViewController];
            break;
        case CWToolBarItemFile://文件
            [self showFilePickerViewController];
            break;
        case CWToolBarItemEmoji://Emoji
            break;
        case CWToolBarItemMore://更多
            break;
        default:
            break;
    }
}

- (void)customBoardView:(CWCustomBoardView *)customBoardView HeightWillChange:(CGFloat)height duration:(NSTimeInterval)duration{
    NSLog(@"lc::%s",__func__);
    height = height+ CWBootomSafeHeight;
    CGFloat contentHeight = self.msgList.contentSize.height + self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat distance = contentHeight + height - self.view.frame.size.height;;
    [self.customBoardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-height);
    }];
    if(distance < 0 ){
        [self.customBoardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-height);
        }];
        [self.msgList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgList.superview);
        }];
    }else{
        [self.customBoardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-height);
        }];
        CGFloat offset = - (distance < height ? distance : height);
        offset = height > 100 ? offset :0;// 如果高度小于100 ，表示这个动作是隐藏键盘，
        [self.msgList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgList.superview).offset(offset);
        }];
    }

    [UIView animateWithDuration:duration animations:^{
		[self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
    }];
	
}


-(void)customBoardView:(CWCustomBoardView *)customBoardView didClickToolBarTextViewSend:(NSString *)text{
    CubeTextMessage *textMessage = [[CubeTextMessage alloc] initWithConent:text andSender:[CWUserModel currentUser] andReceiver:[CubeUser userWithCubeId:self.session.sessionId andDiaplayName:self.session.sessionName andAvatar:nil]];
    if(self.session.sessionType == CWSessionTypeGroup)
    {
        textMessage.groupName = self.session.sessionId;
    }
    [[CubeWare sharedSingleton].messageService sendMessage:textMessage forSession:self.session];
}

#pragma mark - CWRecordViewDelegate
- (void)recordView:(CWRecordView *)recordView finshRecord:(NSString *)filePath andDuration:(CGFloat)duration{
	[CubeMediaServiceUtils loadMediaInfo:nil ofFile:filePath withHandler:^(AVAsset *asset, CubeError *error) {
		if(!error)
		{
//            float duration = CMTimeGetSeconds([CubeMediaServiceUtils durationOf:asset]);
			NSString *fileName = [filePath lastPathComponent];
			long long fileSize = [NSData dataWithContentsOfFile:filePath].length;
			CubeVoiceClipMessage *voiceMsg = [[CubeVoiceClipMessage alloc] initWithFileName:fileName fileSize:fileSize duration:duration url:nil md5:nil andSender:[CWUserModel currentUser] receiver:[CubeUser userWithCubeId:self.session.sessionId andDiaplayName:nil andAvatar:nil]];
			voiceMsg.filePath = filePath;
			voiceMsg.status = CubeMessageStatusSending;
			voiceMsg.messageDirection = CubeMessageDirectionSent;
            voiceMsg.filePath = filePath;
			[[CubeWare sharedSingleton].fileService startUploadFileWithFileMessage:voiceMsg];
		}
	}];
}


#pragma mark - CWEmojiBoardViewDelegate
-(void)emojiBoardView:(CWEmojiBoardView *)emojiBoardView didSelectEmojiAtIndex:(NSIndexPath *)indexPath{
    CWEmojiPackageModel *emojiPackagemodel = self.emojiPackageModelArr[indexPath.section];
    CWEmojiModel * simpleEmojiModel = emojiPackagemodel.emojiModelArr[indexPath.row];
    if (emojiPackagemodel.emojiPackageType == CWEmojiPackageTypeSystemEmoji) { // 内置表情
        [self.customBoardView insertTextIntoTextView:simpleEmojiModel.name];
    }
//    else{
//        //发送 key
//        [[NCubeWare sharedSingleton].messageService sendText:[NSString stringWithFormat:@"[cube_emoji:%@]",simpleEmojiModel.key] forSession:self.session];
//    }
}

-(void)emojiBoardViewClickSend:(CWEmojiBoardView *)emojiBoardView{
    NSString * text =  self.customBoardView.toolBarView.textView.text;
	CubeTextMessage *textMessage = [[CubeTextMessage alloc] initWithConent:text andSender:[CWUserModel currentUser] andReceiver:[CubeUser userWithCubeId:self.session.sessionId andDiaplayName:nil andAvatar:nil]];
	[[CubeWare sharedSingleton].messageService sendMessage:textMessage forSession:self.session];
    self.customBoardView.toolBarView.textView.text = @"";
}


- (void)emojiBoardViewClickDeleteAction:(CWEmojiBoardView *)emojiBoardView{
    [self.customBoardView deleteTextFromTextView];
}


#pragma mark CWMoreBoardViewDelegate
-(void)moreBoardView:(CWMoreBoardView *)moreBoardView didSelectAtIndex:(NSInteger)index{
    CWToolBarItemModel * toolBarItemModel =  self.moreItemArr[index];
    switch (toolBarItemModel.tag) {
        case CWToolBarItemP2PCall: //1V1 通话
            [self onClickP2PCallItem];
            break;
        case CWToolBarItemVideo: //视频通话
            [self onClickP2PVideoItem];
            break;
        case CWToolBarItemP2PWhiteBoard:
            [self onClickP2PWhiteBoardItem];
            break;
        case CWToolBarItemShakeAt: //抖动
            [self onClickShakeItem];
            break;
        case CWToolBarItemGroupCall: //群通话
            [self onClickGroupCallItem];
            break;
        case CWToolBarItemGroupTask://群任务
            break;
        case CWToolBarItemGroupVideo: //群视频
            [self onClickGroupVideoItem];
            break;
        case CWToolBarItemGroupWhiteBoard: // 群白板
            [self onClickGroupWhiteBoardItem];
            break;
        default:
            break;
    }
}

#pragma mark - CWImagePickerControllerDelegate (相册选择发送)
- (void)imagePickerController:(CWImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [CWSessionViewDataConfig sendImageN:assets andIsOriginal:isSelectOriginalPhoto andBlock:^(NSData *imageData, NSData *thumbImageData, NSString *name, CGSize thumbSize, bool isFile) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self sendImageMessage:imageData andThumbImageData:thumbImageData andNameStr:name andSize:thumbSize isFile:isFile];
        });
    }];

}

#pragma mark - CWCameraPickerDelegate(短视频、拍摄图片发送)
-(void)cameraPickerControllerWithThumbImagePath:(NSString *)thumbPath
                                    andFilePath:(NSString *)filePath
                                    andFileName:(NSString *)fileName
                               andVideoDuration:(long long)duration
                                  andController:(CWCameraViewController *)controller
                                  andCameraType:(CWCameraType)type
{
    [controller dismissViewControllerAnimated:YES completion:nil];
     UIImage *image = [UIImage imageWithContentsOfFile:thumbPath];
    if (type == CWCameraTypeTakeVideo) {
        CubeVideoClipMessage *videoMessage = [CWMessageUtil videoClipMessageWithFilePath:filePath andThumbPath:thumbPath andName:fileName andSize:image.size andDuration:duration forSession:self.session];
        [[CubeWare sharedSingleton].fileService startUploadFileWithFileMessage:videoMessage];

    }else if(type == CWCameraTypeTakePicture){
        CubeImageMessage *imageMessage = [CWMessageUtil imageMessageWithPath:filePath andThumbPath:thumbPath andName:fileName andFileSize:0 andSize:image.size forSession:self.session];
        [[CubeWare sharedSingleton].fileService startUploadFileWithFileMessage:imageMessage];
    }
    
}

#pragma mark - CWFilePickerDelegate (文件选择)
-(void)filePickerControllerWithDic:(NSMutableDictionary *)mutableDic
                     andController:(CWFilePickerController *)controller{
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSArray *mediaArr = mutableDic[@"asset"];
    NSArray *fileArr = mutableDic[@"file"];
    if(mediaArr.count > 0){

        NSMutableArray *imageAssetArr = [NSMutableArray array];
        NSMutableArray *videoAssetArr = [NSMutableArray array];
        [mediaArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![obj isKindOfClass:[CWFilePHAsssetModel class]])return ;
            CWFilePHAsssetModel *mediaModel = (CWFilePHAsssetModel *)obj;
            if(mediaModel.result.mediaType == PHAssetMediaTypeImage){
                [imageAssetArr addObject:mediaModel.result];
            }else if(mediaModel.result.mediaType == PHAssetMediaTypeVideo){
                [videoAssetArr addObject:mediaModel.result];
            }
        }];
        if(imageAssetArr.count){
            [CWSessionViewDataConfig sendImageN:imageAssetArr andIsOriginal:YES andBlock:^(NSData *imageData, NSData *thumbImageData, NSString *name, CGSize thumbSize, bool isFile) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self sendImageMessage:imageData andThumbImageData:thumbImageData andNameStr:name andSize:thumbSize isFile:isFile];
                });
            }];

        }
        if(videoAssetArr.count){
            [CWSessionViewDataConfig sendVideo:videoAssetArr andBlock:^(NSString *filePath, NSString *thumbPath, long long duration, NSString *fileFame, CGSize thumbSize) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    CubeVideoClipMessage *videoMessage = [CWMessageUtil videoClipMessageWithFilePath:filePath andThumbPath:thumbPath andName:fileFame andSize:thumbSize andDuration:duration forSession:self.session];
                  BOOL exists =  [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                    [[CubeWare sharedSingleton].fileService startUploadFileWithFileMessage:videoMessage];
                });
            }];
        }

    }
    if(fileArr.count > 0){
        [fileArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![obj isKindOfClass:[CWFileManagerModel class]])return ;
            CWFileManagerModel *fileModel = (CWFileManagerModel *)obj;
            CubeFileMessage *fileMessage = [CWMessageUtil fileMessageWithPath:fileModel.filePath andName:fileModel.nameString forSession:self.session];
            [[CubeWare sharedSingleton].fileService startUploadFileWithFileMessage:fileMessage];
        }];
    }


}

#pragma mark - JGPhotoBrowseDelegate
-(void)photoBrowserDidSendFriend:(JGPhoto *)photo{
    // 转发给朋友
}

#pragma mark - CWVideoPlayerCloseProtocal
-(void)closeVideoPlayer{
    [_playerView removeFromSuperview];
    _playerView = nil;
}


#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return  self.view.frame;
}

#pragma mark - Private Metho

/*加载指定数目的数据**/
-(void)loadMoreDataWithLimit:(int)limit andCompleteHandler:(void (^)(int))handler{
    
    CubeMessageEntity *m = [self.msgsArray firstObject];
    long long timestamp = m ? m.timestamp : [CWTimeUtil currentTimestampe];
    
    __weak typeof(self) weakSelf = self;
    id<CWMessageDBProtocol> db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
    [db messagesWithTimestamp:timestamp relatedBy:CWTimeRelationLessThan andLimit:limit andSortBy:CWSortTypeDESC forSession:self.session.sessionId withCompleteHandler:^(NSMutableArray<CubeMessageEntity *> *messages) {
        if(messages.count)
        {
			[self prepareBaseInfoForMessages:messages requireWhenNotExist:YES];//准备用户信息
            NSMutableArray *sortedArray = [CWSessionUtil revertMessages:messages withTimeIndicateInterval:180 onBasisOf:weakSelf.msgsArray.firstObject];			
            NSMutableArray *tempArray = [weakSelf.msgsArray mutableCopy];
            if(!tempArray)
            {
                tempArray = [NSMutableArray array];
            }
            [tempArray insertObjects:sortedArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sortedArray.count)]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.msgsArray = tempArray;
                [weakSelf.msgList reloadData];
                [weakSelf.msgList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sortedArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        if(handler)
        {
            handler(messages.count);
        }
    }];
}

-(void)showHistoryNoticeIfNeed{
    if(self.session.unReadCount)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(self.session.unReadCount > 10){
                id<CWMessageDBProtocol> db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
                CubeMessageEntity *msg = [db oldestUnreadMessageForSession:self.session.sessionId];
                
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.session.unReadCount > 0)
                        {
                            weakSelf.historyNoticeView.contentLabel.text = [NSString stringWithFormat:@"%d条新消息",self.session.unReadCount];
                            weakSelf.historyNoticeView.oldestUnreadMessage = msg;
                            weakSelf.historyNoticeView.didClickedHandler = ^(CubeMessageEntity *msg){

                                [weakSelf.historyNoticeView dismissWithAnimationTime:0.22];
                                weakSelf.historyNoticeView = nil;

                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    NSMutableArray *sortedArray = nil;
                                    __block int locate = -1;
                                    if(msg.timestamp < [(CubeMessageEntity *)weakSelf.msgsArray.firstObject timestamp])
                                    {
                                        NSInteger messageCount = [db countMessagesAfter:msg inSession:weakSelf.session.sessionId] - weakSelf.msgsArray.count;
                                        if(messageCount > 200)
                                        {
                                            messageCount = 200;
                                        }
                                        else
                                        {
                                            messageCount = ceil(messageCount / 10.0) * 10;
                                        }

                                        //消息不在当前列表中，则从数据库查询消息，并且最多查询200条，以防止一次加载太多
                                        NSMutableArray *msgs = [db messagesWithTimestamp:[(CubeMessageEntity *)weakSelf.msgsArray.firstObject timestamp] relatedBy:CWTimeRelationLessThan andLimit:messageCount andSortBy:CWSortTypeDESC forSession:weakSelf.session.sessionId];
                                        [self prepareBaseInfoForMessages:msgs requireWhenNotExist:YES];
                                        sortedArray = [CWSessionUtil revertMessages:msgs withTimeIndicateInterval:180 onBasisOf:weakSelf.msgsArray.firstObject];

                                        for (int i = 0; i < sortedArray.count; i++) {
                                            CubeMessageEntity *tempMsg = sortedArray[i];
                                            if([tempMsg isKindOfClass:[CubeMessageEntity class]] && tempMsg.SN == msg.SN)
                                            {
                                                [sortedArray insertObject:[CWTipModel tipWithType:CWTipTypeHistoryNotice andContent:@"以下为未读消息" andUserInfo:nil] atIndex:i];
                                                locate = i + 1;
                                                break;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        sortedArray = [NSMutableArray array];
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        //消息在当前数组中
                                        if(!sortedArray.count)
                                        {
                                            for (int i = 0; i < weakSelf.msgsArray.count; i ++) {
                                                CubeMessageEntity *tempMsg = weakSelf.msgsArray[i];
                                                if([tempMsg isKindOfClass:[CubeMessageEntity class]] && tempMsg.SN == msg.SN)
                                                {
                                                    [weakSelf.msgsArray insertObject:[CWTipModel tipWithType:CWTipTypeHistoryNotice andContent:@"以下为未读消息" andUserInfo:nil] atIndex:i];
                                                    locate = i + 1;
                                                    break;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            if(sortedArray.count)
                                            {
                                                [weakSelf.msgsArray insertObjects:sortedArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sortedArray.count)]];
                                            }
                                            if(locate < 0)
                                            {
                                                //消息未在查出的列表中，历史消息超过了200条的情况
                                                locate = 0;
                                                [weakSelf.msgsArray insertObject:[CWTipModel tipWithType:CWTipTypeHistoryNotice andContent:@"以下为未读消息" andUserInfo:nil] atIndex:locate];
                                            }

                                        }
                                        [weakSelf.msgList reloadData];
                                        [weakSelf .msgList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:locate inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                    });
                                });
                            };
                            [weakSelf.historyNoticeView showInView:self.view withTopOffset:20 + self.navigationController.navigationBar.bounds.size.height + 20 andAnimationTime:0.22];
                        }
                });
            }
            [[CubeWare sharedSingleton].messageService resetSessionUnreadCount:self.session];
        });
    }
}

/**检查资源是否可用*/
-(void)checkResourceAvailable:(id)content{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if([content isKindOfClass:[CubeImageMessage class]])
//        {
//            CubeImageMessage *msg = content;
//            if(!msg.thumbPath.length)
//            {
//                [[CubeEngine sharedSingleton].messageService acceptMessage:msg.SN withMessageOperator:CubeMessageOperatorImageThumb];
//            }
//        }
//        else if([content isKindOfClass:[CubeVideoClipMessage class]])
//        {
//            CubeVideoClipMessage *msg = content;
//            if(!msg.thumbPath.length)
//            {
//                [[CubeEngine sharedSingleton].messageService acceptMessage:msg.SN withMessageOperator:CubeMessageOperatorVideoThumb];
//            }
//        }
//        else if ([content isKindOfClass:[CubeVoiceClipMessage class]]){
//            CubeVoiceClipMessage *msg = content;
//            if (!msg.filePath.length) {
//                [[CubeEngine sharedSingleton].messageService acceptMessage:msg.SN withMessageOperator:CubeMessageOperatorVoiceMP3];
//            }
//        }
//    });
}



- (void)sendImageMessage:(NSData *)imageData  andThumbImageData:(NSData *)thumbImageData  andNameStr:(NSString *)name andSize:(CGSize)size isFile:(BOOL)isFile
{
    //原图
    NSString *imageFolder = [CWUtils subFolderAtDocumentWithName:@"CubeEngine/Message/Image"];
    NSString *filePath = [imageFolder stringByAppendingPathComponent:name];
    [imageData writeToFile:filePath atomically:YES];
    //缩略图
    NSString *imageThumbFolder = [CWUtils subFolderAtDocumentWithName:@"CubeEngine/Message/thumb"];
    NSString *thumbPath = [imageThumbFolder stringByAppendingPathComponent:name];
    [thumbImageData writeToFile:thumbPath atomically:YES];
    if(isFile){
        CubeFileMessage *fileMessage = [CWMessageUtil fileMessageWithPath:filePath andName:name forSession:self.session];
        [[CubeWare sharedSingleton].fileService startUploadFileWithFileMessage:fileMessage];
    }else{
        CubeImageMessage *imageMessage = [CWMessageUtil imageMessageWithPath:filePath andThumbPath:thumbPath andName:name andFileSize:0 andSize:size forSession:self.session];
        [[CubeWare sharedSingleton].fileService startUploadFileWithFileMessage:imageMessage];
    }
}
-(void)voiceClipMessageOnclick:(CubeMessageEntity *)msg onCell:(CWMessageCell *)cell{
    if ([CubeEngine sharedSingleton].mediaService.isCalling) {
        [CWToastUtil showTextMessage:@"正在通话，无法播放" andDelay:1];
        return;
    }
    if ([msg isKindOfClass:[CubeVoiceClipMessage class]]) {
        CubeVoiceClipMessage * voiceClipMsg =(CubeVoiceClipMessage *) msg;
        if ([CWMessageUtil isExistFile:voiceClipMsg andAddition:@"Voice"]) {
            voiceClipMsg.receipted = YES;
			if(!voiceClipMsg.receiptTimestamp)
			{
				voiceClipMsg.receiptTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
				id<CWMessageDBProtocol> db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
				[db saveOrUpdateMessage:voiceClipMsg];
			}
            CWAudioMessageCell * audioCell = (CWAudioMessageCell *)cell;
			audioCell.isRead = YES;
            [audioCell startPlayAudio];
        }
        else
        {
            //下载
            [[CubeWare sharedSingleton].fileService startDownloadFileWithFileMessage:voiceClipMsg andBlock:^(CubeFileMessage *message) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * filePath = [CWMessageUtil saveFilePath:message andAddition:@"Voice"];;
                    voiceClipMsg.receipted = YES;
                    voiceClipMsg.filePath = message.filePath;
                    if(!voiceClipMsg.receiptTimestamp)
                    {
                        voiceClipMsg.receiptTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
                        id<CWMessageDBProtocol> db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
                        [db saveOrUpdateMessage:voiceClipMsg];
                    }
                    CWAudioMessageCell * audioCell = (CWAudioMessageCell *)cell;
                    audioCell.isRead = YES;
                    [audioCell startPlayAudio];
                });
            }];
        }
    }
}
- (void)imageMessageOnclick:(CWMessageCell *)cell{
    if(![cell isKindOfClass:[CWImageMessageCell class]])return;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    CWImageMessageCell * imageCell = (CWImageMessageCell *)cell;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.frame];
    [window addSubview:imageV];
    imageV.backgroundColor = [UIColor blackColor];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = imageCell.image;
    
    
    id<CWMessageDBProtocol> messageSessionDB = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
    [messageSessionDB messagesWithType:CubeMessageTypeImage andTimestamp:0 relatedBy:CWTimeRelationGreaterThanOrEqual andLimit:-1 andSortBy:CWSortTypeASC forSession:self.session.sessionId withCompleteHandler:^(NSMutableArray<CubeMessageEntity *> *imageMessageEntityArr) {
        NSMutableArray *photoUrlArr = [NSMutableArray array];
        __block NSInteger currentIndex;
        [imageMessageEntityArr enumerateObjectsUsingBlock:^(CubeMessageEntity * _Nonnull msg, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![msg isKindOfClass:[CubeImageMessage class]])return;
            if(cell.currentContent.SN == msg.SN){
                currentIndex = idx;
            }
            CubeImageMessage * imageMsg = (CubeImageMessage *)msg;
            UIImage *thumbImage = imageMsg.thumbPath ? [UIImage imageWithContentsOfFile:imageMsg.thumbPath] : [UIImage imageNamed:@"placeholderImage"];
            JGPhoto *photo = [[JGPhoto alloc] init];
            NSURL * imageUrl = [NSURL URLWithString:(imageMsg.filePath ? imageMsg.filePath : imageMsg.url)];
            photo.url =imageUrl;
            photo.placeholder = thumbImage;
            photo.identifier = [NSString stringWithFormat:@"%lld",msg.SN];
            [photoUrlArr addObject:photo];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            JGPhotoBrowser * photoBrowser = [[JGPhotoBrowser alloc] initWithPhotos:photoUrlArr index:currentIndex];
            photoBrowser.delegate =self;
            [photoBrowser show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                imageV.alpha = 0;
            });
            
        });
        
    }];
//    NSArray<MessageEntity *> * imageMessageEntityArr = [messageSessionDB messagesWithType:CubeMessageTypeImage andTimestamp:0 relatedBy:CWTimeRelationGreaterThanOrEqual andLimit:-1 andSortBy:CWSortTypeASC forSession:self.session.sessionId];
    
}

- (void)customMessageOnClick:(CWMessageCell *)cell
{
    CubeMessageEntity *msg = cell.currentContent;
    if (![msg isKindOfClass:[CubeCustomMessage class]]) {
        return;
    }
    CubeCustomMessage *customMsg = (CubeCustomMessage *)msg;
    NSString *operate = [customMsg.header objectForKey:@"operate"];
    if([operate isEqualToString:@"videoCall"])
    {
        [self onClickP2PVideoItem];
    }
    else if ([operate isEqualToString:@"voiceCall"])
    {
        [self onClickP2PCallItem];
    }
    else if ([operate isEqualToString:@"share_wb"])
    {
        [self onClickP2PWhiteBoardItem];
    }
}

- (void)fileMessageOnclick:(CWMessageCell *)cell{
    CubeMessageEntity *msg = cell.currentContent;
    if(![msg isKindOfClass:[CubeFileMessage class]])return;
    CubeFileMessage * fileMsg = (CubeFileMessage *)msg;
    if([CWMessageUtil isExistFile:fileMsg andAddition:@"File"])
    {
        NSURL * url = [NSURL fileURLWithPath:fileMsg.filePath];
        _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        _documentInteractionController.delegate = self;
        BOOL isCanPreview = [_documentInteractionController presentPreviewAnimated:YES];
        if (!isCanPreview) {
            [CWToastUtil showTextMessage:@"无法预览该文件" andDelay:1.f];
        }
    }else{
        [[CubeWare sharedSingleton].fileService startDownloadFileWithFileMessage:fileMsg andBlock:^(CubeFileMessage *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CWMessageUtil saveFilePath:message andAddition:@"File"];
                fileMsg.receipted = YES;
                fileMsg.filePath = message.filePath;
                if(!fileMsg.receiptTimestamp)
                {
                    fileMsg.receiptTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
                    id<CWMessageDBProtocol> db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWMessageDBProtocol)] firstObject];
                    [db saveOrUpdateMessage:fileMsg];
                }
            });
        }];
    }
}
- (void)videoMessageOnclick:(CWMessageCell *)cell{
    if(![cell isKindOfClass:[CWVideoMessageCell class]])return;
    if(![cell.currentContent isKindOfClass:[CubeVideoClipMessage class]])return;
    CubeVideoClipMessage *videoMsg = (CubeVideoClipMessage *)cell.currentContent;
    if([CWMessageUtil isExistFile:videoMsg andAddition:@"Video"]){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.playerView];
        [_playerView updatePlayerProgress:1.f andMessageModel:videoMsg];
    }else{
        //下载
        [[CubeWare sharedSingleton].fileService startDownloadFileWithFileMessage:videoMsg andBlock:^(CubeFileMessage *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CWMessageUtil saveFilePath:message andAddition:@"Voice"];
                CubeVideoClipMessage *videoMsg = (CubeVideoClipMessage *)message;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:self.playerView];
                [self.playerView updatePlayerProgress:1.f andMessageModel:videoMsg];
            });
        }];
    }
}


#pragma mark - getters and setters

-(NSMutableArray *)msgsArray{
    if(!_msgsArray)
    {
        _msgsArray = [NSMutableArray array];
    }
    return _msgsArray;
}

-(UITableView *)msgList{
    if(!_msgList)
    {
        _msgList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _msgList.delegate = self;
        _msgList.dataSource = self;
        _msgList.translatesAutoresizingMaskIntoConstraints = NO;
        _msgList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _msgList.backgroundColor = [UIColor whiteColor];
		_msgList.estimatedRowHeight = 0;
		_msgList.estimatedSectionHeaderHeight = 0;
		_msgList.estimatedSectionFooterHeight = 0;
        [self.view addSubview:_msgList];
    }
    return _msgList;
}

-(CWCustomBoardView *)customBoardView{
    if (!_customBoardView) {
        _customBoardView = [[CWCustomBoardView alloc] init];
        _customBoardView.toolBarItemModelArr = self.toolBarItemsArr;
        _customBoardView.delegate = self;
        _customBoardView.dataSource = self;
//        _customBoardView.moreItemModel = [CWSessionViewDataConfig moreToolBarItem];
        _customBoardView.backgroundColor = CWSessionBackground;
        [self.view addSubview:_customBoardView];
    }
    return _customBoardView;
}
    
- (NSArray<CWToolBarItemModel *> *)toolBarItemsArr{
    
    if (!_toolBarItemsArr) {
        _toolBarItemsArr =  [CWSessionViewDataConfig getToolBarItem];

    }
    return _toolBarItemsArr;
}

- (NSArray<CWToolBarItemModel *> *)moreItemArr{
    if(!_moreItemArr){
        if (self.session.sessionType == CWSessionTypeP2P) { // 1v1
            _moreItemArr = [CWSessionViewDataConfig getP2PBarItem];
        }else if(self.session.sessionType == CWSessionTypeGroup){
            _moreItemArr = [CWSessionViewDataConfig getGroupBarItem];
        }
    }
    return _moreItemArr;
}

-(CWEmojiBoardView *)emojiBoardView{
    if (!_emojiBoardView) {
        _emojiBoardView = [[CWEmojiBoardView alloc] init];
        _emojiBoardView.emojiPackageArr = self.emojiPackageModelArr;
        _emojiBoardView.delegate = self;
    }
    return _emojiBoardView;
}

-(CWRecordView *)recordBoardView{
    if (!_recordBoardView) {
        _recordBoardView = [[CWRecordView alloc] init];
        _recordBoardView.delegate = self;
    }
    return _recordBoardView;
}

- (NSArray<CWEmojiPackageModel *> *)emojiPackageModelArr{
    if (!_emojiPackageModelArr) {
        _emojiPackageModelArr = [NSMutableArray arrayWithArray:[CWSessionViewDataConfig getSystemEmojiPackageModelArr]];
    }
    return _emojiPackageModelArr;
}
- (CWMoreBoardView *)moreBoardView{
    if (!_moreBoardView) {
        _moreBoardView = [[CWMoreBoardView alloc] init];
        _moreBoardView.moreItemsArr = self.moreItemArr;
        _moreBoardView.delegate = self;
    }
    return _moreBoardView;
}

-(void)setFacialEmojiPackageArr:(NSArray *)facialEmojiArr{
    _facialEmojiPackageArr = facialEmojiArr;
    self.emojiPackageModelArr = nil;
    [self.emojiPackageModelArr addObjectsFromArray:facialEmojiArr];
    self.emojiPackageModelArr = self.emojiPackageModelArr;
}

-(CWHistoryNoticeView *)historyNoticeView{
    if(!_historyNoticeView)
    {
        _historyNoticeView = [[CWHistoryNoticeView alloc] initWithFrame:CGRectZero];
        _historyNoticeView.iconImageView.image = [CWResourceUtil imageNamed:@"unread_icon"];
        _historyNoticeView.upArrowImageView.image = [CWResourceUtil imageNamed:@"unread_oldmessage"];
    }

    return _historyNoticeView;
}

-(CWNewArriveNoticeView *)newArriveNoticeView{
    if(!_newArriveNoticeView)
    {
        __weak typeof(self) weakSelf = self;
        _newArriveNoticeView = [[CWNewArriveNoticeView alloc] init];
        _newArriveNoticeView.didClickedHandler = ^{
            weakSelf.needScrollToBottom = YES;
            [weakSelf.msgList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.msgsArray.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        };
        [self.view addSubview:_newArriveNoticeView];
        [_newArriveNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.msgList);
            make.right.equalTo(self.msgList).with.offset(-20);
        }];
    }
    return _newArriveNoticeView;
}

- (CWPlayerView *)playerView{
    if (!_playerView) {
        CWPlayerView *player=[[CWPlayerView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        player.delegate = self;
        _playerView = player;
    }
    return _playerView;
}


#pragma mark - events
//1V1 通话
- (void)onClickP2PCallItem{
    if(![[CWHttpClient defaultClient] isConnectionAvailable]){
        [CWToastUtil showTextMessage:@"网络不可用,请检查网络设置" andDelay:1.0f];
        return;
    }
    
    [CWAuthorizeManager authorizeForType:CWAuthorizeTypeMIC completed:^(BOOL isAllow, NSError *error) {
        if(isAllow){
            
            CubeCallSession *callSession = [[CubeEngine sharedSingleton].mediaService currentCallWithCallType:CubeCallTypeCall].firstObject;
            [CWAudioRootView AudioRootView].cubeId = self.session.sessionId;
            
            if (callSession) {
                [CWToastUtil showTextMessage:@"正在通话中,请稍后再试" andDelay:1.f];
            }
            else{
                [[CWAudioRootView AudioRootView] setAudioType:SingleAudioType];
                BOOL ret = [[CWAudioRootView AudioRootView] fireAudioCall];
                if(ret)
                {
                    NSLog(@"cubeEngine fireAudioCall success");
                }
                else
                {
                    NSLog(@"cubeEngine fireAudioCall fail");
                }
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [CWToastUtil showTextMessage:@"无法呼叫" andDelay:1.0];
            });
        }
    }];
}
//群通话
- (void)onClickGroupCallItem{
    NSLog(@"Click groupCall...");
    id session = [[CubeEngine sharedSingleton].mediaService currentCallWithCallType:CubeCallTypeConfernce].firstObject;
    if (session) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CWToastUtil showTextMessage:@"正在通话中,请稍后再试" andDelay:1.0f];
        });
    }
    else{
        [[CWAudioRootView AudioRootView] setAudioType:GroupAudioType];
//      [CWAudioRootView AudioRootView].conference = self.session;
        CWChooseContactController *chooseContactVc = [[CWChooseContactController alloc] initWithChooseContactType:ChooseContactTypeGroup existMemberArray:nil andClickRightItemBlock:^(NSArray *selectedArray) {
            CubeConferenceConfig *config = [[CubeConferenceConfig alloc] initWithGroupType:CubeGroupType_Voice_Call withDisplayName:@""];
            NSMutableArray *invites = [NSMutableArray array];
            for (CubeGroupMember *member in selectedArray) {
                [invites addObject:member.cubeId];
            }
            config.invites = invites; // 手动调用邀请...
            config.maxMember = 9;
            config.bindGroupId = self.session.sessionId;
            [[CubeEngine sharedSingleton].conferenceService createConferenceWithConfig:config];
        }];
        chooseContactVc.hidesBottomBarWhenPushed = YES;
        chooseContactVc.groupId = self.session.sessionId;
        [self.navigationController pushViewController:chooseContactVc animated:YES];
    }
//    Conference *conference = [[CWGroupAVManager sharedSingleton] getGroupAVStack:self.session.sessionId];
//    if (0)
//    {
//        //多人
//#warning For Test
//        //                 [[CWAudioRootView AudioRootView] joinInConference];
//        //                 [[CWAudioRootView AudioRootView] setAudioType:GroupAudioType];
//    }
//    else
//    {
//        CubeSession *session = [CubeEngine sharedSingleton].session;
//        //判断自己是否正在音视频中
//        if (session && [session isCalling]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [CWUtils showTextMessage:@"正在通话中,请稍后再试" andDelay:1.f];
//                [CWToastUtil showTextMessage:@"正在通话中,请稍后再试" andDelay:1.0f];
//
//            });
//        }
//        else
//        {
//            //多人
//            [[CWAudioRootView AudioRootView] setAudioType:GroupAudioType];
//
//            //                //跳转到选择联系人页面
//            //                CWChooseContactController *vc = [[CWChooseContactController alloc]init];
//            //                vc.hidesBottomBarWhenPushed = YES;
//            //                [self.navigationController pushViewController:vc animated:YES];
//
//#warning For Test g1110093 me 201489 others 201506
//            ConferenType type = ConferenTypeVoiceCall;
//            BOOL ret = [[[CubeEngine sharedSingleton] getConferenceService] applyConferenceWithGroupid:self.session.sessionId andCubeIds:@[@"202751",@"202537"] andConferenceType:type andMaxMember:9 andMergeScreen:NO andExpiredTime:0 andForceCreate:YES];
//            [[CWGroupAVManager sharedSingleton].memberDic setObject:@[@"202751",@"202537"] forKey:self.session.sessionId];
//            if (ret)
//            {
//                NSLog(@"cubeEngine applyConferenceWithGroupid success");
//            }
//            else
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [CWToastUtil showTextMessage:@"多人音频呼叫失败" andDelay:2.f];
//                });
//            }
//        }
//
//    }
}

-(void)onClickGroupVideoItem{
    NSLog(@"click群视频通话");
    id session = [[CubeEngine sharedSingleton].mediaService currentCallWithCallType:CubeCallTypeConfernce].firstObject;
    if (session) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CWToastUtil showTextMessage:@"正在通话中,请稍后再试" andDelay:1.0f];
        });
    }
    else{
//        [[CWAudioRootView AudioRootView] setAudioType:GroupAudioType];
        //[CWAudioRootView AudioRootView].conference = self.session;
        CWChooseContactController *chooseContactVc = [[CWChooseContactController alloc] initWithChooseContactType:ChooseContactTypeGroup existMemberArray:nil andClickRightItemBlock:^(NSArray *selectedArray) {
            CubeConferenceConfig *config = [[CubeConferenceConfig alloc] initWithGroupType:CubeGroupType_Video_Call withDisplayName:@""];
            config.maxMember = 9;
            NSMutableArray *invites = [NSMutableArray array];
            for (CubeGroupMember *member in selectedArray) {
                [invites addObject:member.cubeId];
            }
            config.invites = invites; // 手动调用邀请...
            config.isMux = YES;
            config.bindGroupId = self.session.sessionId;
            [[CubeEngine sharedSingleton].conferenceService createConferenceWithConfig:config];
        }];
        chooseContactVc.hidesBottomBarWhenPushed = YES;
        chooseContactVc.groupId = self.session.sessionId;
        [self.navigationController pushViewController:chooseContactVc animated:YES];
    }
}

- (void)onClickP2PWhiteBoardItem{
    NSLog(@"click p2p白板演示");
    
    CubeWhiteBoardConfig *config = [[CubeWhiteBoardConfig alloc] initWithGroupType:CubeGroupType_Share_WB withDisplayName:@"白板分享"];
    config.invites = @[self.session.sessionId];
    config.maxNumber = 2; // p2p类型
    [[CubeEngine sharedSingleton].whiteBoardService createWhiteBoardWithConfig:config];
}

- (void)onClickGroupWhiteBoardItem{
    NSLog(@"click白板演示");
    CWChooseContactController *chooseContactVc = [[CWChooseContactController alloc] initWithChooseContactType:ChooseContactTypeGroup existMemberArray:nil andClickRightItemBlock:^(NSArray *selectedArray) {
        CubeWhiteBoardConfig *config = [[CubeWhiteBoardConfig alloc] initWithGroupType:CubeGroupType_Share_WB withDisplayName:@"白板分享"];
        config.bindGroupId = self.session.sessionId;
        config.maxNumber = 9;
        NSMutableArray *invites = [NSMutableArray array];
        for (CubeGroupMember *member in selectedArray) {
            [invites addObject:member.cubeId];
        }
        config.invites = invites; // 手动调用邀请...
        [[CubeEngine sharedSingleton].whiteBoardService createWhiteBoardWithConfig:config];
    }];
    chooseContactVc.hidesBottomBarWhenPushed = YES;
    chooseContactVc.groupId = self.session.sessionId;
    [self.navigationController pushViewController:chooseContactVc animated:YES];
}


// 1V1 视频
- (void)onClickP2PVideoItem{
    NSLog(@"onClickVideoItem");
    __block BOOL cameraAllow = NO;
    __block BOOL micAllow = NO;
    [CWAuthorizeManager authorizeForType:CWAuthorizeTypeCamera completed:^(BOOL isAllow, NSError *error) {
        cameraAllow = isAllow;
        [CWAuthorizeManager authorizeForType:CWAuthorizeTypeMIC completed:^(BOOL isAllow, NSError *error) {
            micAllow = isAllow;
            // 检查权限
            if (!cameraAllow || !micAllow){
                [self showAuthFailAlertViewControllerWithTitle:nil message:@"请在iPhone的”设置-隐私“选项中，允许坐标访问你的摄像头和麦克风"];
                return;
            }
            //检测网络
            if(![[CWHttpClient defaultClient] isConnectionAvailable]){
                [CWToastUtil showTextMessage:@"网络不可用,请检查网络设置" andDelay:1.f];
                return ;
            }
            
            CubeCallSession *callSession = [[CubeEngine sharedSingleton].mediaService currentCallWithCallType:CubeCallTypeCall].firstObject;
        
            if (callSession) {
                [CWToastUtil showTextMessage:@"正在通话中,请稍后再试" andDelay:1.f];
            }
            else{
                
                NSString *callee = self.session.sessionId;
                BOOL ret = [[CubeEngine sharedSingleton].callService makeCallWithCallee:[CubeUser userWithCubeId:callee andDiaplayName:nil andAvatar:nil] andEnableVideo:YES];
                if (ret) {
                    NSLog(@"正在呼叫 %@", callee);
                }else {
                    NSLog(@"呼叫%@失败，请稍候重试", callee);
                    [CWToastUtil showTextMessage:[NSString stringWithFormat:@"呼叫失败,请稍后再试"] andDelay:1.f];
                }
            }
        }];
    }];
}

- (void)onClickShakeItem
{
    
    if(!_lastShakeDate || [[NSDate date] timeIntervalSinceDate:_lastShakeDate] > 60){
        _lastShakeDate = [NSDate date];
         CubeCustomMessage *customMessage = [CWMessageUtil shakeCustomMessageForSession:self.session];
        [[CubeWare sharedSingleton].messageService sendMessage:customMessage forSession:self.session];
        [[CWMessageRinging sharedSingleton] shake];
    }else{
        [CWToastUtil showTextMessage:@"您发的窗口抖动太频繁,请稍后再试" andDelay:1.0f];
    }
    

}
    
- (void)showAuthFailAlertViewControllerWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)applyJoinInGroupAudio
{
    [[CWAudioRootView AudioRootView] setAudioType:ApplyAudioType];
    [[CWAudioRootView AudioRootView] showView];
}


/**图片选择器*/
- (void)showImagePickerViewController{
    [CWAuthorizeManager authorizeForType:CWAuthorizeTypePhotoLibrary completed:^(BOOL isAllow, NSError *error) {
        CWImagePickerController *imagePickerVc =
        [[CWImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVc.imageLength = 10 * 1024 * 1024;
        imagePickerVc.totalImageLength = NSIntegerMax;
        imagePickerVc.imageSize = CGSizeMake(4096, 4096);
        imagePickerVc.isSelectOriginalPhoto = NO;
        imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        imagePickerVc.oKButtonTitleColorNormal = UIColorFromRGB(0x8a8fa4);
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }];
}

- (void)showCameraViewController{
    [CWAuthorizeManager authorizeForType:CWAuthorizeTypeCamera completed:^(BOOL isAllow, NSError *error) {
        if(isAllow){
            CWCameraViewController *cameraController = [[CWCameraViewController alloc] init];
            cameraController.delegate = self;
            cameraController.needTransCode = YES;
            [self presentViewController:cameraController animated:YES completion:nil];
        }
       
    }];
}

- (void)showFilePickerViewController
{
    CWFilePickerController * filePickerVC = [[CWFilePickerController alloc]init];
    filePickerVC.navigationItem.hidesBackButton = YES;
    filePickerVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filePickerVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


@end
