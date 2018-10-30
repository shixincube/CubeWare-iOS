//
//  CDConferenceCollectionItem.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/7.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConferenceCollectionItem.h"

@interface CDConferenceCollectionItem ()

@end

@implementation CDConferenceCollectionItem

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance{
    self.layer.cornerRadius = self.bounds.size.width / 2.f;
    self.layer.masksToBounds = YES;
    
    self.portraitImage = [[UIImageView alloc] init];
    self.portraitImage.layer.cornerRadius = self.bounds.size.width / 2.f;
    self.portraitImage.layer.masksToBounds = YES;
    
    [self addSubview:self.portraitImage];
    
    [self.portraitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.height));
    }];
}



@end
