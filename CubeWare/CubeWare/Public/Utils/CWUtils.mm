//
//  CWUtils.m
//  CubeWare
//  Copyright © 2017年 shixinyun. All rights reserved.

#import "CWUtils.h"
#import "CWProgressHudTool.h"
@implementation CWUtils

+ (NSString *)conferenceErrorWithCode:(CubeErrorType)code
{
    NSString *desc = nil;
    switch (code) {
//        case CubeStateConferenceAlreadyExist:
//            desc = @"会议已存在";
//            break;
//
//        case CubeStateConferenceOverMaxNumber:
//            desc = @"会议人数已达上限";
//            break;
//
//        case CubeStateConferenceRejectByOther:
//            desc = @"会议被其他终端拒绝";
//            break;
//
//        case CubeStateConferenceJoinFromOther:
//            desc = @"您已在其他终端参会";
//            break;
//
//        case CubeStateConferenceJoinFailed:
//            desc = @"加入会议失败";
//            break;
//
//        case CubeStateConferenceRejectFailed:
//            desc = @"拒绝会议失败";
//            break;
//
//        case CubeStateConferenceAlreadyClosed:
//            desc = @"会议已结束";
//            break;
//
//        case CubeStateConferenceApplyError:
//            desc = @"申请会议出错";
//            break;
//
//            break;
//        case CubeStateConferenceApplyJoinError:
//            desc = @"申请加入会议出错";
//            break;
//
//        case CubeStateConferenceCloseError:
//            desc = @"申请关闭会议出错";
//            break;
//
//        case CubeStateConferenceInviteError:
//            desc = @"会议邀请出错";
//            break;
//
//        case CubeStateConferenceRejectError:
//            desc = @"会议拒绝出错";
//            break;
//
//        case CubeStateConferenceQueyAllError:
//            desc = @"查询全部会议出错";
//            break;
//
//        case CubeStateConferenceJoinError:
//            desc = @"加入会议出错";
//            break;
//
//        case CubeStateConferenceQuitError:
//            desc = @"退出会议出错";
//            break;
//
//        case CubeStateConferenceQueyError:
//            desc = @"查询会议出错";
//            break;
//        case AlreadyInCalling:
//            desc = @"您已在其他设备通话中，暂时无法操作";
//            break;
//        case CubeStateFormatError:
//            desc = @"正在通话中...";
//            break;
//        case CubeStateICEConnectionDisConnected:
//            desc = @"网络异常，通话中断。";
//            break;
			
        default:
            desc = [NSString stringWithFormat:@"多人会议未知错误: %d", code];
            break;
    }
    return desc;
}


+ (NSString *)fileExtensionFromFileName:(NSString *)fileName {
    NSRange range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound)
    {
        NSUInteger local = range.location + 1;
        NSUInteger length = fileName.length - range.location - 1;
        NSString *subStr = [fileName substringWithRange:NSMakeRange(local, length)];
        return subStr.lowercaseString;
    }
    return nil;
}
+ (void)showLoadingHud
{
    [CWProgressHudTool showProgressHudWithStyle:CWProgressHudStyleRonateIndicator];
}

+ (void)hideLoadingHud
{
    [CWProgressHudTool hideCureentProgressHud];
}

+ (CGFloat)heigthWithwidth:(CGFloat)width font:(CGFloat)font andTitle:(NSString *)title
{

    NSString * str =title ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];

    return rect.size.height;
}

+ (CGFloat)widthWithheight:(CGFloat)height font:(CGFloat)font andTitle:(NSString *)title
{

    NSString * str =title ;
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;

}


+ (UIImage *)scaleAndRotateImage:(UIImage *)image maxResolution:(int)maxResolution{
    int kMaxResolution = maxResolution;

    CGImageRef imgRef = image.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);


    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    CGImageRelease(imgRef);
    return imageCopy;
}
/**计算图片尺寸*/
+ (CGSize)resizeImageSize:(CGSize)originalSize withLimit:(CGFloat)limit
{
    CGFloat max = MAX(originalSize.width, originalSize.height);
    if (max < limit){
        return originalSize;
    }
    CGSize imgSize;
    CGFloat ratio = originalSize.height / originalSize.width;
    if (originalSize.width > originalSize.height){
        imgSize = CGSizeMake(limit, limit*ratio);
    }else{
        imgSize = CGSizeMake(limit/ratio, limit);
    }
    return imgSize;
}

+ (NSString *)fileNameFromCurrentDate
{
    NSDateFormatter *inFormat = [NSDateFormatter new];
    [inFormat setDateFormat:@"MMdd-HHmmss"];
    NSString *dateStr = [inFormat stringFromDate:[NSDate date]];
    return dateStr;
}

+ (NSData *)compressImageData:(UIImage *)image isOriginal:(BOOL)isOriginal
{
    image = [CWUtils scaleAndRotateImage:image maxResolution:4032];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    if (!imageData)
    {
        imageData = UIImagePNGRepresentation(image);
    }
    else
    {
        if(isOriginal)
        {
            //原图
            if(imageData.length <= 100 * 1024 *20)//大小限制在20M
            {
                imageData = UIImageJPEGRepresentation(image, 1);
            }
            else
            {
                int i = 0;
                while (imageData.length > 100*1024*20 && i < 10) {
                    imageData =UIImageJPEGRepresentation(image, 0.8);
                    i+=1;
                }
            }
        }
        else
        {
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
    }
    return imageData;
}

+ (UIWindow *)CWKeyWindow
{
    UIWindow * CWWindow = [[UIApplication sharedApplication].delegate window];
    return  CWWindow;
}

+ (NSString *)replaceUnicode020eCharOfString:(NSString *)originStr
{
    unichar ellipsis = 0x202e;
    NSString *theString = [NSString stringWithFormat:@"%C", ellipsis];
    NSString *string = nil;
    if ([originStr containsString:theString]) {
        NSArray *array = [originStr componentsSeparatedByString:theString];
        string = [array componentsJoinedByString:@""];
        
    } else {
        string = originStr;
    }
    return string;
}

+ (BOOL)is24HourSystem{
    NSString *formatStringForHours=[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA=[formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM=containsA.location!=NSNotFound;
    return !hasAMPM;
}
+ (NSString *)subFolderAtDocumentWithName:(NSString *)name
{
    NSString *path = nil;
    NSString *docDirPath = [CWUtils documentDirectoryPath];
    if (name) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *subFolder = [docDirPath stringByAppendingPathComponent:name];
        NSError *error = nil;
        [fileManager createDirectoryAtPath:subFolder
               withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        } else {
            path = subFolder;
        }
    }
    return path;
}

+ (NSString *)documentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

+ (NSString *)stringForamtWithFileSize:(long long)filesize {
    NSString *size;
    float oneKb = 1024.0;
    float oneMb = 1024 * oneKb;
    float oneGb = 1024 * oneMb;
    if (0 < filesize && filesize < oneKb) {
        size = [NSString stringWithFormat:@"%lld B", filesize ];
    } else if (oneKb < filesize && filesize < oneMb) {
        size = [NSString stringWithFormat:@"%.0f KB", filesize / oneKb];
    } else if (oneMb <= filesize && filesize < oneGb) {
        size = [NSString stringWithFormat:@"%.2f MB", filesize / oneMb];
    } else if (oneGb <= filesize && filesize < oneGb * 1024) {
        size = [NSString stringWithFormat:@"%.2f GB", filesize / oneGb];
    }else {
        size = @"0 KB";
    }
    return size;
}



+ (NSString *)showTime:(NSTimeInterval)msglastTime showDetail:(BOOL)showDetail is24HourSystem:(BOOL)is24HourSystem
{
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    //    double OnedayTimeIntervalValue = 24*60*60;  //一天的秒数
    result = is24HourSystem ? @"" : [CWUtils getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    if (!is24HourSystem && hour == 0) {
        hour = 12;
    }
    if (hour > 12)
    {
        hour = is24HourSystem? hour : hour - 12;
    }
    if(nowDateComponents.year == msgDateComponents.year
       && nowDateComponents.month == msgDateComponents.month
       && nowDateComponents.day == msgDateComponents.day) //同一天,显示时间
    {
        result = is24HourSystem ? [[NSString alloc] initWithFormat:@"%@ %02zd:%02d",result,hour,(int)msgDateComponents.minute] : [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute];
    }
    else if(nowDateComponents.year == msgDateComponents.year
            && nowDateComponents.month == msgDateComponents.month
            && nowDateComponents.day == (msgDateComponents.day+1))//昨天
    {
        result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天";
    }
    //    else if(nowDateComponents.year == msgDateComponents.year
    //            && nowDateComponents.month == msgDateComponents.month
    //            && nowDateComponents.day == (msgDateComponents.day+2)) //前天
    //    {
    //        result = showDetail? [[NSString alloc] initWithFormat:@"前天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"前天";
    //    }
    //    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//一周内
    //    {
    //        NSString *weekDay = [CWUtils weekdayStr:msgDateComponents.weekday];
    //        result = showDetail? [weekDay stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : weekDay;
    //    }
    else//显示日期
    {
        NSString *day = nil;
        if (showDetail) {
            day = [NSString stringWithFormat:@"%zd年%zd月%zd日", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        } else {
            day = [NSString stringWithFormat:@"%zd/%zd/%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        }
        result = showDetail? [day stringByAppendingFormat:@" %@%zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
    }
    return result;
}


+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time *60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin >= 0 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin<= (23 * 60 + 59))
    {
        showPeriodOfTime = @"下午";
    }
    else {
        showPeriodOfTime = @"";
    }
    
    return showPeriodOfTime;
}

+ (CGRect)rectWithImageRect:(CGRect)imgRect ratio:(float)ratio inBounds:(CGRect)bounds
{
    CGFloat widthRatio = bounds.size.width / imgRect.size.width;
    CGFloat heightRatio = bounds.size.height / imgRect.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    if (ratio < 0 || ratio > 1) {
        ratio = 1.0;
    }
    int width = scale * imgRect.size.width * ratio;
    int height = scale * imgRect.size.height * ratio;
    int x = (bounds.size.width - width) / 2;
    int y = (bounds.size.height - height) / 2;
    CGRect rect = CGRectMake(x, y, width, height);
    return rect;
}

+ (NSString *)convertToTime:(long long)time{
    NSString *timeStr = @"";
    if(time < 3600){
        timeStr =  [NSString stringWithFormat:@"%02lld:%02lld",time/60,time%60];
    }else{
        timeStr = [NSString stringWithFormat:@"%02lld:%02lld:%02lld",time/3600,(time%3600)/60,(time%3600)%60];
    }
    return timeStr;
}

+(NSString *)getImageWithFileName:(NSString *)fileName {
    NSString *fileType = [CWUtils fileExtensionFromFileName:fileName];
    NSString *imageName;
    if ([fileType isEqualToString:@"jpg"]
        || [fileType isEqualToString:@"jpeg"]||[fileType isEqualToString:@"png"]||[fileType isEqualToString:@"gif"]) {
        imageName = @"img_file_picture.png";
    } else if ([fileType isEqualToString:@"rar"] || [fileType isEqualToString:@"zip"]) {
        imageName = @"img_file_rar.png";
    } else if ([fileType isEqualToString:@"pdf"]) {
        imageName = @"img_file_pdf.png";
    } else if ([fileType isEqualToString:@"txt"]) {
        imageName = @"img_file_txt.png";
    } else if ([fileType isEqualToString:@"doc"]
               || [fileType isEqualToString:@"docx"]) {
        imageName = @"img_file_doc.png";
    } else if ([fileType isEqualToString:@"xls"]
               || [fileType isEqualToString:@"xlsx"]) {
        imageName = @"img_file_xls.png";
    } else if ([fileType isEqualToString:@"ppt"]
               || [fileType isEqualToString:@"pptx"]) {
        imageName = @"img_file_ppt.png";
    } else if ([fileType isEqualToString:@"floder"]) {
        imageName = @"img_file_floder.png";
    } else if ([fileType isEqualToString:@"mp4"]) {
        imageName = @"img_file_video.png";
    } else if ([fileType isEqualToString:@"mp3"]) {
        imageName = @"img_file_music.png";
    } else {
        //未知类型
        imageName = @"img_file_unknow.png";
    }
    return imageName;
}
@end
