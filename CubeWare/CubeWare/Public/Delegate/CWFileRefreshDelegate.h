//
//  CWFileRefreshDelegate.h
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/13.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CubeMessageEntity;

@protocol CWFileRefreshDelegate <NSObject>
@optional


/**
 显示接收文件进度时此方法被回调
 
 @param message 当前收到的消息实例
 @param processed 文件传输进度
 @param total 文件总大小
 */
- (void)fileMessageDownloading:(CubeMessageEntity *)message withProcessed:(long long)processed withTotal:(long long)total;

/**
 文件下载完成

 @param message 当前正在处理的消息
 */
- (void)fileMessageDownLoadComplete:(CubeMessageEntity *)message;
@end
