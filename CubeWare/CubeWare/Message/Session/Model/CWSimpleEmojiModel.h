//
//  CWSimpleEmojiModel.h
//  CubeWare
//
//  Created by luchuan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,CWSimpleEmojiModelFuncationType){
    CWSimpleEmojiModelTypeUnkonw = -1,
    CWSimpleEmojiModelTypeDefault = 0,
    CWSimpleEmojiModelTypeDelete, //删除
    CWSimpleEmojiModelTypeNil,//空
};


@interface CWSimpleEmojiModel : NSObject
// 简体中文
@property (nonatomic, retain) NSString *chs;
//@property (nonatomic, retain) NSString *cht;

// 图片
@property (nonatomic, retain) NSString *png;

// gif
@property (nonatomic, retain) NSString *gif;

// 类型
@property (nonatomic, retain) NSString *type;

@property (nonatomic, copy) NSString *pngfilePath;

@property (nonatomic, copy) NSString *gifFilePath;
//key值
@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) CWSimpleEmojiModelFuncationType simpleEmojiType;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)simpleEmojiWithDictionary:(NSDictionary *)dict;
@end
