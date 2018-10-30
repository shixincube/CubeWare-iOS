//
//  CDCreateConferenceViewController.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDCreateConferenceViewController.h"
#import "CDSelectContactsViewController.h"
#import "CDConferenceInfoView.h"
#import "CWChooseContactController.h"

@interface CDCreateConferenceViewController () <CDConferenceInfoViewDelegate,CWConferenceServiceDelegate>

@property (nonatomic,strong) CDConferenceInfoView *conferenceInfoView;

@end

@implementation CDCreateConferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeAppearance];
    [self initializeDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CDConferenceInfoView *)conferenceInfoView{
    if (!_conferenceInfoView) {
        _conferenceInfoView = [[CDConferenceInfoView alloc] initWithType:ConferenceDetailShowTypeCreate];
        _conferenceInfoView.delegate = self;
    }
    return _conferenceInfoView;
}

- (void)initializeAppearance{
    self.view.backgroundColor = KWhiteColor;
    self.navigationItem.title = @"创建会议";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage  imageNamed:@"img_return_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem:)];
    rightItem.tintColor = RGBA(33, 33, 33, 1.f);
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.conferenceInfoView];
    [self.conferenceInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (void)initializeDataSource{
    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate)]];
}

#pragma mark - BarButtonItem selector
- (void)onClickBackItem:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickRightItem:(UIBarButtonItem *)sender{
    [self.conferenceInfoView endEditing:YES];
//    NSLog(@"Create conference click finish...");
    NSString *conferenceTheme = self.conferenceInfoView.currentModel.conferenceTheme.length ? self.conferenceInfoView.currentModel.conferenceTheme : @"会议";
    conferenceTheme = self.conferenceInfoView.currentModel.conferenceTheme;
    
    NSMutableArray *invites = [NSMutableArray array];
    for (CubeUser *member in self.conferenceInfoView.currentModel.members) {
        [invites addObject:member.cubeId];
    }
    
    CubeConferenceConfig *config = [[CubeConferenceConfig alloc] initWithGroupType:CubeGroupType_Video_Conference withDisplayName:conferenceTheme];
    config.maxMember = 9;
    NSTimeInterval startTime = [self.conferenceInfoView.currentModel.conferenceBeginDate timeIntervalSince1970] * 1000;
    config.startTime = startTime;
    config.duration = self.conferenceInfoView.currentModel.conferenceDuration;
    config.autoNotify = YES;
    config.invites = invites;
    config.isMux = YES;
    [[CubeEngine sharedSingleton].conferenceService createConferenceWithConfig:config];
}

#pragma mark - ConferenceInfoView delegate
-(void)onClickAddMoreItem{
    NSLog(@"click more item");
    CWChooseContactController *chooseContactVc = [[CWChooseContactController alloc] initWithChooseContactType:ChooseContactTypeAll existMemberArray:self.conferenceInfoView.currentModel.members andClickRightItemBlock:^(NSArray *selectedArray){
        NSLog(@"select array : %@",selectedArray);
//        self.navigationItem.rightBarButtonItem.enabled = selectedArray.count;
        self.conferenceInfoView.currentModel.members = selectedArray;
        [self.conferenceInfoView reloadMembersCollections];
    }];
    [self.navigationController pushViewController:chooseContactVc animated:YES];
}

- (void)setBtnEnable:(BOOL)enable
{
    self.navigationItem.rightBarButtonItem.enabled = enable;
}

-(void)onClickItemWithModel:(CubeUser *)model{
    NSLog(@"click item with cubeId: %@",model.cubeId);
}

#pragma mark - CWConferenceDelegate
- (void)createConference:(CubeConference *)conference byUser:(CubeUser *)user{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([user.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

@end
