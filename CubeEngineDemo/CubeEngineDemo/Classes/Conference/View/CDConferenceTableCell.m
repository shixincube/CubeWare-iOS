//
//  CDConferenceTableCell.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/5.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConferenceTableCell.h"

@interface CDConferenceTableCell ()

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *nameLabel;

@end


@implementation CDConferenceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeAppearance];
    }
    return self;
}


- (void)initializeAppearance{
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text = @"08/02 10:00 ~ 12:00";
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"部门例会";
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.bottom.equalTo(self).offset(-5);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    

//    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 7.0f;
    self.layer.masksToBounds = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为10;
    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    
    static CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    frame.origin.y += margin;
    frame.size.height -= margin * 2;
    
    [super setFrame:frame];
}

-(void)setModel:(CDConferenceDetailInfoModel *)model{
    _model = model;
    self.nameLabel.text = model.conferenceTheme;
    self.dateLabel.text = model.conferenceBeginDateFormatString;
}

@end
