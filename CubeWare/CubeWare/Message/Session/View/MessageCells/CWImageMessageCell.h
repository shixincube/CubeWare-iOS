//
//  CWImageMessageCell.h
//  CubeWare
//
//  Created by jianchengpan on 2017/12/28.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWMessageCell.h"

@interface CWImageMessageCell : CWMessageCell

/**图片url*/
@property (nonatomic, copy) NSString *imageUrl;
/**图片*/
@property (nonatomic, strong) UIImage *image;
/**图片尺寸*/
@property (nonatomic, assign) CGSize imageSize;

-(void)initView;

@end
