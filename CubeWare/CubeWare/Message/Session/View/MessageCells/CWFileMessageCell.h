//
//  CWFileMessageCell.h
//  CubeWare
//
//  Created by jianchengpan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWMessageCell.h"

@interface CWFileMessageCell : CWMessageCell

/**文件图标url*/
@property (nonatomic, copy) NSString *iconUrl;
/**文件图标图片*/
@property (nonatomic, strong) UIImage *iconImage;
/**文件名*/
@property (nonatomic, strong) NSString *title;
/**文件大小(byte)*/
@property (nonatomic, assign) long long filesize;


@end
