//
//  CWContentCellDatasourceDelegate.h
//  SPCubeWareDev
//
//  Created by jianchengpan on 2018/4/2.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWContentCellProtocol.h"

@protocol CWContentCellDatasourceDelegate <NSObject>

@optional
/**
 获取指定内容的cell
 
 @param content 待显示的内容
 @return 遵守了内容协议的cell的类,返回空,则使用内置cell
 */
-(Class<CWContentCellProtocol>)cellClassForContent:(id)content;

@end
