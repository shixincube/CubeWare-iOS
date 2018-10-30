//
//  CDSegmentTableView.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDSegmentView.h"

#define BADGE_BG_COLOR_DEFAULT RGBA(0x43,0x93,0xf9,1)

@interface CDSegmentView ()<UIScrollViewDelegate>

/**
 分割线
 */
@property (nonatomic,strong) UIView *line;
/**
 当前滚动条
 */
@property (nonatomic,strong) UIView *progressLine;

/**
 功能列表
 */
@property (nonatomic,strong) UIScrollView *segmentsList;

/**
 按钮数组
 */
@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation CDSegmentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        [self addSubview:self.segmentsList];
        [self addSubview:self.line];
        [self addSubview:self.progressLine];
    }
    return self;
}

- (UIScrollView *)segmentsList
{
    if (nil == _segmentsList)
    {
        _segmentsList = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,84, self.frame.size.height)];
        _segmentsList.delegate = self;
        _segmentsList.showsVerticalScrollIndicator = NO;
        _segmentsList.pagingEnabled = YES;

    }
    return _segmentsList;
}

- (UIView *)progressLine
{
    if (nil == _progressLine)
    {
        _progressLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 2, 30, 2)];
        _progressLine.backgroundColor = BADGE_BG_COLOR_DEFAULT;
    }
    return _progressLine;
}

- (UIView *)line
{
    if (nil == _line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        _line.backgroundColor = RGBA(0xe6, 0xe6, 0xe6, 1);
    }
    return _line;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    self.segmentsList.contentSize = CGSizeMake(32 * self.titles.count, 0);
    self.buttonArray = [NSMutableArray array];
    for(int i = 0; i < self.titles.count ; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:RGBA(0x26, 0x25, 0x2A, 1) forState:UIControlStateNormal];
        [button setTitleColor:BADGE_BG_COLOR_DEFAULT forState:UIControlStateSelected];
        [button setFrame:CGRectMake((32 + 10)* i , 0, 32, self.frame.size.height)];
        [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentsList addSubview:button];
        [self.buttonArray addObject:button];

    }
}

- (void)setSegIndex:(NSInteger)segIndex
{
    _segIndex = segIndex;
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        if (i != segIndex) {
            [button setSelected:NO];
        }
        else
        {
            [button setSelected:YES];
            [UIView animateWithDuration:0.1 animations:^{
                self.progressLine.x = segIndex * (32+10);
            }];
        }
    }
    if (self.segmentDelegate && [self.segmentDelegate respondsToSelector:@selector(didSelectedIndex:)])
    {
        [self.segmentDelegate didSelectedIndex:segIndex];
    }
}

- (void)onButtonClick:(UIButton *)button
{
    [button setSelected:YES];
    NSInteger tag = button.tag;
    [UIView animateWithDuration:0.1 animations:^{
        self.progressLine.x = tag * (32+10);
    }];
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *other = [self.buttonArray objectAtIndex:i];
        if (i != tag) {
            [other setSelected:NO];
        }
    }
    if (self.segmentDelegate && [self.segmentDelegate respondsToSelector:@selector(didSelectedIndex:)])
    {
        [self.segmentDelegate didSelectedIndex:tag];
        _segIndex = tag;
    }
}



#pragma mark -
@end
