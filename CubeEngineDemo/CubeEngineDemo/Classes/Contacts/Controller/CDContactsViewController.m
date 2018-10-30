//
//  CWContactsViewController.m
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/21.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDContactsViewController.h"
#import "CDMenuView.h"
#import "CDContactsListTableView.h"
#import <CubeEngineFoundationKit/CubeEngineFoundationKit.h>
#import "CubeWare.h"
#import "CDSessionViewController.h"
#import "CDSegmentView.h"
#import "CDLoginAccountModel.h"
#import "CDUserInfoViewController.h"
#import "CDSelectContactsViewController.h"
#import "CDContactsManager.h"
@interface CDContactsViewController ()<CDMenuViewDelegate,CDContactsListTableViewDelegate,CubeGroupServiceDelegate,CDSegmentViewDelegate,UIScrollViewDelegate,CDSelectContactsDelegate>
/**
 扩展菜单
 */
@property (nonatomic,strong) CDMenuView *menu;

/**
 可左右滚动背景view
 */
@property (nonatomic,strong) UIScrollView *scrollView;

/**
 好友列表
 */
@property (nonatomic,strong) CDContactsListTableView *friendListView;

/**
 群组列表
 */
@property (nonatomic,strong) CDContactsListTableView *groupListView;

/**
 选择tab
 */
@property (nonatomic,strong)  CDSegmentView *segment;

/**
 总条数
 */
@property (nonatomic,assign) NSInteger total;

/**
 当前页数
 */
@property (nonatomic,assign) NSInteger page;

/**
 群组数据
 */
@property (nonatomic,strong) NSMutableArray *groupArray;

/**
 标题
 */
@property (nonatomic,strong) UILabel *contactsTitle;


@property (nonatomic,strong) UIImageView *navBarHairlineImageView;

@end

@implementation CDContactsViewController


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
    self.view.backgroundColor = KWhiteColor;
    self.navigationController.navigationBar.barTintColor = KWhiteColor;

    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
     
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"btn_addMore_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMoreItem:)];
    self.navigationItem.rightBarButtonItem =  moreItem;
    [self setConfig];
    [self.view addSubview:self.contactsTitle];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.friendListView];
    [self.scrollView addSubview:self.groupListView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
    [self setData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.segment.segIndex = 0;
}

- (void)setConfig
{
    self.total = 0;
    self.page = 0;
    self.groupArray = [NSMutableArray arrayWithCapacity:1];
}

- (void)setData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getGroupList];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getFriendList];
    });
}

- (void)getGroupList
{
    if ([CDContactsManager shareInstance].grouplist) {
        self.groupArray = [NSMutableArray array];
        [self.groupArray addObjectsFromArray:[CDContactsManager shareInstance].grouplist];
        dispatch_async(dispatch_get_main_queue(), ^{
        self.groupListView.dataArray = [CDContactsManager shareInstance].grouplist;
        });
    }

    [[CubeEngine sharedSingleton].groupService queryGroups:self.page andCount:100 andBlock:^(CubeGroupQuery *groupQuery) {
        self.total = groupQuery.page.total;
        self.groupArray = [NSMutableArray array];
        [self.groupArray addObjectsFromArray:groupQuery.groups];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groupListView.dataArray = self.groupArray;
        });
    }];
}

- (void)getFriendList
{
    if([CDShareInstance sharedSingleton].friendList)//如果本地有数据，先使用本地数据
    {
        self.friendListView.dataArray = [CDShareInstance sharedSingleton].friendList;
    }
    
    NSDictionary *loginInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLogin"];
    NSString *appId = [loginInfoDic objectForKey:@"appId"];
    NSString *cubeId = [loginInfoDic objectForKey:@"cubeId"];
    NSString *queryCubeIdByAppId = [NSString stringWithFormat:@"%@%@",CDServiceHost,QueryCubeIdListByAppId];
    NSDictionary *params = @{
                             @"appId":appId,
                             @"page":@(0),
                             @"rows":@(100)
                             };

    [[AFHTTPSessionManager manager] POST:queryCubeIdByAppId parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *accountList = responseObject[@"data"][@"list"];
            NSMutableArray *accountModelList = [NSMutableArray array];
            for (NSDictionary *dic in accountList) {
                CDLoginAccountModel *model = [CDLoginAccountModel fromDictionary:dic];
                if (![model.cubeId isEqualToString:cubeId]) {
                    [accountModelList addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.friendListView.dataArray = accountModelList;
                [CDShareInstance sharedSingleton].friendList = accountModelList;
            });
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

- (UILabel *)contactsTitle
{
    if(nil == _contactsTitle)
    {
        _contactsTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, SafeAreaTopHeight, kScreenWidth, 50)];
        _contactsTitle.text = @"联系人";
        _contactsTitle.font = [UIFont boldSystemFontOfSize:32];
        _contactsTitle.textColor = KBlackColor;
        _contactsTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _contactsTitle;
}

- (UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 50 + 44 + 5, self.view.frame.size.width, self.view.frame.size.height)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}
- (CDMenuView *)menu
{
    NSArray *titles = @[@"创建群",@"加好友"];
    if (nil == _menu)
    {
        _menu = [[CDMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withTitle:titles withIcons:nil];
        _menu.delegate = self;
    }
    return _menu;
}

- (CDSegmentView *)segment
{
    if (nil == _segment)
    {
        _segment = [[CDSegmentView alloc]initWithFrame:CGRectMake(18, SafeAreaTopHeight + 50 , kScreenWidth - 18*2 , 44)];
        _segment.titles = @[@"好友", @"群组"];
        _segment.segmentDelegate = self;
        _segment.segIndex = 0;
    }
    return _segment;
}

- (CDContactsListTableView *)groupListView
{
    if(nil == _groupListView)
    {
        _groupListView = [[CDContactsListTableView alloc]initWithFrame:CGRectMake(kScreenWidth,0, kScreenWidth, kScreenHeight - (SafeAreaTopHeight + 50 + 44 + 5)-SafeAreaBottomHeight-49)];
        _groupListView.listDelegate = self;
        _groupListView.type = Contacts_Group;
    }
    return _groupListView;
}

- (CDContactsListTableView *)friendListView
{
    if (nil == _friendListView)
    {
        _friendListView = [[CDContactsListTableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - (SafeAreaTopHeight + 50 + 44 + 5) -SafeAreaBottomHeight - 49)];
        _friendListView.listDelegate = self;
        _friendListView.type = Contacts_Friend;
    }
    return _friendListView;
}

#pragma mark - events
- (void)onClickMoreItem:(UIButton *)button
{
    [self.menu showMenuView];
}
#pragma mark -CDSegmentTableViewDelegate
- (void)didSelectedIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * index , 0) animated:YES];
}

#pragma mark - CDMenuViewDelegate
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CDSelectContactsViewController *selectView = [[CDSelectContactsViewController alloc]init];
        selectView.hidesBottomBarWhenPushed = YES;
        selectView.dataArray = [CDShareInstance sharedSingleton].friendList;
        selectView.delegate = self;
        selectView.groupType = CubeGroupType_Normal;
        [self.navigationController pushViewController:selectView animated:YES];
    }
    else if (indexPath.row == 1)
    {
        
    }
}

#pragma mark -
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath withListTableView:(CDContactsListTableView *)listView
{
    if (listView == self.friendListView)
    {
        CDLoginAccountModel *userModel = [listView.dataArray objectAtIndex:indexPath.row];
        CDUserInfoViewController *user = [[CDUserInfoViewController alloc]init];
        user.hidesBottomBarWhenPushed = YES;
        user.user = userModel;
        [self.navigationController pushViewController:user animated:YES];
    }
    else if (listView == self.groupListView)
    {
        CubeGroup *group = [listView.dataArray objectAtIndex:indexPath.row];
        CDSessionViewController *sessionView = [[CDSessionViewController alloc]initWithSession:[[CWSession alloc] initWithSessionId:group.groupId andType:CWSessionTypeGroup]];
        sessionView.hidesBottomBarWhenPushed = YES;
        sessionView.title = group.displayName;
        [self.navigationController pushViewController:sessionView animated:YES];
    }
}

#pragma mark - 
- (void)gotoSessionViewController:(CubeGroup *)group
{
    CDSessionViewController *sessionView = [[CDSessionViewController alloc]initWithSession:[[CWSession alloc] initWithSessionId:group.groupId andType:CWSessionTypeGroup]];
    sessionView.hidesBottomBarWhenPushed = YES;
    sessionView.title = group.displayName;
    [self.navigationController pushViewController:sessionView animated:YES];
}

@end
