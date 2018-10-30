//
//  CWToolBarItemModel.h
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWToolBarItemModel : NSObject
typedef NS_ENUM(NSInteger, CWToolBarItem){
    CWToolBarItemUnkonw = -2,
    CWToolBarItemVoice = 0,//语音
    CWToolBarItemPicture = 1,//图片
    CWToolBarItemPhoto =2,//拍照
    CWToolBarItemFile = 3,//文件
    CWToolBarItemEmoji = 4,//Emoji
    CWToolBarItemMore = 5, //更多
    CWToolBarItemP2PCall,//语音通话
    CWToolBarItemVideo,//视频通话
    CWToolBarItemP2PWhiteBoard,//白板
    CWToolBarItemShakeAt,//抖一抖
    CWToolBarItemGroupCall,//群通话
    CWToolBarItemGroupVideo,//群视频
    CWToolBarItemGroupWhiteBoard,//群白板
    CWToolBarItemGroupTask,//群任务
    CWToolBarItemGroupReferral, // 推荐联系人
    CWToolBarItemGroupApplication, // 群应用
};

/**
 标题
 */
@property (nonatomic, strong) NSString *title;
/**
 默认图片
 */
@property (nonatomic, strong) NSString *image;
/**
 选中图片
 */
@property (nonatomic, strong) NSString *selectImage;
/**
 标志
 */
@property (nonatomic, assign) NSInteger tag;

/**
 选中状态
 */
@property (nonatomic, assign) BOOL isSelect;

+(instancetype)toolBarItemModelWithTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage identifier:(NSInteger )tag;

@end
