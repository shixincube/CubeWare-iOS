//
//  CDEditGroupInfoViewController.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDEditGroupInfoViewController.h"

@interface CDEditGroupInfoViewController ()<UITextFieldDelegate>

/**
 文字输入框
 */
@property (nonatomic,strong) UITextField *textField;
@end

@implementation CDEditGroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑群聊名称";
    self.view.backgroundColor = KWhiteColor;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;

    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onClickDoneItem:)];
    doneItem.tintColor = RGBA(0x43,0x93,0xf9,1);
    self.navigationItem.rightBarButtonItem = doneItem;

    [self.view addSubview:self.textField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextField *)textField
{
    if (nil == _textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, SafeAreaTopHeight + 20, kScreenWidth - 15, 40)];
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.placeholder = @"请输入群组名称";
    }
    return _textField;
}

- (void)setGroup:(CubeGroup *)group
{
    _group = group;
    self.textField.text = group.displayName;
}

#pragma mark -
- (void)onClickBackItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onClickDoneItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    self.group.displayName = self.textField.text;
    [[CubeWare sharedSingleton].groupService updateGroup:self.group];
}
#pragma mark -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


@end
