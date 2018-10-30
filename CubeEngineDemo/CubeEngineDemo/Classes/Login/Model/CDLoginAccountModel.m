//
//  CDLoginAccountModel.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/8/29.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDLoginAccountModel.h"

@implementation CDLoginAccountModel  


#pragma mark - CubeJsonObject

+ (id)fromDictionary:(NSDictionary *)dic {
    return [CubeJsonUtil generateObjectOfClass:self fromDictionary:dic];
}

- (NSMutableDictionary *)toDictionary {
    return [CubeJsonUtil translateObjectToDictionay:self];
}

+(NSDictionary *)keysMap{
    NSMutableDictionary *dic = [@{
                                  @"avatar":@[@"avator"],
                                  } mutableCopy];
    return dic;
}

-(void)setValue:(id)value forProperty:(NSString *)property{
    id newValue = value;
    if ([property isEqualToString:@"cubeId"]) {
        
        newValue = [NSString stringWithFormat:@"%ld",((NSNumber *)value).integerValue];
    }
    [self setValue:newValue forKey:property];
}




@end
