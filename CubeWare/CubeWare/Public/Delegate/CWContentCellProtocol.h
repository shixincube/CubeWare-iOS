//
//  CWMessageContentProtocol.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/27.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSession.h"

/**
 消息内容cell协议
 */
@protocol CWContentCellProtocol <NSObject>

/**
 重用标志

 @return 重用标志符
 */
+(NSString *)reuseIdentifier;

/**
 获取指定内容在指定会话里面cell的高度
 
 @param content 待显示的内容
 @param session 会话(可空,在会话中才会有session)
 @return cell高度
 */
+(CGFloat)cellHeigtForContent:(id)content inSession:(CWSession *)session;

/**
 使用内容配置UI

 @param content 内容
 */
-(void)configUIWithContent:(id)content;

@end
