//
//  CWParseNode.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/8.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWParseNodeType.h"

@interface CWParseNode : NSObject<CubeJSONObject>

@property (nonatomic, assign) CWParseNodeType type;

@property (nonatomic, assign) NSRange range;

@property (nonatomic, copy) NSString *originalText;

@property (nonatomic, strong) NSMutableDictionary *userInfo;

+(CWParseNode *)nodeWithType:(CWParseNodeType)type andRange:(NSRange)range andOriginalText:(NSString *)originalText;

/**
 解析原始消息，获取有用的信息
 */
-(void)prepareUserInfo;

@end
