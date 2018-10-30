//
//  CDNickNameViewController.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/3.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDNickNameViewController.h"
#import "CWWorkerFinder.h"
#import "CWUserDelegate.h"
#import "CWToastUtil.h"
#import "CDHudUtil.h"
@interface CDNickNameViewController ()<UITextFieldDelegate>

/**
 输入框
 */
@property (nonatomic,strong) UITextField *textField;

/**
 分割线
 */
@property (nonatomic,strong) UIView *lineView;

/**
 用户信息
 */
@property (nonatomic,strong) CubeUser *user;
@end

@implementation CDNickNameViewController

- (UITextField *)textField
{
    if (nil == _textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(18, 22, kScreenWidth - 18 * 2, 40)];
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.placeholder = @"请输入昵称";
    }
    return _textField;
}

- (UIView *)lineView
{
    if (nil == _lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0,40, kScreenWidth - 18 * 2, 1)];
        _lineView.backgroundColor = RGBA(0xe6, 0xe6, 0xe6, 1);
    }
    return _lineView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑昵称";
    self.view.backgroundColor = KWhiteColor;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    UIBarButtonItem *sureItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onClickSure:)];
    backItem.tintColor = KBlackColor;
    self.navigationItem.rightBarButtonItem =  sureItem;
    self.navigationItem.leftBarButtonItem = backItem;

    [self.view addSubview:self.textField];
    [self.textField addSubview:self.lineView];

    self.user =  [CubeEngine sharedSingleton].userService.currentUser;
    self.textField.text = self.user.displayName;

    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWUserServiceDelegate)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -events
- (void)onClickSure:(UIButton *)button
{
    if (self.textField.text.length >0) {
        self.user.displayName = self.textField.text;
        [[CubeEngine sharedSingleton].userService updateUser:self.user];
        [CDHudUtil showDefultHud];
    }
    else
    {
        [CWToastUtil showTextMessage:@"请输入昵称" andDelay:1.0f];
    }
}

- (void)onClickBackItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateUserSuccess:(CubeUser *)user
{
    //更新成功
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil hideDefultHud];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)updateUserFailed:(CubeError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //弹窗
        [CDHudUtil hideDefultHud];
        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
    });
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    return YES;
}
@end
