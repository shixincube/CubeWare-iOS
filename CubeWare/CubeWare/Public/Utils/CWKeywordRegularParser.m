//
//  CWKeywordRegularParser.m
//  CubeWare
//
//  Created by zhuguoqiang on 17/3/6.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWKeywordRegularParser.h"
#import "CWUtils.h"
#import "CubeWareHeader.h"
@implementation CWKeywordRegularParser

+ (instancetype)currentParser
{
    static CWKeywordRegularParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CWKeywordRegularParser alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _emojiRegular = CUBE_WARE_EMOJ_REGULAR;
        _atRegular = CUBE_WARE_AT_REGULAR;
        _atAllRegular = CUBE_WARE_ATALL_REGULAR;
        _facialRegular = CUBE_WARE_FACIAL_REGULAR;
    }
    return self;
}
- (NSRange)rangeOfLastEmoji:(NSString *)string andRange:(NSRange)textRange
{
    NSRange range = NSMakeRange(0, 0);
    NSError *error;
    NSRegularExpression *AtRegex = [NSRegularExpression regularExpressionWithPattern:_emojiRegular options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *array = [AtRegex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, textRange.location)];
    if (array) {
        NSTextCheckingResult *lastResult = array.lastObject;
        range = lastResult.range;
    }
    return range;
}

@end
