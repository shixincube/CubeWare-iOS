//
//  CWTipModel.m
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/8.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWTipModel.h"

@implementation CWTipModel

+(CWTipModel *)tipWithType:(CWTipType)type andContent:(NSString *)content andUserInfo:(NSMutableDictionary *)userInfo{
	CWTipModel *model = [CWTipModel new];
	model.type = type;
	model.content = content;
	model.userInfo = userInfo;
	return model;
}

@end
