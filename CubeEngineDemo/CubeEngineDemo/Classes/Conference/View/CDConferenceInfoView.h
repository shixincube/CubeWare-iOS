//
//  CDConferenceInfoView.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDConferenceDetailInfoModel.h"

@protocol CDConferenceInfoViewDelegate <NSObject>

/**
 点击更多item
 */
- (void)onClickAddMoreItem;

/**
 点击成员item
 */
- (void)onClickItemWithModel:(CubeUser *)model;


/**
 点击进入会议按钮
 */
- (void)onClickEnterConferenceBtn;

/**
设置按钮是否可用
 */
- (void)setBtnEnable:(BOOL)enable;
@end

typedef enum : NSUInteger {
    ConferenceDetailShowTypeCreate,
    ConferenceDetailShowTypeDetail,
} ConferenceDetailShowType;


@interface CDConferenceInfoView : UIView


@property (nonatomic,weak) id <CDConferenceInfoViewDelegate> delegate;

/**
 会议信息界面详情展示类型 (创建、详情)
 */
@property (nonatomic,assign) ConferenceDetailShowType type;

/**
 @note 如果是展示会议详情需要填入该模型值
 当前会议详情数据模型 (包含 会议主题、会议开始时间、会议时长、会议参加人员)
 */
@property (nonatomic,strong) CDConferenceDetailInfoModel *currentModel;

/**
 初始化方法

 @param type 会议详情展示类型
 @return 会议信息详情
 */
- (instancetype)initWithType:(ConferenceDetailShowType )type;

/**
 刷新成员列表
 */
- (void)reloadMembersCollections;


-(void)hidePlaceHolder:(BOOL )hidden;

@end
