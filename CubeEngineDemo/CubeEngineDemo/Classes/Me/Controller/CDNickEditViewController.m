//
//  CDNickEditViewController.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/4.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDNickEditViewController.h"

@interface CDNickEditViewController ()<UITextFieldDelegate>

/**
 输入框
 */
@property (nonatomic,strong) UITextField *textField;
@end

@implementation CDNickEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KWhiteColor;
    self.title = @"昵称";
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCancel:)];
    self.navigationItem.leftBarButtonItem = cancelItem;

    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onClickDone:)];
    self.navigationItem.rightBarButtonItem = doneItem;

    [self.view addSubview:self.textField];
    self.textField.text = [CDShareInstance sharedSingleton].loginModel.displayName?[CDShareInstance sharedSingleton].loginModel.displayName:@"昵称";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickCancel:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDone:(UIButton *)button
{
    //wait to do  update user nickname

    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)textField
{
    if (nil == _textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, SafeAreaTopHeight + 20, kScreenWidth - 15, 40)];
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.placeholder = @"请输入昵称";
    }
    return _textField;
}


@end
