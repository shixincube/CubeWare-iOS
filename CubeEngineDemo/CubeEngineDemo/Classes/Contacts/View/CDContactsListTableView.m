//
//  CDContactsListTableView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/28.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDContactsListTableView.h"
#import "CDContactsTableViewCell.h"
#import "CDLoginAccountModel.h"
#import "UIImageView+WebCache.h"
@interface CDContactsListTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CDContactsListTableView

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

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
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
    if(self.dataArray)
    {
        return self.dataArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray) {
        return 60;
    }
    return self.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray)
    {
        CDContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil)
        {
            cell = [[CDContactsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        }
        cell.separatorLine.hidden = YES;
        if (self.type == Contacts_Group)
        {
            CubeGroup *group = [self.dataArray objectAtIndex:indexPath.row];
            if(group.displayName != nil && group.displayName.length > 0)
            {
                cell.title.text = group.displayName;
            }
            else
            {
                cell.title.text = group.groupId;
            }
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:group.avatar] placeholderImage:[UIImage imageNamed:@"group.png"]];
        }
        else
        {
            CDLoginAccountModel *account = [self.dataArray objectAtIndex:indexPath.row];
            if (account.displayName!=nil && account.displayName.length > 0)
            {
                cell.title.text = account.displayName;
            }
            else
            {
                cell.title.text = account.cubeId;
            }
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default.png"]];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId1"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId1"];
        }
        UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        info.text = @"列表为空";
        info.textColor = [UIColor blackColor];
        info.font = [UIFont systemFontOfSize:14];
        info.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:info];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listDelegate && [self.listDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:withListTableView:)])
    {
        [self.listDelegate didSelectRowAtIndexPath:indexPath withListTableView:self];
    }
}
@end
