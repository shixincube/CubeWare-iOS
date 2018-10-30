//
//  CWEmojiPackageModel.h
//  CubeWare
//
//  Created by luchuan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger ,CWEmojiPackageType) {
    CWEmojiPackageTypeUnknow,
    CWEmojiPackageTyperecently,//最近表情
    CWEmojiPackageTypeSystemEmoji,//内置表情
    CWEmojiPackageTypeCollection,//收藏
    CWEmojiPackageTypeFromInter,//下载的表情
    
};

@interface CWEmojiPackageModel : NSObject
/**
 packageId: id(long),
 */
@property(nonatomic,assign) long  packageId;
/**
 date: 时间戳(long),
 */
//@property(nonatomic,assign) long  date;
/**
 count: 表情个数(int),
 */
//@property(nonatomic,assign) long  count;
/**
 size: 文件大小KB(int),
 */
//@property(nonatomic,assign) int  size;
/**
 pcBanner: pc详情页横幅,url(String)
 */
//@property(nonatomic,strong) NSString *pcBanner;
/**
 mobileBanner: mobile详情页横幅,url(String)
 */
//@property(nonatomic,strong) NSString *mobileBanner;
/**
 cover: 表情包封面图,url(String)
 */
//@property(nonatomic,strong) NSString *cover;
/**
 chatPanel: 表情包聊天面板图标,url(String)
 */
//@property(nonatomic,strong) NSString *chatPanel;
/**
 name: 表情包的中文名称(String),
 */
@property(nonatomic,strong) NSString *name;
/**
 type: 表情包类型(int),  0 为内置表情，1 为下载的表情
 */
//@property(nonatomic,assign) int  type;

@property (nonatomic, assign) CWEmojiPackageType emojiPackageType;
/**
 索引 
 */
@property (nonatomic, assign) NSInteger index;

/**
 面板图片存放地址
 */
@property (nonatomic, strong) NSString *chatPanelFilePath;

@property (nonatomic, strong) NSArray *emojiModelArr;

@end
