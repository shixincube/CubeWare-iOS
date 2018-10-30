//
//  CWSegmentedControl.m
//  CubeWare
//
//  Created by Mario on 17/2/9.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSegmentedControl.h"
#import "CubeWareHeader.h"
#define CWSegmentedControl_Height 45.0
#define Min_Width_4_Button 80.0
#define Define_Tag_add 1000

@interface CWSegmentedControl()
@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *array4Btn;
@property (strong, nonatomic)UIView *bottomLineView;
@end

@implementation CWSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Titles:(NSArray *)titles delegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self setUserInteractionEnabled:YES];
        self.delegate = delegate;
        //  array4btn
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        //  set button
        CGFloat width4btn = frame.size.width/[titles count];
        if (width4btn < Min_Width_4_Button) {
            width4btn = Min_Width_4_Button;
        }
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        _scrollView.contentOffset = CGPointMake(0, 40);
        _scrollView.backgroundColor = self.backgroundColor;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake([titles count]*width4btn, 40);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        //[_scrollView setScrollEnabled:NO];
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        for (int i = 0; i<[titles count]; i++) {
            //UIColorFromRGB(0x454545)
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width4btn, 0, width4btn, CWSegmentedControl_Height);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.backgroundColor = UIColorFromRGB(0xffffff);
            [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x4393f9) forState:UIControlStateSelected];
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            btn.contentEdgeInsets = UIEdgeInsetsMake(15, 0, -15, 0);
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [_scrollView addSubview:btn];
            [_array4Btn addObject:btn];
            if (i == 0) {
                btn.selected = YES;
            }
        }
        //  lineView
        CGFloat height4Line = CWSegmentedControl_Height/3.0f;
        for (int i = 1; i<[titles count]; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*width4btn-1.0f, 2, 0.0f, height4Line*3)];
            lineView.backgroundColor = UIColorFromRGB(0xcccccc);
            [_scrollView addSubview:lineView];
        }
        //  bottom lineView
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CWSegmentedControl_Height-1, width4btn-20.0f, 1.0f)];
        _bottomLineView.backgroundColor = UIColorFromRGB(0x4393f9);
        [_scrollView addSubview:_bottomLineView];
    }
    return self;
}

#pragma mark - btn clicked
- (void)segmentedControlChange:(UIButton *)btn
{
    btn.selected = YES;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
        }
    }
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x + 10 ;//+ 34
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if ((btn.tag - Define_Tag_add) >= 2 && [_array4Btn count] > 4 && [_array4Btn count] > (btn.tag - Define_Tag_add + 2)) {
        pt.x = btn.frame.origin.x - Min_Width_4_Button*1.5f;
        canScrolle = YES;
    }else if ([_array4Btn count] > 4 && (btn.tag - Define_Tag_add + 2) >= [_array4Btn count]){
        pt.x = (_array4Btn.count - 4) * Min_Width_4_Button;
        canScrolle = YES;
    }else if (_array4Btn.count > 4 && (btn.tag - Define_Tag_add) < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.bottomLineView.frame = rect4boottomLine;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomLineView.frame = rect4boottomLine;
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlSelectAtIndex:)]) {
        [self.delegate segmentedControlSelectAtIndex:btn.tag - 1000];
    }
}


#pragma mark ////// index 从 0 开始
// delegete method
- (void)changeSegmentedControlWithIndex:(NSInteger)index
{
    if (index > [_array4Btn count]-1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"index 超出范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [self segmentedControlChange:btn];
}


@end
