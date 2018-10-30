//
//  CWChooseContactCell.h
//  CubeWare
//
//  Created by luchuan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWChooseContactCell : UITableViewCell


@property (nonatomic,strong) CubeUser *member;

@property (nonatomic,assign) BOOL isSelected;

+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
