//
//  CDMembersTableViewCell.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDMembersCellDelegate<NSObject>

/**
 点击添加成员
 */
- (void)onClickAddMemberButton;
@end

@interface CDMembersTableViewCell : UITableViewCell
/**
 标题
 */
@property (nonatomic,strong) UILabel *title;
/**
 成员列表
 */
@property (nonatomic,strong) NSArray *dataArray;


/**
 获取cell搞

 @param dataArray 成员列表
 @return 高度
 */
+(CGFloat)getGroupMemberCellHegiht:(NSArray *)dataArray;

@property (nonatomic,weak) id <CDMembersCellDelegate> delegate;
@end
