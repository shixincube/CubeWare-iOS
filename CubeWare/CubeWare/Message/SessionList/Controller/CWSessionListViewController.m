//
//  CWSessionListViewController.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSessionListViewController.h"
#import "CWSessionViewController.h"
#import "CWSessionListCell.h"

#import "CWSessionUtil.h"
#import "CubeWareHeader.h"

#import "CWSessionDBProtocol.h"
#import "CWSessionRefreshDelegate.h"
#import "CWInfoRefreshDelegate.h"

@interface CWSessionListViewController ()<CWSessionRefreshProtocol,CWInfoRefreshDelegate>

@property (nonatomic, strong) NSMutableDictionary *baseInfoCache;

@end

@implementation CWSessionListViewController

#pragma mark - - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.sessionList];
    
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWSessionRefreshProtocol),@protocol(CWInfoRefreshDelegate)]];
	
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.sessionArray.count)
    {
        [self loadSessionsFromDB];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sessionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	CWSession *content = self.sessionArray[indexPath.row];
	
	Class cls = [self getCellClassForContent:content];
	
	UITableViewCell<CWContentCellProtocol> *cell = [self.sessionList dequeueReusableCellWithIdentifier:[cls reuseIdentifier]];
	
	if(!cell)
	{
		cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cls reuseIdentifier]];
	}
	
    [cell configUIWithContent:content];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	id content = self.sessionArray[indexPath.row];
	return [[self getCellClassForContent:content] cellHeigtForContent:content inSession:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CWSession *session = self.sessionArray[indexPath.row];
    CWSessionViewController *sessionVC = [[CWSessionViewController alloc] initWithSession:session];
	sessionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionVC animated:YES];
}

#pragma mark - CWSessionRefreshProtocol

-(void)sessionsUpdated:(NSArray<CWSession *> *)sessions{
    /*
     1.记录session的原本位置和待插入位置
     2.session不存在，则添加新的session，否则更新session
     3.交换将session调整至指定位置
     */
    
    dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableArray *needBaseInfoSessions = [NSMutableArray array];
        for (CWSession *s in sessions) {
            //插入位置
            NSInteger insertIndex = -1;
            //session本来所在的位置
            NSInteger locateIndex = -1;
            for(int i = 0 ; i < self.sessionArray.count; i++){
                CWSession *tempSession = self.sessionArray[i];
                if(insertIndex < 0)
				{
					if(s.topped > tempSession.topped)
					{
						insertIndex = i;
					}
					else if (s.topped == tempSession.topped  && s.lastesTimestamp > tempSession.lastesTimestamp)
					{
						//时间戳比较不取等号，预防自己和自己比较的情况
						insertIndex = i;
					}
                }
                if([s.sessionId isEqualToString:tempSession.sessionId])
				{
                    locateIndex = i;
                }
                if(locateIndex >= 0 && insertIndex >= 0)
                    break;
            }
            
            if(locateIndex < 0)
			{
                //新添session
                locateIndex = self.sessionArray.count;
                [self.sessionArray addObject:s];
                [self.sessionList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:locateIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                if(![[CubeWare sharedSingleton].infoManager userInfoForCubeId:s.sessionId inSession:nil])
//                {
//                    [needBaseInfoSessions addObject:s.sessionId];
//                }
            }
			else
			{
                //更新旧的session
                [self.sessionArray replaceObjectAtIndex:locateIndex withObject:s];
                [self.sessionList reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:locateIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
			
			[s registerAsSessionInfoRepotor];
            
            if(insertIndex < 0)
                //将session插在最后一个
                insertIndex = self.sessionArray.count - 1;
            
            if(locateIndex != insertIndex){
                //移动位置
                NSMutableArray *tempArray = [self.sessionArray mutableCopy];
                id obj = [tempArray objectAtIndex:locateIndex];
                [tempArray insertObject:obj atIndex:insertIndex];
                [tempArray removeObjectAtIndex:locateIndex > insertIndex ? locateIndex + 1 : locateIndex];
                
                self.sessionArray = tempArray;
                
				[self.sessionList moveRowAtIndexPath:[NSIndexPath indexPathForRow:locateIndex inSection:0] toIndexPath:[NSIndexPath indexPathForRow:insertIndex > locateIndex ? insertIndex - 1 : insertIndex inSection:0]];
            }
        }
		[[CubeWare sharedSingleton].messageService collectionUnreadCountInfo];
		if(needBaseInfoSessions.count)
		{
			[[CubeWare sharedSingleton].infoManager.delegate needUsersInfoFor:needBaseInfoSessions inSession:nil];
		}
    });
}

-(void)sessionsDeleted:(NSArray<CWSession *> *)sessions{
	dispatch_async(dispatch_get_main_queue(), ^{
		for (CWSession *s in sessions)
		{
			int locateIndex = -1;
			for (int i = 0; i < self.sessionArray.count; i ++) {
				if([self.sessionArray[i].sessionId isEqualToString:s.sessionId])
				{
					locateIndex = i;
					break;
				}
			}
			if(locateIndex > -1)
			{
				[self.sessionArray removeObjectAtIndex:locateIndex];
				[self.sessionList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:locateIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}
		[[CubeWare sharedSingleton].messageService collectionUnreadCountInfo];
	});
}

#pragma mark - CWInfoRefreshDelegate

-(void)changeCurrentUser:(CWUserModel *)user{
	[self loadSessionsFromDB];
}

-(void)usersInfoUpdated:(NSArray<CWUserModel *> *)users inSession:(CWSession *)session{
	if(!session && users.count)
	{
		for (CWUserModel *user in users) {
			for(int i = 0; i < self.sessionArray.count; i++)
			{
				CWSession *session = self.sessionArray[i];
				if([session.sessionId isEqualToString:user.cubeId])
				{
//					session.baseInfo = baseInfo;
					break;
				}
			}
		}
	}
}

- (void)updateSessionList:(NSArray *)conferences
{
    NSMutableArray *newSessionList = [NSMutableArray array];
    for(int i = 0; i < self.sessionArray.count; i++)
    {
        CWSession *session = self.sessionArray[i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bindGroupId == %@",session.sessionId];
        NSArray *result = [conferences filteredArrayUsingPredicate:predicate];
        if (result && result.count > 0) {
            CubeConference *conference = result.firstObject;
            session.conferenceType = conference.type;
        }
        else
        {
            session.conferenceType = nil;
        }
        [newSessionList addObject:session];
    }
    [[CubeWare sharedSingleton].messageService updateSessions:newSessionList];
}

#pragma mark - Public Method

#pragma mark - Private Method

-(void)loadSessionsFromDB{
    __weak typeof(self) weakSelf = self;
    id<CWSessionDBProtocol> db = [[[CWWorkerFinder defaultFinder] findWorkerForProtocol:@protocol(CWSessionDBProtocol)] firstObject];
    [db sessionWithTimestamp:0 relatedBy:CWTimeRelationGreaterThanOrEqual andLimit:-1 andSortBy:CWSortTypeDESC withCompleteHandler:^(NSMutableArray<CWSession *> *sessions) {
		//查找缺失基础信息的会话
		NSMutableArray *needBaseInfoSessions = [NSMutableArray array];
		for (CWSession *session in sessions) {
			[session registerAsSessionInfoRepotor];
			if(![[CubeWare sharedSingleton].infoManager userInfoForCubeId:session.sessionId inSession:nil])
			{
				[needBaseInfoSessions addObject:session.sessionId];
			}
		}
		
		if(needBaseInfoSessions.count)
		{
			//要求提供基础信息
			[[CubeWare sharedSingleton].infoManager.delegate needUsersInfoFor:needBaseInfoSessions inSession:nil];
		}
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(sortSessions)])
		{
			weakSelf.sessionArray = [self.delegate sortSessions];
		}
		else
		{
        	weakSelf.sessionArray = [CWSessionUtil sortSessions:sessions];
		}
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.sessionList reloadData];
        });
		[[CubeWare sharedSingleton].messageService collectionUnreadCountInfo];
    }];
}

#pragma mark - getters and setters

-(UITableView *)sessionList{
    if(!_sessionList)
    {
        _sessionList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _sessionList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sessionList.backgroundColor = [UIColor whiteColor];
        _sessionList.dataSource = self;
        _sessionList.delegate = self;
        [self.sessionList registerClass:[CWSessionListCell class] forCellReuseIdentifier:[CWSessionListCell reuseIdentifier]];
        
        [self.view addSubview:_sessionList];
//        _sessionList.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_sessionList attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:50]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_sessionList attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_sessionList attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_sessionList attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    return _sessionList;
}

-(NSMutableArray *)sessionArray{
    if(!_sessionArray)
    {
        _sessionArray = [NSMutableArray array];
    }
    return _sessionArray;
}


#pragma mark - tool

-(Class<CWContentCellProtocol>)getCellClassForContent:(id)content
{
	Class cls = nil;
	if(self.delegate && [self.delegate respondsToSelector:@selector(cellClassForContent:)])
	{
		cls = [self.delegate cellClassForContent:content];
	}
	
	if(!cls)
	{
		cls = [CWSessionListCell class];
	}
	
	return cls;
}

@end
