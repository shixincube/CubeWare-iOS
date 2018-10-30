//
//  CWChooseContactCell.m
//  CubeWare
//
//  Created by luchuan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWChooseContactCell.h"
#import "CWColorUtil.h"
#import "CWResourceUtil.h"
@interface CWChooseContactCell ()
@property(nonatomic,strong)UIButton * selectedButton;
@property(nonatomic,strong)UIImageView * avatarImagV;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)UIImageView * gradeImageV;
@end
@implementation CWChooseContactCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * IDCell = @"CWChooseContactCell";
    CWChooseContactCell * cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (!cell) {
        cell = [[CWChooseContactCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:IDCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self textData];
    }
    return self;
}
-(void)textData{
//    self.selectedButton.backgroundColor = [UIColor redColor];
//    self.avatarImagV.backgroundColor = [UIColor blueColor];
//    self.nameLab.backgroundColor = [UIColor blackColor];
//    self.gradeImageV.backgroundColor = [UIColor orangeColor];
    self.nameLab.text = @"x";
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //selectedButton
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(self);
        make.left.mas_equalTo(self).offset(7);
        
    }];
    //avatarImagV
    [self.avatarImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self);
        make.left.mas_equalTo(self.selectedButton.mas_right);
    }];
    //nameLab
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.avatarImagV.mas_right).offset(10);
    }];
    //gradeImageV
    [self.gradeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(5);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(18, 15));
    }];
}
#pragma mark - Delegate
#pragma mark - event response
#pragma mark - getters and setters
-(UIButton *)selectedButton{
    if(!_selectedButton){
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:[CWResourceUtil imageNamed:@"img_nochoose_other.png"] forState:UIControlStateNormal];
        [_selectedButton setImage:[CWResourceUtil imageNamed:@"img_choose.png"] forState:UIControlStateSelected];
        [_selectedButton setImage:[CWResourceUtil imageNamed:@"img_choose_disabled.png"] forState:UIControlStateDisabled];
        [self.contentView addSubview:_selectedButton];
    }
    return _selectedButton;
}
-(UIImageView *)avatarImagV {
    if (!_avatarImagV) {
        _avatarImagV = [[UIImageView alloc]init];
        _avatarImagV.layer.cornerRadius = 25;
        _avatarImagV.layer.masksToBounds = YES;
        _avatarImagV.image = [UIImage imageNamed:@"img_square_avatar_male_default"];
        [self.contentView addSubview:_avatarImagV];
    }
    return _avatarImagV;
}
-(UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [[UILabel alloc]init];
        _nameLab.textColor = [CWColorUtil colorWithRGB:0x333333 andAlpha:1];
        _nameLab.font = [UIFont systemFontOfSize:15.f];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLab];
    }
    return  _nameLab;
}
-(UIImageView *)gradeImageV{
    if(!_gradeImageV){
        _gradeImageV = [[UIImageView alloc]init];
        [self.contentView addSubview:_gradeImageV];
    }
    return  _gradeImageV;
}


-(void)setMember:(CubeUser *)member{
    _member = member;
    NSString *displayName = member.displayName;
    if ([displayName isEqualToString:@""]) {
        displayName = member.cubeId;
    }
    self.nameLab.text = displayName;
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.selectedButton.selected = isSelected;
}

@end
