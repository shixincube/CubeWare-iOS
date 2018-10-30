//
//  CWFileTableViewCell.h
//  CubeWare
//
//  Created by Mario on 17/2/10.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWFileTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *selectedImgView;

@property (nonatomic,strong) UIButton *selectedButton;

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *sizeLabel;

- (void)refresh;
@end
