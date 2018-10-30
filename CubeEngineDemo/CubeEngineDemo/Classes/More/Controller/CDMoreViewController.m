//
//  CDMoreViewController.m
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/21.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDMoreViewController.h"
#import "CDConferenceViewController.h"
#import "CDPopView.h"
#import "CDSelectContactsViewController.h"
@interface CDMoreViewController ()<PopViewDelegate>

@property (nonatomic, strong) CDPopView *popView;

@end

@implementation CDMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KWhiteColor;

    _popView = [[CDPopView alloc] initWithFrame:self.view.frame];
    _popView.popDelegate = self;
    [self.view addSubview:_popView];
    [_popView showPop];

}

#pragma mark - MenuPopDelegate
- (void)popView:(CDPopView *)popView didSelectedIndex:(NSInteger)selectedIndex{
    NSLog(@"selectedIndex = %ld",selectedIndex);
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedIndex:)])
    {
        [self.delegate didSelectedIndex:selectedIndex];
    }
}

- (void)hidePopView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
