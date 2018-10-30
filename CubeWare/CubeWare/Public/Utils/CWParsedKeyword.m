//
//  CWParsedKeyword.m
//  CubeWare
//
//  Created by zhuguoqiang on 17/3/6.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWParsedKeyword.h"

@implementation CWParsedKeyword

- (instancetype)initWithKeyword:(NSString *)keyword
                      withRange:(NSRange)range
                withKeywordType:(CWKeywordType)type
{
    self = [super init];
    if (self) {
        self.keyword = keyword;
        self.range = range;
        self.keywordType = type;
    }
    return self;
}

@end
