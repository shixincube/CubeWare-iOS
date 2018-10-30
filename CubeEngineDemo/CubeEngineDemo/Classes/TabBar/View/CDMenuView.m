//
//  CDMenuView.m
//  CubeWare
//
//  Created by pretty on 2018/8/24.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//
#import "CDMenuTableViewCell.h"
#import "CDMenuView.h"
@interface CDMenuView()<UITableViewDelegate,UITableViewDataSource>

/**
 菜单table
 */
@property (nonatomic,strong) UITableView *menuTableView;

/**
 菜单背景
 */
@property (nonatomic,strong) UIImageView *menuBackgroupView;

/**
 图标 
 */
@property (nonatomic, strong) NSArray *icons;

/**
 菜单列表
 */
@property (nonatomic, strong) NSArray *titles;

/**
 window
 */
@property (nonatomic, strong) UIWindow *window;

/**
 背景View
 */
@property (nonatomic,strong) UIView *backgroupView;
@end

@implementation CDMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titles withIcons:(NSArray *)icons
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroupView];
        self.titles = titles;
        self.icons = icons;
        [self addSubview:self.menuBackgroupView];
        [self addSubview:self.menuTableView];
        self.window = [UIApplication sharedApplication].keyWindow;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap:)];
        [self.backgroupView addGestureRecognizer:tap];

    }
    return self;
}

- (UIView *)backgroupView
{
    if (nil == _backgroupView)
    {
        _backgroupView = [[UIView alloc]initWithFrame:self.frame];
        //可设置背景颜色
        _backgroupView.backgroundColor = [UIColor blackColor];
        _backgroupView.alpha = 0.16;
    }
    return _backgroupView;
}

- (UITableView *)menuTableView
{
    if (nil == _menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth - 140,SafeAreaTopHeight+5, 135, self.titles.count * 44) style:UITableViewStylePlain];
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.layer.cornerRadius = 7;
        _menuTableView.layer.masksToBounds = NO;
    }
    return _menuTableView;
}

- (UIImageView *)menuBackgroupView
{
    if(nil == _menuBackgroupView)
    {
        _menuBackgroupView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 140,SafeAreaTopHeight, 135, self.titles.count * 44 + 5)];
        [_menuBackgroupView setImage:[UIImage imageNamed:@"img_menu_view"]];
        _menuBackgroupView.layer.shadowColor = KBlackColor.CGColor;
        _menuBackgroupView.layer.shadowOffset = CGSizeMake(1, 1);
        _menuBackgroupView.layer.shadowOpacity = 0.3;

    }
    return _menuBackgroupView;
}

- (void)Tap:(UITapGestureRecognizer *)tapGes
{
    [self removeFromSuperview];
}

- (void)showMenuView
{
    [self.window addSubview:self];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
    }
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    CDMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CDMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.title.text = [self.titles objectAtIndex:indexPath.row];
    cell.separatorLine.width = 115;
    if(self.icons && self.icons.count != 0)
    {
        cell.iconImage = [UIImage imageNamed:[self.icons objectAtIndex:indexPath.row]];
    }
    if (indexPath.row == self.titles.count -1)
    {
        cell.separatorLine.hidden = YES;
    }
    return cell;
}


@end
