//
//  CDSelectTableView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/31.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDSelectTableView.h"
#import "CDSelectTableViewCell.h"
@interface CDSelectTableView ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation CDSelectTableView

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
        _selectedArray = [NSMutableArray array];
        _noChooseList = [NSArray array];
    }
    return self;
}

- (void)setSelectedStatus
{
    for (int i = 0;i<self.listArray.count;i++) {
        [self.selectedArray addObject:[NSNumber numberWithBool:NO]];
    }
}

-(void)setListArray:(NSArray *)listArray
{
    _listArray = listArray;
}

- (void)setNoChooseList:(NSArray *)noChooseList
{
    _noChooseList = noChooseList;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil)
    {
        cell = [[CDSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    CDLoginAccountModel *user = [self.listArray objectAtIndex:indexPath.row];
    cell.title.text = user.displayName;
    if (user.displayName.length == 0) {
        cell.title.text = user.cubeId;
    }
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default"]];
    cell.unableChoose = [self.noChooseList containsObject:user.cubeId];
    cell.isSelected = [self.selectedArray containsObject:user.cubeId];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.unableChoose)
    {
        cell.isSelected = !cell.isSelected;
        if(cell.isSelected)
        {
            CDLoginAccountModel *user = [self.listArray objectAtIndex:indexPath.row];
            if (![_selectedArray containsObject:user.cubeId]) {
                [_selectedArray addObject:user.cubeId];
            }
        }
        else
        {
            CDLoginAccountModel *user = [self.listArray objectAtIndex:indexPath.row];
            if ([_selectedArray containsObject:user.cubeId]) {
                [_selectedArray removeObject:user.cubeId];
            }
        }
        if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(updateSelectList:)])
        {
            [self.selectDelegate updateSelectList:_selectedArray.count];
        }
    }
}

@end
