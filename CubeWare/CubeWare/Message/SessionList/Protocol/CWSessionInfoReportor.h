//
//  CWSessionInfoReportor.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/14.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 session信息报告器
 */
@protocol CWSessionInfoReportor <NSObject>

/**
 报告会话的未读数量

 @note 当sessionID为空时，每个报告器报告自己的未读数。sessionID不为空时匹配的session报告自己未读数，不匹配的session报告0
 
 @param sessionId 特定的会话ID
 @return 会话未读数量
 */
-(int)reportUnreadCountForSession:(NSString *)sessionId;

@end
