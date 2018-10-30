//
//  CDLoginChooseViewController.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDLoginChooseViewController.h"
#import "CDAccountListCell.h"
#import "CDTabBarController.h"
#import "CDHudUtil.h"
//#import <MBProgressHUD.h>

@interface CDLoginChooseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *accountList;
//@property (nonatomic,strong) MBProgressHUD *progressHud;
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;
@end

@implementation CDLoginChooseViewController
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
    self.title = @"选择账号";
    [self initializeAppearance];
    [self initializeDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeAppearance{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;

    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navBarHairlineImageView.hidden = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;

    self.accountList = [[UITableView alloc] init];
    self.accountList.delegate = self;
    self.accountList.dataSource = self;
    
    [self.view addSubview:self.accountList];
    
    [self.accountList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(self.view.mas_height);
    }];
    
    [self.accountList registerClass:[CDAccountListCell class] forCellReuseIdentifier:@"accountListCell"];
//    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
//    self.progressHud.label.text = @"正在获取账号列表..";
//    self.progressHud.label.textColor = KBlackColor;
//    [self.view addSubview:self.progressHud];
}

- (void)initializeDataSource{
    
    NSString *queryCubeIdByAppId = [NSString stringWithFormat:@"%@%@",CDServiceHost,QueryCubeIdListByAppId];
    NSDictionary *params = @{
                             @"appId":self.appId,
                             @"page":@(0),
                             @"rows":@(35)
                             };
    [CDHudUtil showDefultHud];
    [[AFHTTPSessionManager manager] POST:queryCubeIdByAppId parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success with %@",responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *accountList = responseObject[@"data"][@"list"];
            NSMutableArray *accountModelList = [NSMutableArray array];
            for (NSDictionary *dic in accountList) {
                CDLoginAccountModel *model = [CDLoginAccountModel fromDictionary:dic];
                [accountModelList addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [CDHudUtil hideDefultHud];
                self.accountModelArray = accountModelList;
                [CDShareInstance sharedSingleton].friendList = accountModelList;
                [self.accountList reloadData];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error with %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [CDHudUtil hideDefultHud];
        });
    }];
}

- (void)onClickBackItem:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.accountModelArray && self.accountModelArray.count)
    {
        return self.accountModelArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.accountModelArray && self.accountModelArray.count)
    {
        return 78;
    }
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.accountModelArray && self.accountModelArray.count)
    {
        CDAccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CDLoginAccountModel *model = self.accountModelArray[indexPath.row];
        cell.model = model;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountListCell1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountListCell1"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDLoginAccountModel *model = self.accountModelArray[indexPath.row];
    NSString *cubeId = model.cubeId;
    [self getTokenWithCubeId:cubeId];
}


#pragma mark - CubeEngine Login
- (void)getTokenWithCubeId:(NSString *)cubeId{
    NSString *urlString = GetTokenUrl;
    NSDictionary *params = @{
                             @"appId":self.appId,
                             @"appKey":self.appKey,
                             @"cube":cubeId
                             };
    [CDHudUtil showDefultHud];
    [[AFHTTPSessionManager manager] POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CDHudUtil hideDefultHud];
            int code = [[[responseObject objectForKey:@"state"] objectForKey:@"code"] intValue];
            if(code == 201 || code == 200)
            {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                NSString *token = [data objectForKey:@"cubeToken"];
            
                CDLoginAccountModel *loginModel = [[CDLoginAccountModel alloc] init];
                loginModel.cubeId = cubeId;
                loginModel.cubeToken = token;
                [CDShareInstance sharedSingleton].loginModel = loginModel;
                
                NSDictionary *loginInfoDic = @{
                                               @"cubeToken":token,
                                               @"cubeId":cubeId,
                                               @"appId":self.appId,
                                               @"appKey":self.appKey
                                               };
                [[NSUserDefaults standardUserDefaults] setObject:loginInfoDic forKey:@"currentLogin"];
                
                CDTabBarController *tabBarVC = [[CDTabBarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
            }
            else
            {
                NSLog(@"----------获取token失败---------:%@",responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


@end
