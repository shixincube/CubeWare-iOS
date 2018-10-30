//
//  CWEmojiModel.h
//  CubeWare
//
//  Created by luchuan on 2018/2/1.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger ,CWEmojiModelFunctionType){
    CWEmojiModelFunctionTypeDefault, // 默认
    CWEmojiModelFunctionTypeAdd, //添加
    CWEmojiModelFunctionTypeDelete, // 删除
    CWEmojiModelFunctionTypeNil, // 空
};
typedef NS_ENUM(NSInteger ,CWEmojiModelType) {
    CWEmojiModelTypeDefault, //默认
    CWEmojiModelTypeSystemEmoji, // 系统表情
    CWEmojiModelTypeRecent, // 最近表情
    CWEmojiModelTypeCollection, // 收藏
    CWEmojiModelTypeFacial, //贴图表情
};

@interface CWEmojiModel : NSObject


/**
 名字
 */
@property (nonatomic,strong) NSString *name;
/**
 缩略图名字
 */
@property (nonatomic,strong) NSString *thumbName;
/**
 文件名字
 */
@property (nonatomic,strong) NSString *fileName;
/**
 缩略图存放地址
 */
@property (nonatomic,strong) NSString *thumbPath;
/**
 文件地址
 */
@property (nonatomic,strong) NSString *filePath;
/**
 key
 */
@property (nonatomic,strong) NSString *key;

/**
 功能类型
 */
@property (nonatomic, assign) CWEmojiModelFunctionType funcationType;
/**
 表情类型
 */
@property (nonatomic, assign) CWEmojiModelType emojiType;
@end
