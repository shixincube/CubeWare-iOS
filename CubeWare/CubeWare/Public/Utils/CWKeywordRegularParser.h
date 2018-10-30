//
//  CWKeywordRegularParser.h
//  CubeWare
//
//  Created by zhuguoqiang on 17/3/6.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWParsedKeyword.h"

@interface CWKeywordRegularParser : NSObject

@property (nonatomic, copy) NSString *emojiRegular;

@property (nonatomic, copy) NSString *atRegular;
@property (nonatomic, copy) NSString *atAllRegular;
@property (nonatomic, copy) NSString *facialRegular;
+ (instancetype)currentParser;



- (NSRange)rangeOfLastEmoji:(NSString *)string andRange:(NSRange)textRange;
@end
