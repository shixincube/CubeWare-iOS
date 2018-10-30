//
//  UIImage+CubeWare.m
//  CubeWare
//
//  Created by Mario on 17/1/16.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "UIImage+NCubeWare.h"

#define CWormalImageSize       (1280 * 960)

@implementation UIImage (NCubeWare)

+ (UIImage *)cw_fetchImage:(NSString *)imageNameOrPath{
    UIImage *image = [UIImage imageNamed:imageNameOrPath];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:imageNameOrPath];
    }
    return image;
}


+ (UIImage *)cw_fetchChartlet:(NSString *)imageName chartletId:(NSString *)chartletId{
//    if ([chartletId isEqualToString:NIMKit_EmojiCatalog]) {
//        return [UIImage imageNamed:imageName];
//    }
//    NSString *subDirectory = [NSString stringWithFormat:@"%@/%@/%@",NIMKit_ChartletChartletCatalogPath,chartletId,NIMKit_ChartletChartletCatalogContentPath];
//    //先拿2倍图
//    NSString *doubleImage  = [imageName stringByAppendingString:@"@2x"];
//    NSString *tribleImage  = [imageName stringByAppendingString:@"@3x"];
//    NSString *bundlePath   = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:subDirectory];
//    NSString *path = nil;
//    
//    NSArray *array = [NSBundle pathsForResourcesOfType:nil inDirectory:bundlePath];
//    NSString *fileExt = [[array.firstObject lastPathComponent] pathExtension];
//    if ([UIScreen mainScreen].scale == 3.0) {
//        path = [NSBundle pathForResource:tribleImage ofType:fileExt inDirectory:bundlePath];
//    }
//    path = path ? path : [NSBundle pathForResource:doubleImage ofType:fileExt inDirectory:bundlePath]; //取二倍图
//    path = path ? path : [NSBundle pathForResource:imageName ofType:fileExt inDirectory:bundlePath]; //实在没了就去取一倍图
//    return [UIImage imageWithContentsOfFile:path];
    return  nil;
}


+ (CGSize)cw_sizeWithImageOriginSize:(CGSize)originSize
                              minSize:(CGSize)imageMinSize
                              maxSize:(CGSize)imageMaxSize{
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSize.width,  imageMaxHeight = imageMaxSize.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width/size.height > 3)
        {
            //size.height = imageHeight;
            size.height = imageMinHeight/3*2;
            if (size.height > imageMaxHeight)
            {
                //size.height = imageMaxHeight;
            }
        }
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
        if (originSize.height < imageMinHeight/2) {
            float ratio = size.width / size.height;
            size.height = imageMinHeight/2;
            size.width = size.height * ratio;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight * imageMinWidth / imageWidth;
        if (size.height/size.width > 3)
        {
            //size.width = imageWidth;
            size.width = imageMinWidth/3*2;
            if (size.width > imageMaxWidth)
            {
                //size.width = imageMaxWidth;
            }
        }
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
        if (originSize.width < imageMinWidth/2) {
            float ratio = size.height / size.width;
            size.width = imageMinWidth/2;
            size.height = size.width * ratio;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}

#warning TO:zhangdi
//+ (UIImage *)cw_imageInKit:(NSString *)imageName{
//    NSString *name = [[[CubeWare sharedSingleton] resourceBundleName] stringByAppendingPathComponent:imageName];
//    return [UIImage imageNamed:name];
//}
//
//+ (UIImage *)cw_emoticonInKit:(NSString *)imageName
//{
//    NSString *name = [[[CubeWare sharedSingleton] emoticonBundleName] stringByAppendingPathComponent:imageName];
//    return [UIImage imageNamed:name];
//}

+ (UIImage *)imageFromBundleWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:[@"CubeWareEmoticon.bundle" stringByAppendingPathComponent:name]];
    if (image) {
        return image;
    } else {
        NSString *image_path_string = [NSString stringWithFormat:@"%@%@",@"CubeWareResources.bundle/",name];
        if ([[image_path_string lowercaseString] hasSuffix:@".png"]){
            image_path_string = [image_path_string substringWithRange:NSMakeRange(0,image_path_string.length - 4)];
            image_path_string = [NSString stringWithFormat:@"%@@2x",image_path_string];
        }
        NSString *image_path = [[NSBundle mainBundle] pathForResource:image_path_string ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:image_path];
        return image;
    }
}

- (UIImage *)cw_imageForAvatarUpload
{
    CGFloat pixels  = CWormalImageSize;
    UIImage * image = [self cw_imageForUpload:pixels];
    return [image cw_fixOrientation];
}
#warning TO:zhangdi
//// 得到图像显示完整后的宽度和高度
//- (CGRect)cw_getBigImageRectSizeWithBounds:(CGRect)bounds
//{
//    CGRect imageFrame = CGRectMake(0, 0, self.size.width, self.size.height);
//    CGRect rect = [CWUtils rectWithImageRect:imageFrame ratio:1.0 inBounds:bounds];
//    return rect;
//}

#pragma mark - Private

- (UIImage *)cw_imageForUpload: (CGFloat)suggestPixels
{
    CGFloat maxPixels = 4000000;
    CGFloat maxRatio  = 3;
    CGFloat width = self.size.width;
    CGFloat height= self.size.height;
    //对于超过建议像素，且长宽比超过max ratio的图做特殊处理
    if (width * height > suggestPixels &&
        (width / height > maxRatio || height / width > maxRatio))
    {
        return [self cw_scaleWithMaxPixels:maxPixels];
    }
    else
    {
        return [self cw_scaleWithMaxPixels:suggestPixels];
    }
}

- (UIImage *)cw_scaleWithMaxPixels: (CGFloat)maxPixels
{
    CGFloat width = self.size.width;
    CGFloat height= self.size.height;
    if (width * height < maxPixels || maxPixels == 0)
    {
        return self;
    }
    CGFloat ratio = sqrt(width * height / maxPixels);
    if (fabs(ratio - 1) <= 0.01)
    {
        return self;
    }
    CGFloat newSizeWidth = width / ratio;
    CGFloat newSizeHeight= height/ ratio;
    return [self cw_scaleToSize:CGSizeMake(newSizeWidth, newSizeHeight)];
}

//内缩放，一条变等于最长边，另外一条小于等于最长边
- (UIImage *)cw_scaleToSize:(CGSize)newSize{
    CGFloat width = self.size.width;
    CGFloat height= self.size.height;
    CGFloat newSizeWidth = newSize.width;
    CGFloat newSizeHeight= newSize.height;
    if (width <= newSizeWidth &&
        height <= newSizeHeight)
    {
        return self;
    }
    if (width == 0 || height == 0 || newSizeHeight == 0 || newSizeWidth == 0)
    {
        return nil;
    }
    CGSize size;
    if (width / height > newSizeWidth / newSizeHeight)
    {
        size = CGSizeMake(newSizeWidth, newSizeWidth * height / width);
    }
    else
    {
        size = CGSizeMake(newSizeHeight * width / height, newSizeHeight);
    }
    return [self cw_drawImageWithSize:size];
}

- (UIImage *)cw_drawImageWithSize: (CGSize)size{
    CGSize drawSize = CGSizeMake(floor(size.width), floor(size.height));
    UIGraphicsBeginImageContext(drawSize);
    
    [self drawInRect:CGRectMake(0, 0, drawSize.width, drawSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)cw_fixOrientation{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
@end
