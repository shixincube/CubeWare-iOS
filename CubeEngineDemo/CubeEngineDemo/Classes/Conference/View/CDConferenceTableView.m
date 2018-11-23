//
//  CDConferenceTableView.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/5.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConferenceTableView.h"
#import "CDConferenceTableCell.h"


#define CellIdentify @"conferenceCell"

@interface CDConferenceTableView () <UITableViewDelegate,UITableViewDataSource>

@end


@implementation CDConferenceTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self initializeSetup];
    }
    return self;
}


- (void)initializeSetup{
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[CDConferenceTableCell class] forCellReuseIdentifier:CellIdentify];
    self.sectionFooterHeight = 0.01f;
    self.sectionHeaderHeight = 0.01f;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.conferenceDetailModels = [NSMutableArray array];
//    self.contentInset = UIEdgeInsetsMake(5, 0, 0, 5);
}

#pragma mark - sync conference lists
-(void)syncConferenceList{
    [[CubeEngine sharedSingleton].conferenceService queryConferenceWithCubeId:nil ConferenceType:CubeGroupType_Video_Conference | CubeGroupType_Voice_Conference completion:^(NSArray *conferences) {
//        NSLog(@"sync conference result is :%@ ",conferences);
        [self.conferenceDetailModels removeAllObjects];
        for (CubeConference *conference in conferences) {
            CDConferenceDetailInfoModel *detailModel = [[CDConferenceDetailInfoModel alloc] init];
            NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:(conference.startTime) / 1000];
            detailModel.conferenceBeginDate = beginDate;
            detailModel.conferenceDuration = conference.duration;
            detailModel.conferenceTheme = conference.displayName;
            detailModel.members = conference.invites;
            detailModel.conference = conference;
            [self.conferenceDetailModels addObject:detailModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    } failure:^(CubeError *error) {
//        NSLog(@"demo sync conference failed with error : %@ ",error);
    }];
}

#pragma mark - tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conferenceDetailModels.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDConferenceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify forIndexPath:indexPath];
    cell.model = self.conferenceDetailModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(didSelectCellWithModel:)]) {
        CDConferenceDetailInfoModel *model = self.conferenceDetailModels[indexPath.row];
        [self.selectDelegate didSelectCellWithModel:model];
    }
}

@end
