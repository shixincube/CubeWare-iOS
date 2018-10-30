//
//  CDDurationPickerModel.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/19.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDDurationPickerModel.h"

@implementation CDDurationPickerModel

-(instancetype)initWithTitle:(NSString *)title andDuration:(NSTimeInterval)duration{
    if (self = [super init]) {
        self.title = title;
        self.duration = duration;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"title : %@ ,duration : %.0lf",self.title,self.duration];
}

@end
