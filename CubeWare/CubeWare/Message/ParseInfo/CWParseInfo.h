//
//  CWParseInfo.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/8.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWParseNode.h"
#import "CWMessageCellConfig.h"

#import <M80AttributedLabel/M80AttributedLabel.h>

#define ParseInfoAttibuteLabelTag 10240 //label的tag值
#define ParseInfoURLColor [UIColor redColor]

@interface CWParseInfo : NSObject<CubeJSONObject>

@property (nonatomic, strong) NSMutableArray<CWParseNode *> *nodes;

#pragma mark - attibuteLabelInfo

@property (nonatomic, strong) M80AttributedLabel *attributeLabel;

@property (nonatomic, assign) CGSize attibuteLabeSize;

/**
 生产富文本字符串,需要的时候生成
 */
-(void)prepairAttibuteLabel;

@end
