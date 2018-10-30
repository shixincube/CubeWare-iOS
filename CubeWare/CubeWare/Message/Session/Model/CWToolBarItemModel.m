//
//  CWToolBarItemModel.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWToolBarItemModel.h"

@implementation CWToolBarItemModel
+(instancetype)toolBarItemModelWithTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage identifier:(NSInteger)tag{
    CWToolBarItemModel * toolBarItemModel = [[CWToolBarItemModel alloc] init];
    toolBarItemModel.title = title;
    toolBarItemModel.image = image;
    toolBarItemModel.selectImage = selectImage ? selectImage : image;
    toolBarItemModel.tag = tag;
    return toolBarItemModel;
}
@end
