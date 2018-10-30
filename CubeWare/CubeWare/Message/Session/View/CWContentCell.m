//
//  CWContentCell.m
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWContentCell.h"

@implementation CWContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - CWContentCellProtocol
+(NSString *)reuseIdentifier{
    return NSStringFromClass([self class]);
}

-(void)configUIWithContent:(id)content{
    
}

#pragma mark - cell

+(CGFloat)cellHeigtForContent:(id)content inSession:(CWSession *)session{
    return 0;
}

@end
