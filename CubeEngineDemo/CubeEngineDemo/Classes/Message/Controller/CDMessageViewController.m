//
//  CDMessageViewController.m
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/21.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//
#import "CDSearchViewController.h"
#import "CDMessageViewController.h"
#import "CDSessionViewController.h"
#import "CDSelectContactsViewController.h"
#import "CDMenuView.h"
#import "CDConferenceManager.h"
#import "CDMessageHelper.h"
@interface CDMessageViewController ()<CDMenuViewDelegate,CDSelectContactsDelegate>

/**
 扩展菜单
 */
@property (nonatomic,strong) CDMenuView *menu;

/**
 标题
 */
@property (nonatomic,strong) UILabel *messageTitle;

/**
 分割线
 */
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;
@end

@implementation CDMessageViewController
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
    [CDMessageHelper instance];
    self.view.backgroundColor = KWhiteColor;
    self.navigationController.navigationBar.barTintColor = KWhiteColor;
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

     UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"btn_addMore_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMoreItem:)];
    self.navigationItem.rightBarButtonItem =  moreItem;
    [self.view addSubview:self.messageTitle];
    [self.sessionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageTitle.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate),@protocol(CWGroupServiceDelegate)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self queryConference];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (CDMenuView *)menu
{
//    NSArray *icons = @[@"talk",@"cabinet"];
    NSArray *titles = @[@"加入群",@"创建群"];

    if (nil == _menu)
    {
        _menu = [[CDMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withTitle:titles withIcons:nil];
        _menu.delegate = self;
    }
    return _menu;
}

- (UILabel *)messageTitle
{
    if(nil == _messageTitle)
    {
        _messageTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, SafeAreaTopHeight, kScreenWidth, 50)];
        _messageTitle.text = @"消息";
        _messageTitle.font = [UIFont boldSystemFontOfSize:32];
        _messageTitle.textColor = KBlackColor;
        _messageTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _messageTitle;
}

- (void)onClickMoreItem:(UIButton *)button
{
    [self.menu showMenuView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	CDSessionViewController *sessionVC = [[CDSessionViewController alloc] initWithSession:self.sessionArray[indexPath.row]];
	sessionVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:sessionVC animated:YES];
}

#pragma mark - CDMenuViewDelegate
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CDSearchViewController *searchView = [[CDSearchViewController alloc]init];
        searchView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchView animated:YES];
    }
    else if (indexPath.row == 1)
    {
        CDSelectContactsViewController *selectView = [[CDSelectContactsViewController alloc]init];
        selectView.hidesBottomBarWhenPushed = YES;
        selectView.dataArray = [CDShareInstance sharedSingleton].friendList;
        selectView.delegate = self;
        selectView.groupType = CubeGroupType_Normal;
        [self.navigationController pushViewController:selectView animated:YES];
    }
}

- (void)gotoSessionViewController:(CubeGroup *)group
{
    CDSessionViewController *sessionView = [[CDSessionViewController alloc]initWithSession:[[CWSession alloc] initWithSessionId:group.groupId andType:CWSessionTypeGroup]];
    sessionView.hidesBottomBarWhenPushed = YES;
    sessionView.title = group.displayName;
    [self.navigationController pushViewController:sessionView animated:YES];
}

- (void)queryConference
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sessionType == %d",CWSessionTypeGroup];
    NSArray *result = [self.sessionArray filteredArrayUsingPredicate:predicate];
    if (result && result.count > 0 )
    {
        NSMutableArray *groupIds = [NSMutableArray array];
        for (CWSession *session in result) {
            [groupIds addObject:session.sessionId];
        }
        [[CDConferenceManager shareInstance] queryConferencesWithGroupIds:groupIds completion:^(NSArray *conferences) {
            //显示正在进行中的会议
            [super updateSessionList:conferences];
        } failure:^(CubeError *error) {
            
        }];
    }
}

#pragma mark - CWGroupServiceDelegate
- (void)updateGroup:(CubeGroup *)group from:(CubeUser *)from
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sessionId == %@",group.groupId];
        NSArray *result = [self.sessionArray filteredArrayUsingPredicate:predicate];
        if (result && result.count > 0 )
        {
            CWSession *session = result.firstObject;
            session.sessionName = group.displayName;
        }
         [self.sessionList reloadData];
    });
}
@end
