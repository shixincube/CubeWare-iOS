//
//  UIImage+CubeWare.h
//  CubeWare
//
//  Created by Mario on 17/1/16.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NCubeWare)

+ (UIImage *)cw_fetchImage:(NSString *)imageNameOrPath;

+ (UIImage *)cw_fetchChartlet:(NSString *)imageName chartletId:(NSString *)chartletId;

+ (CGSize)cw_sizeWithImageOriginSize:(CGSize)originSize
                              minSize:(CGSize)imageMinSize
                              maxSize:(CGSize)imageMaxSize;

//+ (UIImage *)cw_imageInKit:(NSString *)imageName;

+ (UIImage *)cw_emoticonInKit:(NSString *)imageName;

+ (UIImage *)imageFromBundleWithName:(NSString *)name;

- (UIImage *)cw_imageForAvatarUpload;

/**
 *  得到图像显示完整后的frame
 */
- (CGRect)cw_getBigImageRectSizeWithBounds:(CGRect)bounds;

- (UIImage *)normalizedImage;
@end
