//
//  CDSearchField.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/27.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDSearchFieldDelegate<NSObject>

/**
 搜索框

 @param text 搜索文字
 */
- (void)searchText:(NSString *)text;
@end

@interface CDSearchField : UIView

/**
 代理
 */
@property (nonatomic,weak) id<CDSearchFieldDelegate> delegate;
@end
