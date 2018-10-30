//
//  CDUserInfoTableView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDUserInfoTableView.h"
#import "UIImageView+WebCache.h"
#import "CDSubTitleTableViewCell.h"
#import "CDInfoTopView.h"
@interface CDUserInfoTableView()<UITableViewDelegate,UITableViewDataSource,CDInfoTopViewDelegate>

@end
@implementation CDUserInfoTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 180;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId1"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId1"];
    }
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        CDInfoTopView *topView = [[CDInfoTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
        topView.delegate = self;
        topView.title.text = self.user.displayName;
        [topView.iconView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default.png"]];
        if([[CDShareInstance sharedSingleton].loginModel.cubeId isEqualToString:self.user.cubeId])
        {
            topView.isMySelf = YES;
        }
        [cell addSubview:topView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.row == 1) {
        CDSubTitleTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:@"cellId2"];
        if (cell == nil) {
            cell = [[CDSubTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId2"];
        }
        cell.title.text = @"ID";
        cell.content.text = self.user.cubeId;
        return cell;
    }
    else if (indexPath.row == 2)
    {
        CDSubTitleTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:@"cellId3"];
        if (cell == nil) {
            cell = [[CDSubTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId3"];
        }
        cell.title.text = @"昵称";
        cell.content.text = self.user.displayName?self.user.displayName:self.user.cubeId;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.infoDelegate && [self.infoDelegate respondsToSelector:@selector(didselectedIndexPath:)])
    {
        [self.infoDelegate didselectedIndexPath:indexPath];
    }
}
@end
