//
//  CWSelectContactsViewController.m
//  CubeWare
//  选择联系人
//  Created by pretty on 2018/8/25.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDSelectContactsViewController.h"
#import "CDSelectTableView.h"
#import "CDSessionViewController.h"
#import "CDCreateConferenceViewController.h"
#import "CWToastUtil.h"
#import "CDContactsManager.h"
#import "CDHudUtil.h"
@interface CDSelectContactsViewController ()<CDSelectTableViewDelegate,CWGroupServiceDelegate,CWConferenceServiceDelegate,CWWhiteBoardServiceDelegate>

/**
 列表
 */
@property (nonatomic,strong) CDSelectTableView *listView;

/**
 分割线
 */
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;

/**
 按钮标题
 */
@property (nonatomic,strong) NSString *sureTitle;

/**
 不可选列表
 */
@property (nonatomic,strong) NSMutableArray * noChooseList;

@end

@implementation CDSelectContactsViewController
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
    self.title = @"选择联系人";

    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

    UIBarButtonItem *cancekItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    UIBarButtonItem *sureItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onClickSure:)];
    [cancekItem setTintColor:KBlackColor];

    self.navigationItem.rightBarButtonItem =  sureItem;
    self.navigationItem.leftBarButtonItem = cancekItem;

    [self.view addSubview:self.listView];

    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWGroupServiceDelegate),@protocol(CWConferenceServiceDelegate),@protocol(CWWhiteBoardServiceDelegate)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.listView.noChooseList = self.noChooseList;
        self.listView.listArray = self.dataArray;
        [self.listView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navBarHairlineImageView.hidden = NO;
}

- (CDSelectTableView *)listView
{
    if (_listView == nil) {
        _listView = [[CDSelectTableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 10, self.view.width, (self.view.height - SafeAreaTopHeight-10))];
        _listView.selectDelegate = self;
    }
    return _listView;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
}

- (void)setGroup:(CubeGroup *)group
{
    _group = group;
    self.noChooseList = [NSMutableArray array];
    for (CubeGroupMember *member in group.members) {
        [self.noChooseList addObject:member.cubeId];
    }
    for (CubeGroupMember *master in group.masters) {
        [self.noChooseList addObject:master.cubeId];
    }
}

-(void)setConference:(CubeConference *)conference
{
    _conference = conference;
    self.noChooseList = [NSMutableArray array];
    for (CubeGroupMember *member in conference.members) {
        [self.noChooseList addObject:member.cubeId];
    }
    for (CubeGroupMember *master in conference.masters) {
        [self.noChooseList addObject:master.cubeId];
    }
}

#pragma mark -events
- (void)onClickSure:(UIButton *)button
{
    if ([self.groupType isEqualToString:CubeGroupType_Normal])
    {
        if(self.group == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CDHudUtil showDefultHud];
            });
          NSString *displayName = [CubeEngine sharedSingleton].userService.currentUser.displayName;
            CubeGroupConfig *config = [[CubeGroupConfig alloc]initWithGroupType:self.groupType withDisplayName:[NSString stringWithFormat:@"%@创建的群",displayName?displayName:[CDShareInstance sharedSingleton].loginModel.cubeId]];
            config.members = self.listView.selectedArray;
            if ([[CubeWare sharedSingleton].groupService createGroupWithGroup:config])
            {
            }
            else
            {
            }
        }
        else
        {

            if ([self.group.owner isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId])
            {
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:self.listView.selectedArray];
                if([[CubeWare sharedSingleton].groupService  addMembersWithGroupId:self.group.groupId withMembers:array])
                {

                }
                else
                {}
            }
            else
            {
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:self.listView.selectedArray];
                if([[CubeWare sharedSingleton].groupService  inviteMembersWithGroupId:self.group.groupId withMembers:array])
                {

                }
                else
                {}
            }
        }
    }
    else if([self.groupType isEqualToString:CubeGroupType_Voice_Conference])
    {
        //创建音频会议
        CDCreateConferenceViewController *createView = [[CDCreateConferenceViewController alloc]init];
        [self.navigationController pushViewController:createView animated:YES];
    }
    else if ([self.groupType isEqualToString:CubeGroupType_Share_WB]){
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:self.listView.selectedArray];
        [[CubeWare sharedSingleton].whiteBoardService inviteMemberInWhiteBoardId:self.whiteBoard.whiteboardId andMembers:array];
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:self.listView.selectedArray];
        [[CubeWare sharedSingleton].conferenceService inviteConference:self.conference andInvites:array];
    }
}

- (void)onClickBackItem:(UIButton *)button
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cancel)])
    {
        [self.delegate cancel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CWGroupServiceDelegate
- (void)createGroup:(CubeGroup *)group from:(CubeUser *)from
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil hideDefultHud];
    });
    if ([from.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId])
    {   //由我创建的
#warning fixed me
//        [[CDContactsManager shareInstance]getGroupList];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *viewControllers = self.navigationController.viewControllers;
            if ([viewControllers.lastObject isKindOfClass:[self class]]) {
                [self.navigationController popViewControllerAnimated:NO];
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(gotoSessionViewController:)])
            {
                [self.delegate gotoSessionViewController:group];
            }
        });
    }
    else
    {

    }
}

- (void)groupFail:(CubeError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil hideDefultHud];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
    });
}

- (void)destroyGroup:(CubeGroup *)group from:(CubeUser *)from
{
    //销毁群组
    dispatch_async(dispatch_get_main_queue(), ^{
#warning wait to do
//        [CWToastUtil showTextMessage:@"群组销毁" andDelay:1.0f];
    });
}

- (void)addMembersGroup:(CubeGroup *)group from:(CubeUser *)from Member:(NSArray *)member
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CWToastUtil showTextMessage:@"添加成功" andDelay:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)inviteMembersGroup:(CubeGroup *)group from:(CubeUser *)from Member:(NSArray *)member
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CWToastUtil showTextMessage:@"邀请成功" andDelay:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - CWConferenceServiceDelegate
- (void)inviteConference:(CubeConference *)conference andFrom:(CubeUser *)from andInvites:(NSArray *)invites
{
    if ([from.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

#pragma mark - CWWhiteBoardServiceDelegate
- (void)whiteBoardInvite:(CubeWhiteBoard *)whiteBoard from:(CubeUser *)fromUser invites:(NSArray<CubeGroupMember *> *)invites{
    if ([fromUser.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)updateSelectList:(NSInteger)count
{
    if(count != 0)
    {
        _sureTitle = [NSString stringWithFormat:@"确定(%ld)",(long)count];
    }
    else
    {
        _sureTitle = @"确定";
    }
    [self.navigationItem.rightBarButtonItem setTitle:_sureTitle];
}

@end
