//
//  CWFacialEmojiModel.h
//  CubeWare
//
//  Created by luchuan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSimpleEmojiModel.h"

@interface CWFacialEmojiModel : CWSimpleEmojiModel
/**
 描述 ：圣诞快乐
 */
@property(nonatomic,strong) NSString * des;
/**
 表情包ID
 */
@property(nonatomic,assign) long ePackageId;
///**
// key
// */
//@property(nonatomic,strong) NSString * emojiKey;
/**
 表情ID
 */
@property(nonatomic,assign) long  emojiID;
/**
 关键字
 */
@property(nonatomic,strong) NSString * keyWorlds;
/**
 前缀名
 */
@property(nonatomic,strong) NSString * prefixName;
/**
 尺寸
 */
@property(nonatomic,assign) long  size;
/**
 缩略图地址
 */
@property(nonatomic,strong) NSString * thumbUrl;
/**
 git 图下载地址
 */
@property(nonatomic,strong) NSString * url;

@end
