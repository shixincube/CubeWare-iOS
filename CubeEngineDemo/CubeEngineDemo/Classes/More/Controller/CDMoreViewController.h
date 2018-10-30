//
//  CDMoreViewController.h
//  CubeWare
//
//  Created by Zeng Changhuan on 2018/8/21.
//  Copyright © 2018年 Zeng Changhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CDMoreViewDelegate <NSObject>

/**
 选择了

 @param selectedIndex index
 */
-(void)didSelectedIndex:(NSInteger)selectedIndex;
@end

@interface CDMoreViewController : UIViewController
@property (nonatomic,weak) id <CDMoreViewDelegate> delegate;
@end
