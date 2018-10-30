//
//  CDGroupInfoViewController.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDGroupInfoViewController.h"
#import "CDGroupInfoTableView.h"
#import "CDEditGroupInfoViewController.h"
#import "CDSessionViewController.h"
#import "CDSelectContactsViewController.h"
#import "CWActionSheet.h"
#import "CDHudUtil.h"
#import "CDAvatarViewController.h"
@interface CDGroupInfoViewController ()<CDGroupInfoDelegate,CWGroupServiceDelegate,CWActionSheetDelegate>

/**
 群信息列表
 */
@property (nonatomic,strong) CDGroupInfoTableView *infoTableView;

/**
 是否为群主
 */
@property (nonatomic,assign) BOOL isMaster;

/**
 群组
 */
@property (nonatomic,strong) CubeGroup *group;

/**
 分割线
 */
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;
/**
 发送消息
 */
@property (nonatomic,strong) UIButton *sendButton;
@end

@implementation CDGroupInfoViewController
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
    self.title = @"";

    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

     UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMoreItem:)];
    self.navigationItem.rightBarButtonItem =  moreItem;
    self.navigationItem.leftBarButtonItem = backItem;

    [self.view addSubview:self.infoTableView];
    [self.view addSubview:self.sendButton];
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWGroupServiceDelegate)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CDGroupInfoTableView *)infoTableView
{
    if (nil == _infoTableView)
    {
        _infoTableView = [[CDGroupInfoTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight )];
        _infoTableView.infoDelegate = self;
    }
    return _infoTableView;
}

- (void)setGroupId:(NSString *)groupId
{
    _groupId = groupId;
    __block CubeGroup *blockGroup = [[CubeGroup alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil showDefultHud];
    });
    [[CubeEngine sharedSingleton].groupService queryGroupDetails:@[groupId] andBlock:^(NSArray<CubeGroup *> *groups) {
        blockGroup = groups.firstObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [CDHudUtil hideDefultHud];
            self.group = blockGroup;
            self.infoTableView.group = blockGroup;
        });
    }];
}

- (BOOL)isMaster
{
    NSString * owner = self.group.owner;
    if ([owner isEqualToString:[CubeEngine sharedSingleton].userService.currentUser.cubeId]) {
        return YES;
    }
    return NO;
}

- (UIButton *)sendButton
{
    if(nil == _sendButton)
    {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setFrame:CGRectMake(0, self.view.frame.size.height - 43 - SafeAreaBottomHeight, kScreenWidth, 43)];
        [_sendButton setBackgroundColor:RGBA(0x43 , 0x93, 0xF9, 1)];
        [_sendButton setTitle:@"发消息" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sendButton addTarget:self action:@selector(onClickChatButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void)onClickChatButton
{
    CDSessionViewController *sessionView = [[CDSessionViewController alloc] initWithSession:[[CWSession alloc] initWithSessionId:self.group.groupId andType:CWSessionTypeGroup]];
    [self.navigationController pushViewController:sessionView animated:YES];
}

#pragma mark -
- (void)editGroupName:(CubeGroup *)group
{
    if (self.isMaster)
    {
        CDEditGroupInfoViewController *editView = [[CDEditGroupInfoViewController alloc]init];
        editView.group = self.group;
        [self.navigationController pushViewController:editView animated:YES];
    }
}
- (void)addGroupMember:(CubeGroup *)group
{
    
    CDSelectContactsViewController *selectView = [[CDSelectContactsViewController alloc]init];
    selectView.dataArray = [CDShareInstance sharedSingleton].friendList;
    selectView.groupType = CubeGroupType_Normal;
    selectView.group = self.group;
    [self.navigationController pushViewController:selectView animated:YES];
}

#pragma mark - events
- (void)onClickMoreItem:(UIButton *)button
{
    NSArray *buttonTitles = [NSArray array];
    NSInteger redIndex = 0;
    if (self.isMaster)
    {
        buttonTitles = @[@"解散该群",@"退出该群"];
        redIndex = 1;
    }
    else
    {
        buttonTitles = @[@"退出该群"];
    }
    CWActionSheet *sheet = [CWActionSheet sheetWithTitle:nil buttonTitles:buttonTitles redButtonIndex:redIndex delegate:self];
    [sheet show];
}

- (void)onClickBackItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (void)destroyGroup:(CubeGroup *)group from:(CubeUser *)from
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil hideDefultHud];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)quitGroup:(CubeGroup *)group from:(CubeUser *)from
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil hideDefultHud];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}
#pragma mark -
- (void)updateGroup:(CubeGroup *)group from:(CubeUser *)from
{
    //修改成功
    self.group = group;
    self.infoTableView.group = group;
}

- (void)actionSheet:(CWActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.isMaster)
    {
        if (buttonIndex == 0) {
            [CDHudUtil showDefultHud];
            [[CubeEngine sharedSingleton].groupService destroyGroupWithGroupId:self.group.groupId];
        }
        else if(buttonIndex == 1)
        {
            [CDHudUtil showDefultHud];
            [[CubeEngine sharedSingleton].groupService quitGroupWithGroupId:self.group.groupId];
        }
    }
    else
    {
        if (buttonIndex == 0) {
            [CDHudUtil showDefultHud];
            [[CubeEngine sharedSingleton].groupService quitGroupWithGroupId:self.group.groupId];
        }
    }
}

- (void)showAvator:(CubeGroup *)group
{
    CDAvatarViewController *view = [[CDAvatarViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    view.group = self.group;
    [self.navigationController presentViewController:view animated:YES completion:^{

    }];
}

@end
