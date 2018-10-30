//
//  CWChooseContactController.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/27.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ChooseContactTypeAll,   // 选择所有联系人
    ChooseContactTypeGroup, // 选择群组内的联系人
} ChooseContactType;


typedef void(^rightItemBlock)(NSArray *selectedArray);

@interface CWChooseContactController : UIViewController


/**
 选择联系人类型 (群组类型、全成员类型)
 */
@property (nonatomic,assign) ChooseContactType chooseContactType;

/**
 群组类型选择 填入groupId
 */
@property (nonatomic,strong) NSString *groupId;


/**
 初始化方法

 @param type 选择类型人类型,按照以上定义枚举
 @param block 点击选择完成时的操作
 @return 控制器实例
 */
- (instancetype)initWithChooseContactType:(ChooseContactType )type
                         existMemberArray:(NSArray *)existMembers
                   andClickRightItemBlock:(void(^)(NSArray *selectedArray))block;



@end
