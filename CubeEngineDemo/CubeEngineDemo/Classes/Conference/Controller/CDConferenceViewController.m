//
//  CWConferenceViewController.m
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/21.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import "CDConferenceViewController.h"
#import "CDConferenceTableView.h"
#import "CDCreateConferenceViewController.h"
#import "CDConferenceDetailInfoController.h"

@interface CDConferenceViewController ()<CDConferenceTableViewDelegate,CWConferenceServiceDelegate>
/**
 标题
 */
@property (nonatomic,strong) UILabel *conferenceTitle;

/**
 会议列表
 */
@property (nonatomic,strong) CDConferenceTableView *conferenceTable;

@property (nonatomic,strong) UIImageView *navBarHairlineImageView;

@property (nonatomic,strong) UIButton *createConferenceBtn;
@end

@implementation CDConferenceViewController
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
    self.navigationController.navigationBar.barTintColor = KWhiteColor;
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self.view addSubview:self.conferenceTitle];
    [self.view addSubview:self.conferenceTable];
    [self.view addSubview:self.createConferenceBtn];
    
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate)]];
    
//    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_addMore_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickAddItem:)];
//    self.navigationItem.rightBarButtonItem =  addItem;
}

- (UILabel *)conferenceTitle
{
    if(nil == _conferenceTitle)
    {
        _conferenceTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, SafeAreaTopHeight, kScreenWidth, 50)];
        _conferenceTitle.text = @"会议";
        _conferenceTitle.font = [UIFont boldSystemFontOfSize:32];
        _conferenceTitle.textColor = KBlackColor;
        _conferenceTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _conferenceTitle;
}

- (UIButton *)createConferenceBtn{
    if (!_createConferenceBtn) {
        _createConferenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _createConferenceBtn.frame = CGRectMake(kScreenWidth - 100, SafeAreaTopHeight + 10, 100, 40);
        [_createConferenceBtn setTitle:@"+创建会议" forState:UIControlStateNormal];
        [_createConferenceBtn addTarget:self action:@selector(onClickAddItem:) forControlEvents:UIControlEventTouchUpInside];
        _createConferenceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_createConferenceBtn setTitleColor:KThemeColor forState:UIControlStateNormal];
    }
    return _createConferenceBtn;
}


-(CDConferenceTableView *)conferenceTable{
    if (!_conferenceTable) {
        _conferenceTable = [[CDConferenceTableView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, kScreenHeight - 140 - 44) style:UITableViewStylePlain];
        _conferenceTable.selectDelegate = self;
    }
    return _conferenceTable;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
    [self.conferenceTable syncConferenceList];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navBarHairlineImageView.hidden = NO;
}


#pragma mark - BarButtonItem selector
- (void)onClickAddItem:(UIBarButtonItem *)sender{
    CDCreateConferenceViewController *createConferenceVc = [[CDCreateConferenceViewController alloc] init];
     createConferenceVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createConferenceVc animated:YES];
}

#pragma mark - tableview select delegate
-(void)didSelectCellWithModel:(CDConferenceDetailInfoModel *)model{
    CDConferenceDetailInfoController *conferenceDetailVc = [[CDConferenceDetailInfoController alloc] init];
    conferenceDetailVc.model = model;
    conferenceDetailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conferenceDetailVc animated:YES];
    
}

-(void)updateConference:(CubeConference *)conference{
    if (conference.actions) {
        BOOL kick = NO;
        for (CubeConferenceControl *control in conference.actions) {
            if (control.action == CubeControlActionKick && [control.controlled.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
                kick = YES;
                break;
            }
        }
        if (kick) {
            [self.conferenceTable syncConferenceList];
        }
    }
}

@end
