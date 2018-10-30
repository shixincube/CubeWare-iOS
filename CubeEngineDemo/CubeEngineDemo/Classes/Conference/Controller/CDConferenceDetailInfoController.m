//
//  CDConferenceDetailInfoController.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/10.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConferenceDetailInfoController.h"
#import "CDSelectContactsViewController.h"
#import "CDConferenceInfoView.h"
#import "CWChooseContactController.h"
#import "CDHudUtil.h"

@interface CDConferenceDetailInfoController () <CDConferenceInfoViewDelegate>
@property (nonatomic,strong) CDConferenceInfoView *conferenceInfoView;
@end

@implementation CDConferenceDetailInfoController

- (instancetype)init{
    if (self = [super init]) {
        [self.view addSubview:self.conferenceInfoView];
        [self.conferenceInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CDConferenceInfoView *)conferenceInfoView{
    if (!_conferenceInfoView) {
        _conferenceInfoView = [[CDConferenceInfoView alloc] initWithType:ConferenceDetailShowTypeDetail];
        _conferenceInfoView.delegate = self;
        [_conferenceInfoView hidePlaceHolder:YES];
    }
    return _conferenceInfoView;
}

- (void)setModel:(CDConferenceDetailInfoModel *)model{
    _model = model;
    self.conferenceInfoView.currentModel = model;
}


- (void)initializeAppearance{
    self.view.backgroundColor = KWhiteColor;
    self.navigationItem.title = @"会议";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark - BarButtonItem selector
- (void)onClickBackItem:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ConferenceInfoView delegate
-(void)onClickAddMoreItem{
    NSLog(@"click more item");
    CWChooseContactController *chooseContactVc = [[CWChooseContactController alloc] initWithChooseContactType:ChooseContactTypeAll existMemberArray:self.conferenceInfoView.currentModel.members andClickRightItemBlock:^(NSArray *selectedArray){
        NSLog(@"select array : %@",selectedArray);
        self.navigationItem.rightBarButtonItem.enabled = selectedArray.count;
        self.conferenceInfoView.currentModel.members = selectedArray;
    }];
    [self.navigationController pushViewController:chooseContactVc animated:YES];
}

-(void)onClickItemWithModel:(CubeUser *)model{
    NSLog(@"click item with cubeId: %@",model.cubeId);
}

-(void)onClickEnterConferenceBtn{
    NSLog(@"click enter conference...");
//    [CDHudUtil showToastWithMessage:@"当前会议未销毁.." duration:5 completion:^{
//
//    }];
//    return;
    [[CubeWare sharedSingleton].conferenceService joinConference:self.conferenceInfoView.currentModel.conference];
}

@end
