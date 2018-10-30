//
//  CDUserInfoViewController.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDLoginAccountModel.h"
@interface CDUserInfoViewController : UIViewController

/**
 个人信息
 */
@property (nonatomic,strong) CDLoginAccountModel *user;
@end
