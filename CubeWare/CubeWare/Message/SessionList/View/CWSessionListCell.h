//
//  CWSessionListCell.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWContentCellProtocol.h"

@interface CWSessionListCell : UITableViewCell<CWContentCellProtocol>

/**
 头像url，本地文件路径，或者远程资源路径
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 头像图片
 */
@property (nonatomic, copy) UIImage *avatarImage;

/**
 会话名
 */
@property (nonatomic, copy) NSString *sessionName;

/**
 会话摘要信息
 */
@property (nonatomic, copy) NSString *summary;

/**
 显示时间信息
 */
@property (nonatomic, copy) NSString *timeString;

/**
 未读数量
 */
@property (nonatomic, assign) NSInteger unreadCount;

/**
 是否置顶
 */
@property (nonatomic, assign) BOOL isTop;

/**
 会议类型  使用引擎类型 CubeConferenceType
 */
@property (nonatomic, assign) NSString *conferenceType;
@end
