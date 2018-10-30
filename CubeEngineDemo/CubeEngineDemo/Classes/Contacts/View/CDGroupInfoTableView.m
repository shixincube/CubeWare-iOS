//
//  CDGroupInfoTableView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDGroupInfoTableView.h"
#import "UIImageView+WebCache.h"
#import "CDSubTitleTableViewCell.h"
#import "CDMembersTableViewCell.h"
#import "CDInfoTopView.h"
@interface CDGroupInfoTableView ()<UITableViewDelegate,UITableViewDataSource,CDInfoTopViewDelegate,CDMembersCellDelegate>

@end

@implementation CDGroupInfoTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    }
    return self;
}

- (void)setGroup:(CubeGroup *)group
{
    _group =  group;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}



#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 180;
    }
    else if (indexPath.row == 3)
    {
        NSMutableArray *dataArray = [NSMutableArray array];
        [dataArray addObjectsFromArray:self.group.masters];
        [dataArray addObjectsFromArray:self.group.members];
        CGFloat height = [CDMembersTableViewCell getGroupMemberCellHegiht:dataArray];
        return height;
    }
    return 57;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId1"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId1"];
    }
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId1"];
        CDInfoTopView *topView = [[CDInfoTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
        topView.delegate = self;
        topView.title.text = self.group.displayName;
        [topView.iconView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"group.png"]];
        [cell addSubview:topView];
    }
    else if (indexPath.row == 1) {
        CDSubTitleTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:@"cellId3"];
        if (cell == nil) {
            cell = [[CDSubTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId3"];
        }
        cell.title.text = @"群号";
        cell.content.text = self.group.groupId;
        return cell;
    }
    else if (indexPath.row == 2)
    {
        CDSubTitleTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:@"cellId3"];
        if (cell == nil) {
            cell = [[CDSubTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId3"];
        }
        cell.title.text = @"群名称";
        cell.content.text = self.group.displayName;
        cell.showRightArrow = YES;
        return cell;
    }
    else
    {
        CDMembersTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:@"cellId4"];
        if (cell == nil) {
            cell = [[CDMembersTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId4"];
        }
        cell.delegate = self;
        cell.title.text = @"群成员";
        NSMutableArray *dataArray = [NSMutableArray array];
        [dataArray addObjectsFromArray:self.group.masters];
        [dataArray addObjectsFromArray:self.group.members];
        cell.dataArray = dataArray;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2) {
        if (self.infoDelegate && [self.infoDelegate respondsToSelector:@selector(editGroupName:)]) {
            [self.infoDelegate editGroupName:self.group];
        }
    }
    else if (indexPath.row == 0)
    {
        if (self.infoDelegate && [self.infoDelegate respondsToSelector:@selector(showAvator:)]) {
            [self.infoDelegate showAvator:self.group];
        }
    }
}
#pragma mark -CDMembersCellDelegate
- (void)onClickAddMemberButton
{
    if(self.infoDelegate && [self.infoDelegate respondsToSelector:@selector(addGroupMember:)])
    {
        [self.infoDelegate addGroupMember:self.group];
    }
}
@end
