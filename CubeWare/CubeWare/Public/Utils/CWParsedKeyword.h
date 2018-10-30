//
//  CWParsedKeyword.h
//  CubeWare
//
//  Created by zhuguoqiang on 17/3/6.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CWKeywordType {
    CWKeywordTypeText = 0,      // text
    CWKeywordTypeEmoji = 1,     // 表情
    CWKeywordTypeAt = 2,        // @
    CWKeywordTypeAtAll = 3,        // @all
    CWKeywordTypeFacial = 4,        //自定义表情
} CWKeywordType;

/**
 * 关键词
 */
@interface CWParsedKeyword : NSObject

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) CWKeywordType keywordType;
@property (nonatomic, strong) NSTextCheckingResult *result;

- (instancetype)initWithKeyword:(NSString *)keyword
                      withRange:(NSRange)range
                withKeywordType:(CWKeywordType)type;

@end
