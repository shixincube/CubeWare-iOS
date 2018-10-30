//
//  CDUserInfoViewController.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDUserInfoViewController.h"
#import "CDUserInfoTableView.h"
#import "CDSessionViewController.h"
#import "CWActionSheet.h"
#import "CDHudUtil.h"
@interface CDUserInfoViewController ()<CDUserInfoDelegate,CWActionSheetDelegate>

/**
 用户个人信息
 */
@property (nonatomic,strong) CDUserInfoTableView *userTableView;

/**
 分割线
 */
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;

/**
 发送消息
 */
@property (nonatomic,strong) UIButton *sendButton;
@end

@implementation CDUserInfoViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KWhiteColor;
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self.view addSubview:self.userTableView];
    [self.view addSubview:self.sendButton];
     UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMoreItem:)];
     self.navigationItem.rightBarButtonItem =  moreItem;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cubeId=%@",self.user.cubeId];
    NSArray *array = [[CDShareInstance sharedSingleton].friendList filteredArrayUsingPredicate:predicate];
    CDLoginAccountModel *model = array.firstObject;
    if (model) {
        self.user = model;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    _navBarHairlineImageView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _navBarHairlineImageView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CDUserInfoTableView *)userTableView
{
    if (nil == _userTableView) {
        _userTableView = [[CDUserInfoTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-SafeAreaBottomHeight)];
        _userTableView.infoDelegate = self;
    }
    return _userTableView;
}

- (void)setUser:(CDLoginAccountModel *)user
{
    _user = user;
    self.userTableView.user = user;
}

- (UIButton *)sendButton
{
    if(nil == _sendButton)
    {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setFrame:CGRectMake(0, self.view.frame.size.height - 43 - SafeAreaBottomHeight, kScreenWidth, 43)];
        [_sendButton setBackgroundColor:RGBA(0x43 , 0x93, 0xF9, 1)];
        [_sendButton setTitle:@"发消息" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sendButton addTarget:self action:@selector(onClickChatButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void)onClickChatButton
{
    CDSessionViewController *sessionView = [[CDSessionViewController alloc] initWithSession:[[CWSession alloc] initWithSessionId:self.user.cubeId andType:CWSessionTypeP2P]];
    [self.navigationController pushViewController:sessionView animated:YES];
}

#pragma mark -
- (void)onClickBackItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onClickMoreItem:(UIButton *)button
{
    CWActionSheet *sheet = [CWActionSheet sheetWithTitle:nil buttonTitles:@[@"删除好友"] redButtonIndex:0 delegate:self];
    [sheet show];
}

- (void)actionSheet:(CWActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{

}
#pragma 
- (void)didselectedIndexPath:(NSIndexPath *)indexPath
{

}

- (void)userViewPushToSessionViewController:(CDLoginAccountModel *)user
{
    
}


@end
