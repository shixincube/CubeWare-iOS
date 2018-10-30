//
//  CWSessionViewDataController.h
//  CubeWare
//
//  Created by luchuan on 2018/1/2.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWToolBarItemModel.h"
#import "CWEmojiPackageModel.h"
#import "CWEmojiModel.h"
#import <UIKit/UIKit.h>




@interface CWSessionViewDataConfig : NSObject


/**
 1对1通话的键盘工具栏

 @return CWToolBarItemModel 数组，包含所有（包括下层的）的按钮
 */
+ (NSArray<CWToolBarItemModel *> *)getP2PBarItem;
/**
 群组通话的键盘工具栏

 @return CWToolBarItemModel 数组，包含所有（包括下层的）的按钮
 */
+ (NSArray<CWToolBarItemModel *> *)getGroupBarItem;
/**
 获取工具栏Item

 @return CWToolBarItemModel 数组
 */
+(NSArray<CWToolBarItemModel *> *)getToolBarItem;
/**
 更多按钮

 @return CWToolBarItemModel
 */
+ (CWToolBarItemModel *)moreToolBarItem;

/**
 获取表情键盘数据

 @return 包含所有表情的数据模型
 */
+(NSArray<CWEmojiPackageModel *> *)getSystemEmojiPackageModelArr;

/**
  图片消息的处理逻辑

 @param assets  已选图片数组
  @param photos 图片
 @param isOriginal 是否为原图
 @param block 回调
 */
+(void)sendImage:(NSArray *)assets photos:(NSArray<UIImage *> *)photos andIsOriginal:(BOOL)isOriginal andBlock:(void (^)(NSData *imageData  ,NSData *thumbImageData , NSString *name ,CGSize size))block;
+(void)sendImageN:(NSArray *)assets  andIsOriginal:(BOOL)isOriginal andBlock:(void (^)(NSData *imageData  ,NSData *thumbImageData , NSString *name ,CGSize thumbSize,bool isFile))block;
+(void)sendVideo:(NSArray *)assets   andBlock:(void (^)(NSString *filePath  ,NSString *thumbPath ,long long duration ,NSString *fileFame ,CGSize thumbSize))block;
@end
