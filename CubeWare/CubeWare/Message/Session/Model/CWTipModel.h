//
//  CWTipModel.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/8.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int,CWTipType){
	CWTipTypeNormal,			//普通类型，简单显示content内容
	CWTipTypeTimeStamp,		//时间类型提示
	CWTipTypeHistoryNotice,    //提示历史消息
};

@interface CWTipModel : NSObject

@property (nonatomic, assign) CWTipType type;

@property (nonatomic, assign) long long timestamp;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSMutableDictionary *userInfo;

+(CWTipModel *)tipWithType:(CWTipType)type andContent:(NSString *)content andUserInfo:(NSMutableDictionary *)userInfo;

@end
