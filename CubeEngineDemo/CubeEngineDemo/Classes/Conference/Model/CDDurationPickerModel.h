//
//  CDDurationPickerModel.h
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/19.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDDurationPickerModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) NSTimeInterval duration;

- (instancetype) initWithTitle:(NSString *)title andDuration:(NSTimeInterval )duration;

@end
