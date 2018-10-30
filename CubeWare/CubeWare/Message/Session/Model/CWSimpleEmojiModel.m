//
//  CWSimpleEmojiModel.m
//  CubeWare
//
//  Created by luchuan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWSimpleEmojiModel.h"
#import "CWEmojiResourceUtil.h"
@implementation CWSimpleEmojiModel


- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)simpleEmojiWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(NSString *)pngfilePath{
    if (_simpleEmojiType == CWSimpleEmojiModelTypeDelete) {
        return [CWEmojiResourceUtil getDeleteImagePath];
    }else if(_simpleEmojiType == CWSimpleEmojiModelTypeDefault && [_type isEqualToString:@"0"]){
        return [CWEmojiResourceUtil getEmojiPngPathWithName:self.png];
    }
    return _pngfilePath;
}
- (NSString *)gifFilePath{
    if (_simpleEmojiType == CWSimpleEmojiModelTypeDefault && [_type isEqualToString:@"0"]) {
         return [CWEmojiResourceUtil getEmojiGifPathWithName:self.gif];
    }
    return _gifFilePath;
}
@end
