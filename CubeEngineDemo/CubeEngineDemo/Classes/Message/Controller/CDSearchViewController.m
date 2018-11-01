//
//  CWSearchViewController.m
//  CubeWare
//
//  Created by pretty on 2018/8/25.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDSearchViewController.h"
#import "CDSearchField.h"
#import "CWToastUtil.h"
#import "CDContactsManager.h"
#import "CDSearchTableViewCell.h"
@interface CDSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CDSearchFieldDelegate>

/**
 搜索框
 */
@property (nonatomic,strong) CDSearchField *searchField;

/**
 列表
 */
@property (nonatomic,strong) NSArray *listArray;

/**
 表
 */
@property (nonatomic,strong) UITableView *listTableView;

/**
 分割线
 */
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;

@end

@implementation CDSearchViewController

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
    self.title = @"找群";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;

    [self.view addSubview:self.searchField];
    [self.view addSubview:self.listTableView];

    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchField.mas_bottom).offset(10);
        make.width.mas_equalTo(@(kScreenWidth));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(self.view.mas_height).offset(-self.searchField.height);
    }];
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

- (UITableView *)listTableView
{
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _listTableView;
}

- (CDSearchField *)searchField
{
    if (nil == _searchField)
    {
        _searchField = [[CDSearchField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 18*2, 30)];
        _searchField.centerX = self.view.centerX;
        _searchField.centerY = 100;
        _searchField.delegate = self;
    }
    return _searchField;
}
#pragma mark -events
- (void)onClickBackItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CDSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CDSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    CubeGroup *group = [self.listArray objectAtIndex:indexPath.row];
    cell.isJoined = [self isJoined:group];
    cell.group = group;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CubeGroup *group = [self.listArray objectAtIndex:indexPath.row];
    BOOL ret = [[CubeWare sharedSingleton].groupService applyJoinGroupWithGroupId:group.groupId];
    if(ret)
    {
        [CWToastUtil showTextMessage:@"发送申请成功" andDelay:1];
    }
}

#pragma mark - privite method
- (void)searchText:(NSString *)text
{
    NSString *searchText = text;
    [[CubeEngine sharedSingleton].groupService queryGroupDetails:@[searchText] andBlock:^(NSArray<CubeGroup *> *groups) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listArray = groups;
            [self.listTableView reloadData];
        });
    }];
}

- (BOOL)isJoined:(CubeGroup *)group
{
    if([[CDContactsManager shareInstance] getGroupInfo:group.groupId])
    {
        return YES;
    }
    return NO;
}
@end
