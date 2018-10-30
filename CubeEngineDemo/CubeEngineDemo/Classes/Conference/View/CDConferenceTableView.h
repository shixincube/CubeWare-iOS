//
//  CDConferenceTableView.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/5.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDConferenceDetailInfoModel.h"

@protocol CDConferenceTableViewDelegate <NSObject>

/**
 选择

 @param model 会议详情
 */
-(void)didSelectCellWithModel:(CDConferenceDetailInfoModel *)model;

@end

@interface CDConferenceTableView : UITableView


@property (nonatomic,strong) NSMutableArray *conferenceDetailModels;
@property (nonatomic,weak) id <CDConferenceTableViewDelegate> selectDelegate;

- (void)syncConferenceList;

@end
