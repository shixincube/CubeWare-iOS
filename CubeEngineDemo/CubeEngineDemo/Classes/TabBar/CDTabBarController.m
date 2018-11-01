//
//  CDTabBarController.m
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/21.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDTabBarController.h"
#import "CDMessageViewController.h"
#import "CDConferenceViewController.h"
#import "CDMoreViewController.h"
#import "CDContactsViewController.h"
#import "CDMeViewController.h"
#import "CDTabBar.h"
#import "CDSelectContactsViewController.h"
#import "CDInviteView.h"
#import "CDConnectedView.h"
#import "CWInfoRefreshDelegate.h"
#import "CDPopView.h"
#import "CWToastUtil.h"
#import "CDContactsManager.h"
#import "CWChooseContactController.h"
#import "CDWaitView.h"
#import "CDLoginViewController.h"

@interface CDTabBarController ()<CDTabBarDelegate,CWInfoRefreshDelegate,CWConferenceServiceDelegate,CWWhiteBoardServiceDelegate,PopViewDelegate,CDConnectedViewDelegate,CDSelectContactsDelegate,CWCallServiceDelegate>

/**
 未读数量
 */
@property (nonatomic,strong) UILabel *unReadLabel;
@end

@implementation CDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CDMessageViewController *message = [[CDMessageViewController alloc] init];
    [self addChildViewController:message title:@"消息" imageName:@"tab_msg_btn_unselected" seleceImageName:@"tab_msg_btn_selected"];

    CDConferenceViewController *confefence = [[CDConferenceViewController alloc] init];
    [self addChildViewController:confefence title:@"会议" imageName:@"tab_consert_btn_unselected" seleceImageName:@"tab_consert_btn_selected"];

//    CDMoreViewController *more = [[CDMoreViewController alloc] init];
//    [self addChildViewController:more title:@"more" imageName:@"tabbar_misc" seleceImageName:@"tabbar_misc_selected"];

    CDContactsViewController *contacts = [[CDContactsViewController alloc] init];
    [self addChildViewController:contacts title:@"联系人" imageName:@"tab_contact_btn_unselected" seleceImageName:@"tab_contact_btn_selected"];

    CDMeViewController *me = [[CDMeViewController alloc] init];
    [self addChildViewController:me title:@"我" imageName:@"tab_person_btn_unselected" seleceImageName:@"tab_person_btn_selected"];

    CDTabBar *tabBar = [[CDTabBar alloc] init];
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];

    [tabBar addSubview:self.unReadLabel];

    [self startCubeEngineLogin];

    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate),@protocol(CWWhiteBoardServiceDelegate),@protocol(CWCallServiceDelegate),@protocol(CWMessageServiceDelegate)]];
    [CDConnectedView shareInstance].delegate = self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (UILabel *)unReadLabel
{
    if (nil == _unReadLabel) {
        _unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4/2+15, 1, 18, 18)];
        _unReadLabel.layer.cornerRadius = 9;
        _unReadLabel.layer.masksToBounds = YES;
        _unReadLabel.textColor = KWhiteColor;
        _unReadLabel.backgroundColor = KRedColor;
        _unReadLabel.font = [UIFont systemFontOfSize:11];
        _unReadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unReadLabel;
}

- (void)addChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName
{
//    childVC.title = title;
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KBlackColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];

    //选中字体颜色
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KGrayColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

#pragma mark - CDTabBarDelegate
- (void)tabBarDidClickPlusButton:(CDTabBar *)tabBar
{
    CDPopView *popView = [[CDPopView alloc] initWithFrame:self.view.frame];
    popView.popDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    [popView showPop];
}

#pragma mark - CubeEngineLogin
- (void)startCubeEngineLogin{
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWInfoRefreshDelegate)]];
    
    NSDictionary *loginInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLogin"];
    NSString * cubeId = [loginInfoDic objectForKey:@"cubeId"];
    NSString * cubeToken = [loginInfoDic objectForKey:@"cubeToken"];
    
    CWUserModel *user = [CWUserModel userWithCubeId:cubeId andDiaplayName:@"" andAvatar:@""];
    [[CubeWare sharedSingleton].accountService loginUser:user withToken:cubeToken];
}

#pragma mark - CWInfoRefreshDelegate
- (void)changeCurrentUser:(CWUserModel *)user{
    if (user) {
        NSDictionary *loginInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLogin"];
        NSString * cubeId = [loginInfoDic objectForKey:@"cubeId"];
        NSString * cubeToken = [loginInfoDic objectForKey:@"cubeToken"];
        
        CDLoginAccountModel *loginModel = [[CDLoginAccountModel alloc] init];
        loginModel.cubeId = cubeId;
        loginModel.cubeToken = cubeToken;
        [CDShareInstance sharedSingleton].loginModel = loginModel;
        [self getContactData];
    }
    else{
        // ....logout
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentLogin"];
        dispatch_async(dispatch_get_main_queue(), ^{
            CDLoginViewController *loginVc = [[CDLoginViewController alloc] init];
            UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVc];
            [UIApplication sharedApplication].keyWindow.rootViewController = loginNav;
        });
    }
}

#pragma mark - CDPopViewDelegate
- (void)popView:(CDPopView *)popView didSelectedIndex:(NSInteger)selectedIndex
{
    NSUInteger index = self.selectedIndex;
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navC = (UINavigationController *)vc;
        if (selectedIndex == 0) {
            CWChooseContactController *chooseVc = [[CWChooseContactController alloc] initWithChooseContactType:ChooseContactTypeAll existMemberArray:nil andClickRightItemBlock:^(NSArray *selectedArray) {
                // 多人语音
                CubeConferenceConfig *config = [[CubeConferenceConfig alloc] initWithGroupType:CubeGroupType_Voice_Call withDisplayName:@""];
                NSMutableArray *invites = [NSMutableArray array];
                for (CubeGroupMember *member in selectedArray) {
                    [invites addObject:member.cubeId];
                }
                config.maxMember = 9;
                config.invites = invites; // 手动调用邀请...
                [[CubeEngine sharedSingleton].conferenceService createConferenceWithConfig:config];
            }];
            chooseVc.hidesBottomBarWhenPushed = YES;
            [navC pushViewController:chooseVc animated:YES];
        }
        else if(selectedIndex == 1)
        {
            CWChooseContactController *chooseVc = [[CWChooseContactController alloc] initWithChooseContactType:ChooseContactTypeAll existMemberArray:nil andClickRightItemBlock:^(NSArray *selectedArray) {
                // 多人白板
                
                CubeWhiteBoardConfig *config = [[CubeWhiteBoardConfig alloc] initWithGroupType:CubeGroupType_Share_WB withDisplayName:@""];
                config.maxNumber = 9;
                NSMutableArray *invites = [NSMutableArray array];
                for (CubeGroupMember *member in selectedArray) {
                    [invites addObject:member.cubeId];
                }
                config.invites = invites; // 手动邀请...
                [[CubeEngine sharedSingleton].whiteBoardService createWhiteBoardWithConfig:config];
            }];
            chooseVc.hidesBottomBarWhenPushed = YES;
            [navC pushViewController:chooseVc animated:YES];
        }
        else if(selectedIndex == 2)
        {
            [CWToastUtil showTextMessage:@"移动端无此功能" andDelay:1.0f];
        }
    }
}

#pragma mark - CDConnectedView
-(void)onClickAddMoreMembers:(CDConnectedView *)view{
    //弹出选择页面
    NSMutableArray *listArray = [NSMutableArray array];

    for (CDLoginAccountModel *model in [CDShareInstance sharedSingleton].friendList)
    {
        if (model.cubeId)
        {
             [listArray addObject:model];
        }
    }
    CDSelectContactsViewController *selectView = [[CDSelectContactsViewController alloc]init];
    selectView.hidesBottomBarWhenPushed = YES;
    selectView.dataArray = listArray;
    selectView.delegate = self;
    selectView.groupType = view.groupType;
    selectView.conference = view.conference;
    if ([view.groupType isEqualToString:CubeGroupType_Share_WB]) {
        selectView.whiteBoard = view.whiteBoard;
    }
    NSUInteger index = self.selectedIndex;
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navC = (UINavigationController *)vc;
        selectView.hidesBottomBarWhenPushed = YES;
        [navC pushViewController:selectView animated:YES];
        [CDConnectedView shareInstance].hidden = YES;
    }
}
#pragma mark - CDSelectContactsDelegate
- (void)compeleteInvite
{
    [CDConnectedView shareInstance].hidden = NO;
}
- (void)cancel
{
    [CDConnectedView shareInstance].hidden = NO;
}

#pragma mark - CubeConferenceServiceDelegate
- (void)inviteConference:(CubeConference *)conference andFrom:(CubeUser *)from andInvites:(NSArray *)invites
{
//    NSLog(@"conference invite ...");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![from.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
            CDInviteView *inviteView = [[CDInviteView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            inviteView.conference = conference;
            inviteView.invites = conference.invites;
            inviteView.from = from;
            [inviteView showView];
        }
        else
        {
            [CDConnectedView shareInstance].hidden = NO;
        }
    });
}


- (void)connectedConference:(CubeConference *)conference andView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        CDConnectedView *connectedView = [CDConnectedView shareInstance];
        [connectedView.showView addSubview:view];
        connectedView.conference = conference;
        [connectedView show];
    });
}

-(void)conferenceFail:(CubeConference *)conference andError:(CubeError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
       [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
    });
}


#pragma mark - CWWhiteBoardServiceDelegate
-(void)whiteBoardCreate:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser andView:(UIView *)view{
//    NSLog(@"create whiteboard ...");
    NSMutableArray *inviteCubeIds = [NSMutableArray array];
    for (CubeUser *invite in whiteBoard.invites) {
//        NSLog(@"invite : %@",invite.cubeId);
        [inviteCubeIds addObject:invite.cubeId];
    }
    
//    [CubeWare sharedSingleton].whiteBoardService inviteMemberInWhiteBoardId:whiteBoard.whiteboardId andMembers:<#(NSArray<NSString *> *)#>
    if ([fromUser.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CDConnectedView *connectedView = [CDConnectedView shareInstance];
            connectedView.whiteBoard = whiteBoard;
            [connectedView.whiteBoarView addSubview:view];
            [connectedView show];
            
            if (inviteCubeIds.count) {
                [[CubeWare sharedSingleton].whiteBoardService inviteMemberInWhiteBoardId:whiteBoard.whiteboardId andMembers:inviteCubeIds];
            }
        });
    }
}

-(void)whiteBoardQuit:(CubeWhiteBoard *)whiteBoard quitMember:(CubeUser *)quitMember{
//    NSLog(@"quit whiteBoard ...");
}

-(void)whiteBoardFailed:(CubeWhiteBoard *)whiteBoard error:(CubeError *)error{
//    NSLog(@"error info is %@",error);
}

-(void)whiteBoardInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser invites:(NSArray<CubeGroupMember *> *)invites{
//    NSLog(@"whiteBoard invite ...");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![fromUser.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
            
            CDInviteView *inviteView = [[CDInviteView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            inviteView.whiteBoard = whiteBoard;
            inviteView.invites = invites;
            inviteView.from = fromUser;
            [inviteView showView];
        }
        else{
            [CDConnectedView shareInstance].hidden = NO;
        }
    });
}

- (void)whiteBoardJoin:(CubeWhiteBoard *)whiteBoard joinedMember:(CubeUser *)joinedMember andView:(UIView *)view{
//    NSLog(@"whiteBoard join ...");
//    if ([joinedMember.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            CDConnectedView *connectedView = [CDConnectedView shareInstance];
//            connectedView.whiteBoard = whiteBoard;
//            [connectedView.showView addSubview:view];
//            [connectedView show];
//        });
//    }
}

#pragma mark - CWCallServiceDelegate
-(void)newCall:(CubeCallSession *)callSession from:(CubeUser *)from{
//    NSLog(@"new call");
    CubeCallSession *currentCallSession = [[CubeEngine sharedSingleton].mediaService currentCallWithCallType:CubeCallTypeCall].firstObject;
    if (currentCallSession) {
        [CWToastUtil showTextMessage:@"有其他通话邀请呼入,当前正在进行通话.." andDelay:1.f];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![from.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
            CDInviteView *inviteView = [[CDInviteView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            inviteView.callSession = callSession;
            inviteView.from = from;
            [inviteView showView];
        }
    });
}

-(void)callRing:(CubeCallSession *)callSession from:(CubeUser *)from{
    dispatch_async(dispatch_get_main_queue(), ^{
        CDWaitView *waitView = [[CDWaitView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        waitView.callSession = callSession;
        [waitView showView];
    });
}

-(void)callConnected:(CubeCallSession *)callSession from:(CubeUser *)from andRemoteView:(UIView *)remoteView andLocalView:(UIView *)localView{
    dispatch_async(dispatch_get_main_queue(), ^{
//        CDConnectedView *connectedView = [CDConnectedView shareInstance];
//        [connectedView.showView addSubview:view];
//        connectedView.callSession = callSession;
//        [connectedView show];
    });
}

-(void)callEnded:(CubeCallSession *)callSession from:(CubeUser *)from{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[CDConnectedView shareInstance] remove];
    });
}

-(void)callFailed:(CubeCallSession *)callSession error:(CubeError *)error from:(CubeUser *)from{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
    });
}


#pragma mark - Get data
- (void)getContactData
{
    [[CDContactsManager shareInstance] queryGroupList];
    [[CDContactsManager shareInstance] queryFriendList];
}

#pragma mark -
-(void)allUnreadCountChangeFrom:(NSInteger)oldAllUnreadCount to:(NSInteger)newAllUnreadCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(newAllUnreadCount == 0)
        {
            self.unReadLabel.hidden = YES;
        }
        else
        {
            self.unReadLabel.hidden = NO;
            if (newAllUnreadCount >=99) {
                self.unReadLabel.text = @"99";
            }
            else
            {
                self.unReadLabel.text = [NSString stringWithFormat:@"%ld",newAllUnreadCount];
            }
        }

    });
}

- (NSString *)getAvatorUrl:(NSString *)cubeId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cubeId=%@",cubeId];
    NSArray *array = [[CDShareInstance sharedSingleton].friendList filteredArrayUsingPredicate:predicate];
    CDLoginAccountModel *model = array.firstObject;
    return model.avatar;
}
@end
