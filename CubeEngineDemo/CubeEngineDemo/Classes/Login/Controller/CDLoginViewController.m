//
//  CDLoginViewController.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDLoginViewController.h"
#import "CDLoginChooseViewController.h"

@interface CDLoginViewController ()

@property (nonatomic,strong) UIImageView *portraitView;
@property (nonatomic,strong) UITextField *appIdField;
@property (nonatomic,strong) UITextField *appKeyField;
@property (nonatomic,strong) UIButton *nextBtn;

@end

@implementation CDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initilizeAppearance];
    [self initializeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initilizeAppearance{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    self.portraitView = [[UIImageView alloc]init];
    self.portraitView.backgroundColor = [UIColor orangeColor];
    self.portraitView.layer.cornerRadius = 45;
    self.portraitView.layer.masksToBounds = YES;
    [self.view addSubview:self.portraitView];
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(80);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    
    self.appIdField = [[UITextField alloc] init];
    self.appIdField.placeholder = @"APPID";
    self.appIdField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.appIdField];

    UIView *keyLineView0 = [[UIView alloc]initWithFrame:CGRectZero];
    keyLineView0.backgroundColor = RGBA(0xe6, 0xe6, 0xe6, 1);
    [self.appIdField addSubview:keyLineView0];

    [self.appIdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth - 115);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.portraitView.mas_bottom).offset(50);
    }];

    [keyLineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.appIdField);
        make.height.mas_equalTo(@1);
        make.left.mas_equalTo(@0);
        make.top.mas_equalTo(self.appIdField.mas_bottom).offset(-1);
    }];

    self.appKeyField = [[UITextField alloc] init];
    self.appKeyField.placeholder = @"KEY";
    self.appKeyField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.appKeyField];

    UIView *keyLineView = [[UIView alloc]initWithFrame:CGRectZero];
    keyLineView.backgroundColor = RGBA(0xe6, 0xe6, 0xe6, 1);
    [self.appKeyField addSubview:keyLineView];
    
    [self.appKeyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth - 115);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.appIdField.mas_bottom).offset(30);
    }];

    [keyLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.appKeyField);
        make.height.mas_equalTo(@1);
        make.left.mas_equalTo(@0);
        make.top.mas_equalTo(self.appKeyField.mas_bottom).offset(-1);
    }];

    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = YES;
    [self.nextBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.nextBtn.backgroundColor = RGBA(89, 147, 242, 1.f);
    [self.nextBtn addTarget:self action:@selector(onNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appKeyField.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(120);
    }];
    
 
    
}

- (void)initializeData{
    self.appIdField.text = APPID;
    self.appKeyField.text = APPKey;
}

- (void)onNext:(UIButton *)sender{
    [self.view endEditing:YES];
    
    [self startCubeEngine];
    
    
    CDLoginChooseViewController *chooseAccountVc = [[CDLoginChooseViewController alloc] init];
//    chooseAccountVc.accountModelArray = accountModelList;
    chooseAccountVc.appId = self.appIdField.text;
    chooseAccountVc.appKey = self.appKeyField.text;
//    [CDShareInstance sharedSingleton].friendList = accountModelList;
    [self.navigationController pushViewController:chooseAccountVc animated:YES];
}


- (void)startCubeEngine{
    CubeConfig *config = [CubeConfig configWithAppId:self.appIdField.text AppKey:self.appKeyField.text];
    config.licenseServer = GetLicenseUrl;
    config.videoCodec = @"VP8"; // H264
    [[CubeWare sharedSingleton] startWithcubeConfig:config];
}


@end
