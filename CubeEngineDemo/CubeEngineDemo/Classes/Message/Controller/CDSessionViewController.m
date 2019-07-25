//
//  CDSessionViewController.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDSessionViewController.h"
#import "CDGroupInfoViewController.h"
#import "CDUserInfoViewController.h"
#import "CDGroupTipView.h"
#import "CDConferenceManager.h"
#import "CDJoinView.h"
#import "CDContactsManager.h"
@interface CDSessionViewController ()<CDGroupTipViewDelegate,CWConferenceServiceDelegate>
/**
 群组提示框
 */
@property (nonatomic,strong) CDGroupTipView *tipView;

/**
 会议
 */
@property (nonatomic,strong) CubeConference *conference;

/**
 分割线
 */
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;
@end

@implementation CDSessionViewController
// 隐藏导航栏分割线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    NSString *imageName;

    if (self.session.sessionType == CWSessionTypeGroup)
    {
        imageName = @"groupicon.png";
        CubeGroup *model = [[CDContactsManager shareInstance] getGroupInfo:self.session.sessionId];
        if(model)
        {
            self.title = model.displayName;
        }
    }
    else
    {
        imageName = @"usericon.png";
        CDLoginAccountModel *model = [[CDContactsManager shareInstance]getFriendInfo:self.session.sessionId];
        if (model) {
            self.title = model.displayName;
        }
    }
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMoreItem:)];
    self.navigationItem.rightBarButtonItem =  moreItem;
    self.navigationItem.leftBarButtonItem = backItem;
    
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate),@protocol(CWGroupServiceDelegate)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
//    [self setUI];
    [self showTipView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止一切媒体播放
    [[CubeEngine sharedSingleton].mediaService stopCurrentPlay];
}

- (void)setUI
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bindGroupId == %@",self.session.sessionId];
    NSArray *result = [[CDConferenceManager shareInstance].conferenceList filteredArrayUsingPredicate:predicate];
    if (result && result.count > 0)
    {
        CubeGroup *group = result.firstObject;
        TipShowType showtype;
        if (group.type == CubeGroupType_Voice_Conference) {
            showtype = TipShowVoiceConferece;
            self.conference = result.firstObject;
        }
        else if (group.type ==CubeGroupType_Video_Conference)
        {
            showtype = TipShowVideoConference;
            self.conference = result.firstObject;
        }
        else if (group.type ==CubeGroupType_Share_Desktop_Conference)
        {
            showtype = TipShowShareDesktop;
            self.conference = result.firstObject;
        }
        else
        {
            showtype = TipShowWhiteBoard;
        }
        self.tipView = [[CDGroupTipView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreenWidth, 44) andShowType:showtype];
        self.tipView.memberCount = group.members.count;
        self.tipView.delegate = self;
        [self.view addSubview:self.tipView];
    }
}


- (void)showTipView{
    [[CubeEngine sharedSingleton].conferenceService queryConferenceWithConferenceType:(CubeGroupType_Voice_Call | CubeGroupType_Video_Call | CubeGroupType_Share_Desktop_Conference) groupIds:@[self.session.sessionId] completion:^(NSArray *conferences) {
        if (conferences && conferences.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CubeConference *conference = conferences.firstObject;
                if(conference && conference.members.count != 0)
                {
                    TipShowType showtype;
                    if (conference.type == CubeGroupType_Voice_Call) {
                        showtype = TipShowVoiceConferece;
                        self.conference = conference;
                    }
                    else if (conference.type == CubeGroupType_Video_Call)
                    {
                        showtype = TipShowVideoConference;
                        self.conference = conference;
                    }
                    else if (conference.type == CubeGroupType_Share_Desktop_Conference)
                    {
                        showtype = TipShowShareDesktop;
                        self.conference = conference;
                    }
                    else
                    {
                        showtype = TipShowWhiteBoard;
                    }
                    self.tipView = [[CDGroupTipView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreenWidth, 44) andShowType:showtype];
                    self.tipView.memberCount = conference.members.count;
                    self.tipView.delegate = self;
                    [self.view addSubview:self.tipView];
                }
            });
        }
    } failure:^(CubeError *error) {
//        NSLog(@"error : %@",error);
    }];
}

#pragma mark - events
- (void)onClickMoreItem:(UIButton *)button
{
    //进入群组详情
    if(self.session.sessionType  == CWSessionTypeGroup)
    {
        CDGroupInfoViewController *groupInfoView = [[CDGroupInfoViewController alloc]init];
        groupInfoView.groupId = self.session.sessionId;
        [self.navigationController pushViewController:groupInfoView animated:YES];
    }
    else if(self.session.sessionType == CWSessionTypeP2P)
    {
        CDUserInfoViewController *userInfoView = [[CDUserInfoViewController alloc]init];
		CDLoginAccountModel *model = [[CDLoginAccountModel alloc] init];
		model.cubeId = self.session.sessionId;
        userInfoView.user = model;
        [self.navigationController pushViewController:userInfoView animated:YES];
    }
}

- (void)onClickBackItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -CDGroupTipViewDelegate
- (void)onTapTipView
{
    //弹出加入页面
    CDJoinView *joinView = [[CDJoinView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    joinView.conference = self.conference;
    [joinView showView];
}

#pragma mark - CWConferenceServiceDelegate
-(void)destroyConference:(CubeConference *)conference byUser:(CubeUser *)user{
    if ([conference.groupId isEqualToString:self.conference.groupId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tipView removeFromSuperview];
            self.conference = nil;
        });
    }
}

- (void)updateGroup:(CubeGroup *)group from:(CubeUser *)from
{
    if ([group.groupId isEqualToString:self.session.sessionId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = group.displayName;
        });
    }
}

@end
