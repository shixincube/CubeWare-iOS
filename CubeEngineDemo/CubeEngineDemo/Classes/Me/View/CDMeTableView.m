//
//  CDMeTableView.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDMeTableView.h"
#import "CDSubTitleTableViewCell.h"
#import "CDMeTableHeaderView.h"

@interface CDMeTableView ()<UITableViewDelegate,UITableViewDataSource,CDMeTableHeaderDelegate>

/**
 当前用户
 */
@property (nonatomic,strong) CubeUser *currentUser;

@end

@implementation CDMeTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[CDSubTitleTableViewCell class] forCellReuseIdentifier:@"meTableCell"];
        self.sectionFooterHeight = 0.01f;
        self.currentUser = [CubeEngine sharedSingleton].userService.currentUser;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CDMeTableHeaderView *headerView = [[CDMeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    [headerView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.currentUser.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default.png"]];
    headerView.nameLabel.text = self.currentUser.displayName;
    headerView.delegate = self;
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meTableCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.title.text = @"ID";
        cell.content.text = self.currentUser.cubeId;
    }
    else if (indexPath.row == 1){
        cell.title.text = @"昵称";
        cell.content.text = self.currentUser.displayName;
        cell.showRightArrow = YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        //跳转到转修改昵称页面
        if (self.MeDelegate && [self.MeDelegate respondsToSelector:@selector(onClickNickNameRow)]) {
            [self.MeDelegate onClickNickNameRow];
        }
    }
}


- (void)onClickAvatarBtn
{
    if (self.MeDelegate && [self.MeDelegate respondsToSelector:@selector(onClickAvtatorRow)]) {
        [self.MeDelegate onClickAvtatorRow];
    }
}

- (void)updateUserInfo
{
    self.currentUser = [CubeEngine sharedSingleton].userService.currentUser;
    [self reloadData];
}

@end
