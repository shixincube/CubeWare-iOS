
//
//  CDMeViewController.m
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/21.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDMeViewController.h"
#import "CDMeTableView.h"
#import "CDLoginViewController.h"
#import "CWWorkerFinder.h"
#import "CWInfoRefreshDelegate.h"
#import "CDNickNameViewController.h"
#import "CDAvatarViewController.h"
#import "CWUserDelegate.h"
@interface CDMeViewController ()<CDMeTableViewDelegate>
@property (nonatomic,strong) CDMeTableView *meTable;
@property (nonatomic,strong) UIButton *logoutBtn;
@property (nonatomic,strong) CubeUser *currentUser;
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;
@end

@implementation CDMeViewController
// 隐藏导航栏分割线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(CDMeTableView *)meTable{
    if (!_meTable) {
        _meTable = [[CDMeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        _meTable.scrollEnabled = NO;
        _meTable.MeDelegate = self;
    }
    return _meTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initializeAppearance];
    [self registWorkerFinder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)initializeAppearance{
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = KWhiteColor;
    self.currentUser = [CubeEngine sharedSingleton].userService.currentUser;
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self.view addSubview:self.meTable];
    
    self.logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.logoutBtn.layer.cornerRadius = 5;
    self.logoutBtn.layer.masksToBounds = YES;
    [self.logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.logoutBtn.backgroundColor = RGBA(0x43, 0x93, 0xf9, 1.f);
    [self.logoutBtn addTarget:self action:@selector(onLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutBtn];
    
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.meTable.mas_bottom).offset(43);
        make.size.mas_equalTo(CGSizeMake(120, 43));
    }];
}

- (void)registWorkerFinder{
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWInfoRefreshDelegate),@protocol(CWUserServiceDelegate)]];
}

#pragma mark - CDMeTableViewDelegate
-(void)onClickNickNameRow
{
    CDNickNameViewController *view = [[CDNickNameViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)onClickAvtatorRow
{
    CDAvatarViewController *view = [[CDAvatarViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:view animated:YES completion:^{

    }];
}

-(void)onLogout{
    [[CubeWare sharedSingleton].accountService logoutWithForce:YES];
}

- (void)updateUserSuccess:(CubeUser *)user
{
    //更新成功
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.meTable updateUserInfo];
    });
}

- (void)updateUserFailed:(CubeError *)error
{

}

@end
