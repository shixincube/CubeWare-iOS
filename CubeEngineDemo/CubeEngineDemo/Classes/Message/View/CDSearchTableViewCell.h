//
//  CDSearchTableViewCell.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/10/24.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDSearchTableViewCell : UITableViewCell

/**
 是否加入
 */
@property (nonatomic,assign) BOOL isJoined;

/**
 群组信息
 */
@property (nonatomic,strong) CubeGroup *group;
@end

NS_ASSUME_NONNULL_END
