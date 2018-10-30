//
//  CWChooseContactController.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/27.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWChooseContactController.h"
#import "CWChooseContactCell.h"
#import "CWColorUtil.h"
#import "CubeWareHeader.h"
#import "CWToastUtil.h"
@interface CWChooseContactController () <UITableViewDataSource,UITableViewDelegate>

// userInterface
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIBarButtonItem  *leftNavItem;
@property(nonatomic,strong)UIBarButtonItem  *rightNavItem;

// dataSource
@property (nonatomic,strong) NSMutableArray *groupMembersArray;
@property (nonatomic,strong) NSMutableArray *membersArray;

// selected set s
@property (nonatomic,strong) NSMutableArray *selectedArray;

@property (nonatomic,strong) NSArray *existSelected;

@property (nonatomic,copy) rightItemBlock rightItemBlock;

@end

@implementation CWChooseContactController

- (instancetype)initWithChooseContactType:(ChooseContactType )type
                         existMemberArray:(NSArray *)existMembers
                   andClickRightItemBlock:(void(^)(NSArray *selectedArray))block{
    
    if (self = [super init]) {
        self.chooseContactType = type;
        self.rightItemBlock = block;
        self.existSelected = existMembers;
    }
    return self;
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = self.rightNavItem;
    self.navigationItem.leftBarButtonItem = self.leftNavItem;
    self.navigationItem.title = @"选择成员";
    self.selectedArray = [NSMutableArray array];
    if (self.chooseContactType == ChooseContactTypeAll) {
        [self getFriendList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setGroupId:(NSString *)groupId{
    _groupId = groupId;
    __block CubeGroup *blockGroup = [[CubeGroup alloc]init];
    [CWToastUtil showDefultHud];
    [[CubeEngine sharedSingleton].groupService queryGroupDetails:@[groupId] andBlock:^(NSArray<CubeGroup *> *groups) {
        
        blockGroup = groups.firstObject;
        
        NSString *currentLoginCubeId = [CubeEngine sharedSingleton].userService.currentUser.cubeId;
        NSMutableArray *allMembers = [NSMutableArray array];
        [allMembers addObjectsFromArray:blockGroup.members];
        [allMembers addObjectsFromArray:blockGroup.masters];
        
        NSMutableArray *allExceptSelf = [NSMutableArray array];
        for (CubeGroupMember *member in allMembers) {
            if (![member.cubeId isEqualToString:currentLoginCubeId]) {
                [allExceptSelf addObject:member];
            }
            for (CubeUser *selectUser in self.existSelected) {
                if ([selectUser.cubeId isEqualToString:member.cubeId]) {
                    [self.selectedArray addObject:member];
                }
            }
        }
        self.groupMembersArray = allExceptSelf;
//        self.rightNavItem.enabled = self.selectedArray.count;
        dispatch_async(dispatch_get_main_queue(), ^{
            [CWToastUtil hideDefultHud];
            [self.tableView reloadData];
        });
    }];
}

- (void)getFriendList
{
    NSDictionary *loginInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLogin"];
    NSString *appId = [loginInfoDic objectForKey:@"appId"];
    NSString *cubeId = [loginInfoDic objectForKey:@"cubeId"];
    NSString *queryCubeIdByAppId = [NSString stringWithFormat:@"%@%@",CDServiceHost,QueryCubeIdListByAppId];
    NSDictionary *params = @{
                             @"appId":appId,
                             @"page":@(0),
                             @"rows":@(100)
                             };
    [CWToastUtil showDefultHud];
    [[AFHTTPSessionManager manager] POST:queryCubeIdByAppId parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success with %@",responseObject);
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *accountList = responseObject[@"data"][@"list"];
            NSMutableArray *accountModelList = [NSMutableArray array];
            for (NSDictionary *dic in accountList) {
                CubeUser *user = [CubeUser fromDictionary:dic];
                user.cubeId = [NSString stringWithFormat:@"%@",user.cubeId];
                if (![user.cubeId isEqualToString:cubeId]) {
                    [accountModelList addObject:user];
                }
                for (CubeUser *selectUser in self.existSelected) {
                    if ([selectUser.cubeId isEqualToString:user.cubeId]) {
                        [self.selectedArray addObject:user];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [CWToastUtil hideDefultHud];
//                self.rightNavItem.enabled = self.selectedArray.count;
                self.membersArray = accountModelList;
                [self.tableView reloadData];
            });
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error with %@",error);
    }];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.chooseContactType == ChooseContactTypeGroup) {
        return self.groupMembersArray.count;
    }
    else if (self.chooseContactType == ChooseContactTypeAll){
        return self.membersArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.chooseContactType == ChooseContactTypeGroup) {
        CWChooseContactCell * cell = [CWChooseContactCell cellWithTableView:tableView];
        CubeGroupMember *member = self.groupMembersArray[indexPath.row];
        cell.member = member;
        cell.isSelected = [self.selectedArray containsObject:member] ? YES : NO;
         return cell;
    }
    else if (self.chooseContactType == ChooseContactTypeAll){
        CWChooseContactCell * cell = [CWChooseContactCell cellWithTableView:tableView];
        CubeUser *member = self.membersArray[indexPath.row];
        cell.member = member;
        cell.isSelected = [self.selectedArray containsObject:member] ? YES : NO;
        return cell;
    }
    return nil;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView  *sectionView = [[UIView alloc] init];
//    sectionView.backgroundColor = CWRGBColorOpaque(241, 242, 247);
//    UILabel * titleLab = [[UILabel alloc] init];
//    [sectionView addSubview: titleLab];
//    titleLab.textColor = CWRGBColorOpaque(133, 154, 178);
//    titleLab.font = [UIFont systemFontOfSize:10.0f];
////    titleLab.text = @"x";
//    titleLab.textAlignment = NSTextAlignmentLeft;
//    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(titleLab.superview);
//        make.left.mas_equalTo(18);
//    }];
//    return sectionView;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id member;
    if (self.chooseContactType == ChooseContactTypeAll) {
        member = self.membersArray[indexPath.row];
    }
    else if (self.chooseContactType == ChooseContactTypeGroup){
        member = self.groupMembersArray[indexPath.row];
    }
    
    if (![self.selectedArray containsObject:member]) {
        if(self.selectedArray.count >= 9)
        {
            [CWToastUtil showTextMessage:@"最大参与人员不能超过9人" andDelay:1.f];
        }
        else
        {
            [self.selectedArray addObject:member];
        }
    }
    else{
        [self.selectedArray removeObject:member];
    }
    
    
    self.rightNavItem.title = self.selectedArray.count ?  [NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] :  @"确定";
//    self.rightNavItem.enabled = self.selectedArray.count;
    [self.tableView reloadData];
}

#pragma mark - event response
- (void)leftBarButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightItemClick{
    NSLog(@"选择成员完成..");
//    if (self.chooseContactType == ChooseContactTypeGroup) {
//
//    }
//    else if (self.chooseContactType == ChooseContactTypeGroup){
//
//    }
    
    __weak __typeof(self)weakSelf = self;

    if (self.rightItemBlock) {
        weakSelf.rightItemBlock(weakSelf.selectedArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.rowHeight = 75;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(UIBarButtonItem *)leftNavItem{
    if (!_leftNavItem) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 62, 44);
        [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [leftBtn setTitleColor:nil forState:UIControlStateNormal];
        [leftBtn setTitleColor:nil forState:UIControlStateSelected];
        [leftBtn setImage:[UIImage imageNamed:@"img_return_normal"] forState:UIControlStateNormal];
//        [leftBtn setImage:[UIImage imageNamed:@"btn_return_selected"] forState:UIControlStateSelected];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
        [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
        [leftBtn addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftNavItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    }
    return _leftNavItem;
}

-(UIBarButtonItem *)rightNavItem{
    if (!_rightNavItem) {
        _rightNavItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(navRightItemClick)];
        _rightNavItem.tintColor = [CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1];
//        _rightNavItem.enabled = NO;
        [_rightNavItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16.f],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    return _rightNavItem;
}

@end
