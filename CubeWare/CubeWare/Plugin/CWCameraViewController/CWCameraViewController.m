//
//  CWCameraViewController.m
//  CubeWare
//
//  Created by Mario on 17/2/22.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Photos/Photos.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "CWCameraViewController.h"
#import "UIView+NCubeWare.h"
#import "UIImage+NCubeWare.h"
#import "CWUtils.h"
#import "CWMediaService.h"
#import "CWToastUtil.h"
#import "CWResourceUtil.h"
#import "CubeWareHeader.h"
#import "CWProgressLayer.h"
typedef NS_ENUM(NSUInteger, CWDirectionType) {
    CWDirectionTypeOfLeft,
    CWDirectionTypeOfRight,
    CWDirectionTypeOfUp,
    CWDirectionTypeOfDown,
    CWDirectionTypeOfNone
};

#define MAX_VIDEO_DURATION 10

@interface CWCameraViewController () <UIGestureRecognizerDelegate,CWMediaServiceDelegate>{
    float _videoDuration;
    long long _dur;
}
@property (nonatomic, strong) UIButton *shootingButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *transformButton;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *flashlightButton;
@property (nonatomic, strong) UIButton *originalButton;
@property (nonatomic, strong) UILabel *tipLabel;
//@property (nonatomic, assign) BOOL aninationStarted;
@property (nonatomic, strong) UIView *playVideoView;
//@property (nonatomic, strong) CAShapeLayer *circleShapeLayer;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) UIImage *takePictureImage;
@property (nonatomic, strong) UIImageView *maskLayerImageView;
@property (nonatomic, strong) UIImageView *takePictureImageView;
@property (nonatomic, strong) NSURL *assetUrl;
@property (nonatomic, assign) BOOL hasPicture; //判断当前是否拍照或视频录制完成状态
@property (nonatomic, assign) BOOL isOriginal; //判断是否发送原图
@property (nonatomic, assign) CWDirectionType directiontype;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGFloat startVB;
@property (nonatomic, assign) BOOL canTakePic;//是否可以拍照,用于区别按钮长按调用upInside方法
@property (nonatomic, strong) NSTimer *clickTimer;
@property (nonatomic, copy)   NSString *bytes;
@property (nonatomic, strong) CWProgressLayer *progressLayer;


@end

@implementation CWCameraViewController

- (void)setCurrentImageLength:(NSInteger)currentImageLength{
    if (currentImageLength > 0) {
        _currentImageLength = currentImageLength;
    }else{
        _currentImageLength = 0;
    }
}

-(NSInteger)totalImageLength{
    if (_totalImageLength == 0) {
        _totalImageLength = NSIntegerMax;
    }
    return _totalImageLength;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    BOOL ret = [[[CubeEngine sharedSingleton] getMediaService] loadRecordVideoView:self.view WithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight) andCamera:1];
//    if (ret) {
//        NSLog(@"加载拍照界面成功");
//    }else{
//        NSLog(@"加载拍照界面失败");
//    }
    self.view.backgroundColor = [UIColor blackColor];
    [self setUpRecordView];
    [self setUpRecordViewLayOut];
//    [self setUpProgressView];
    [self setUpSendView];
    [self setUpSendViewLayOut];
    [self hideSendView];
//    [self performSelector:@selector(hidesTipLabel:) withObject:nil afterDelay:3.f];
//
//    [CubeWare sharedSingleton].mediaService.mediaServiceDelegate = self;
	
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpRecordView{
    self.shootingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shootingButton.backgroundColor = [UIColor clearColor];
    self.shootingButton.frame = CGRectZero;
//    [self.shootingButton setBackgroundImage:[CWResourceUtil imageNamed:@"img_camera_shooting_default.png"] forState:UIControlStateNormal];
    [self.shootingButton setImage:[CWResourceUtil imageNamed:@"img_camera_shooting_default.png"] forState:UIControlStateNormal];
//    [self.shootingButton setImage:[CWResourceUtil imageNamed:@"img_camera_shooting_sel.png"] forState:UIControlStateSelected];
//    [self.shootingButton setImage:[CWResourceUtil imageNamed:@"img_camera_shooting_sel.png"] forState:UIControlStateFocused];
//    [self.shootingButton setImage:[CWResourceUtil imageNamed:@"img_camera_shooting_sel.png"] forState: UIControlStateHighlighted];
//     [self.shootingButton setImage:[CWResourceUtil imageNamed:@"img_camera_shooting_sel.png"] forState:UIControlStateDisabled];
    self.shootingButton.userInteractionEnabled = YES;
    
    [self.shootingButton addTarget:self action:@selector(shootingButtonDrag:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self.shootingButton addTarget:self action:@selector(shootingButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    //长按事件
    UILongPressGestureRecognizer *longPresGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.shootingButton addGestureRecognizer:longPresGes];
    
    _hasPicture = YES;
    _canTakePic = YES;
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[CWResourceUtil imageNamed:@"img_camera_back_default.png"] forState:UIControlStateNormal];
    [self.backButton setImage:[CWResourceUtil imageNamed:@"img_camera_back_selected.png"] forState:UIControlStateSelected];
    [self.backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.transformButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.transformButton setImage:[CWResourceUtil imageNamed:@"img_camera_transform_default.png"] forState:UIControlStateNormal];
    [self.transformButton setImage:[CWResourceUtil imageNamed:@"img_camera_transform_selected.png"] forState:UIControlStateSelected];
    [self.transformButton addTarget:self action:@selector(transformClick:) forControlEvents:UIControlEventTouchUpInside];
    self.flashlightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self.device lockForConfiguration:nil];
    if ([self.device hasFlash]) {
        if (self.device.flashMode == AVCaptureFlashModeOff) {
            self.device.flashMode = AVCaptureFlashModeOff;
            [self.flashlightButton setImage:[CWResourceUtil imageNamed:@"img_camera_noflashlight_default.png"] forState:UIControlStateNormal];
            [self.flashlightButton setImage:[CWResourceUtil imageNamed:@"img_camera_flashlight_default.png"] forState:UIControlStateSelected];
        } else if (self.device.flashMode == AVCaptureFlashModeOn) {
            self.device.flashMode = AVCaptureFlashModeOn;
            [self.flashlightButton setImage:[CWResourceUtil imageNamed:@"img_camera_flashlight_default.png"] forState:UIControlStateNormal];
            [self.flashlightButton setImage:[CWResourceUtil imageNamed:@"img_camera_noflashlight_default.png"] forState:UIControlStateSelected];
        } else if (self.device.flashMode == AVCaptureFlashModeAuto) {
            self.device.flashMode = AVCaptureFlashModeOff;
            [self.flashlightButton setImage:[CWResourceUtil imageNamed:@"img_camera_noflashlight_default.png"] forState:UIControlStateNormal];
            [self.flashlightButton setImage:[CWResourceUtil imageNamed:@"img_camera_flashlight_default.png"] forState:UIControlStateSelected];
        }
    } else {
        self.flashlightButton.enabled = NO;
    }
    [self.device unlockForConfiguration];

    [self.flashlightButton addTarget:self action:@selector(flashlightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:15.f];
    self.tipLabel.text = @"点击拍照,长按摄像";
    [self.tipLabel sizeToFit];
    
    [self.view addSubview:self.shootingButton];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.transformButton];
    [self.view addSubview:self.flashlightButton];
    [self.view addSubview:self.tipLabel];
}

- (void)setUpRecordViewLayOut{
    CGFloat cameraViewShootingWidth         = 123.f;
    CGFloat cameraViewShootingHeight        = 123.f;
    CGFloat cameraViewShootingCenterX       = UIScreenWidth/2;
    CGFloat cameraViewShootingBottom        = 75.f;
    CGFloat cameraViewBackLeft              = 40.f;
    CGFloat cameraViewBackWidth             = 44.f;
    CGFloat cameraViewTransformRight        = 40.f;
    CGFloat cameraViewTransformWidth        = 44.f;
    CGFloat cameraViewFlashlightLeft        = 22.f;
    CGFloat cameraViewFlashlightTop         = 19.f;
    CGFloat cameraViewFlashlightWidth       = 22.f;
    CGFloat cameraViewTipCenterX            = UIScreenWidth/2;
    CGFloat cameraViewTipBottom             = 22.f;
    
    self.shootingButton.cw_width   = cameraViewShootingWidth;
    self.shootingButton.cw_height  = cameraViewShootingHeight;
    self.shootingButton.cw_centerX = cameraViewShootingCenterX;
    self.shootingButton.cw_bottom  = UIScreenHeight - cameraViewShootingBottom;
    
    self.backButton.cw_width   = cameraViewBackWidth;
    self.backButton.cw_height  = cameraViewBackWidth;
    self.backButton.cw_left    = cameraViewBackLeft;
    self.backButton.cw_centerY = self.shootingButton.cw_centerY + 10.f;
    
    self.transformButton.cw_width   = cameraViewTransformWidth;
    self.transformButton.cw_height  = cameraViewTransformWidth;
    self.transformButton.cw_right   = UIScreenWidth - cameraViewTransformRight;
    self.transformButton.cw_centerY = self.shootingButton.cw_centerY + 10.f;
    
    self.flashlightButton.cw_left   = cameraViewFlashlightLeft;
    self.flashlightButton.cw_top    = cameraViewFlashlightTop;
    self.flashlightButton.cw_width  = cameraViewFlashlightWidth;
    self.flashlightButton.cw_height = cameraViewFlashlightWidth;
    
    self.tipLabel.cw_centerX = cameraViewTipCenterX;
    self.tipLabel.cw_bottom  = self.shootingButton.cw_top - cameraViewTipBottom;
}

//- (void)setUpProgressView{
//    //添加填充圆环
//    self.circleShapeLayer = [[CAShapeLayer alloc]init];
//    self.circleShapeLayer.strokeColor = UIColorFromRGB(0x7a8fdf).CGColor;
//    self.circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
//    self.circleShapeLayer.lineWidth = 9.f;
//    CGFloat ovalRadius = self.shootingButton.cw_width/200*87;
//    self.circleShapeLayer.path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.shootingButton.cw_width/2 - ovalRadius, self.shootingButton.cw_height/2 - ovalRadius, ovalRadius * 2, ovalRadius * 2)].CGPath;
//    self.circleShapeLayer.strokeStart = 0;
//    self.circleShapeLayer.strokeEnd = 0;
//    [self.shootingButton.layer addSublayer:self.circleShapeLayer];
//    self.shootingButton.transform = CGAffineTransformMakeRotation((M_PI * 2) / 4 * 3);
//    _aninationStarted = NO;
//}

-(UIImageView *)maskLayerImageView{
    if (!_maskLayerImageView) {
        _maskLayerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.takePictureImageView.cw_height - 275, self.takePictureImageView.cw_width, 275)];
        [_maskLayerImageView setImage:[CWResourceUtil imageNamed:@"img_masklayer_default"]];
        [_maskLayerImageView setContentMode:UIViewContentModeScaleAspectFill];
        _maskLayerImageView.backgroundColor = [UIColor clearColor];
    }
    return _maskLayerImageView;
}

- (void)setUpSendView{
    self.playVideoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    self.playVideoView.backgroundColor = [UIColor blackColor];
    self.takePictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    self.takePictureImageView.backgroundColor = [UIColor blackColor];
    [self.takePictureImageView setContentMode:UIViewContentModeScaleAspectFit];

    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setImage:[CWResourceUtil imageNamed:@"img_takepicture_cancel_default.png"] forState:UIControlStateNormal];
    [self.cancleButton setImage:[CWResourceUtil imageNamed:@"img_takepicture_cancel_selected.png"] forState:UIControlStateSelected];
    [self.cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleButton.alpha = 0.5f;
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setImage:[CWResourceUtil imageNamed:@"img_takepicture_send_default.png"] forState:UIControlStateNormal];
    [self.sendButton setImage:[CWResourceUtil imageNamed:@"img_takepicture_send_default.png"] forState:UIControlStateSelected];
    [self.sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.alpha = 0.5f;
    
    self.originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.originalButton setImage:[CWResourceUtil imageNamed:@"img_takepicture_original_default.png"] forState:UIControlStateNormal];
    [self.originalButton setImage:[CWResourceUtil imageNamed:@"img_choose.png"] forState:UIControlStateSelected];
    self.originalButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.originalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.originalButton addTarget:self action:@selector(originalClick:) forControlEvents:UIControlEventTouchUpInside];
    _isOriginal = NO;
}

- (void)setUpSendViewLayOut{
    CGFloat cameraViewCancleWidth         = 75.f;
    CGFloat cameraViewCancleHeight        = 75.f;
    CGFloat cameraViewCancleCenterX       = UIScreenWidth/2;
    CGFloat cameraViewCancleBottom        = 75.f;
    
    CGFloat cameraViewSendWidth           = 75.f;
    CGFloat cameraViewSendHeight          = 75.f;
    CGFloat cameraViewSendCenterX         = UIScreenWidth/2;
    CGFloat cameraViewSendBottom          = 75.f;
    
    CGFloat cameraViewOriginalWidth       = 150.f;
    CGFloat cameraViewOriginalHeight      = 25.f;
    CGFloat cameraViewOriginalCenterX     = UIScreenWidth/2;
    CGFloat cameraViewOriginalBottom      = 30.f;
    
    self.cancleButton.cw_width       = cameraViewCancleWidth;
    self.cancleButton.cw_height      = cameraViewCancleHeight;
    self.cancleButton.cw_bottom      = UIScreenHeight - cameraViewCancleBottom;
    self.cancleButton.cw_centerX     = cameraViewCancleCenterX;
    
    self.sendButton.cw_width         = cameraViewSendWidth;
    self.sendButton.cw_height        = cameraViewSendHeight;
    self.sendButton.cw_bottom        = UIScreenHeight - cameraViewSendBottom;
    self.sendButton.cw_centerX       = cameraViewSendCenterX;
    
    self.originalButton.cw_width     = cameraViewOriginalWidth;
    self.originalButton.cw_height    = cameraViewOriginalHeight;
    self.originalButton.cw_bottom    = UIScreenHeight - cameraViewOriginalBottom;
    self.originalButton.cw_centerX   = cameraViewOriginalCenterX;
}

#pragma mark - ButtonClick
- (void)shootingButtonDrag:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.view];
    _startVB = _startVB + point.y;
    _startPoint = point;
    BOOL isIn = CGRectContainsPoint(self.shootingButton.bounds, _startPoint);
    if (!isIn) {
        NSLog(@"pointy:%f",point.y);
        NSLog(@"pointy/top:%f",point.y/self.shootingButton.cw_top);
//       [[[CubeEngine sharedSingleton] getMediaService] slideToScale:self.shootingButton.cw_top / point.y];
    }
}
- (void)shootingButtonTouchUp:(UIButton *)sender{
    [self shootingButtonClick];
}
- (void)shootingButtonClick{
    //点击
    if (_canTakePic) {
        _shootingButton.enabled = NO;
        __weak typeof(self)weakself = self;
//        [[[CubeEngine sharedSingleton] getMediaService] takePictureCompletionHandler:^(UIImage *image, PHAsset *asset) {
//            weakself.takePictureImage = image;
//            //        weakself.assetUrl = assetURL;
//            [weakself hideShootingView];
//            weakself.takePictureImageView.image = image;
//            [weakself.playVideoView addSubview:weakself.takePictureImageView];
//            [weakself.takePictureImageView addSubview:weakself.maskLayerImageView];
//            [weakself.view addSubview:weakself.playVideoView];
//            [weakself.playVideoView addSubview:weakself.cancleButton];
//            [weakself.playVideoView addSubview:weakself.sendButton];
//            [weakself.playVideoView addSubview:weakself.originalButton];
//            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                _bytes = [CWUtils stringForamtWithFileSize:imageData.length];
//                [weakself.originalButton setTitle:@"原图" forState:UIControlStateNormal];
//            }];
//        }];
        if (self.clickTimer){
            [self.clickTimer invalidate];
            self.clickTimer = nil;
        }
        self.type = CWCameraTypeTakePicture;
    }else{
        //松开
//        [[CubeEngine sharedSingleton] getMediaService].shouldScale = NO;
//        if ([[[CubeEngine sharedSingleton] getMediaService] stopRecordVideoWithNeedConvert:self.needTransCode]) {
//            SPLogDebug(@"视频录制结束%f", self.clickTimer.timeInterval);
//            if (self.clickTimer){
//                [self.clickTimer invalidate];
//                self.clickTimer = nil;
//            }
//        }
//        [self resetStroke];
        self.shootingButton.hidden = YES;
        self.backButton.hidden = YES;
        self.transformButton.hidden = YES;
        self.flashlightButton.hidden = YES;
    }
}

- (void)longPress: (UILongPressGestureRecognizer *)longPress
{
    //长按事件
    switch (longPress.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
//            [[CubeEngine sharedSingleton] getMediaService].shouldScale = NO;
//            if ([[[CubeEngine sharedSingleton] getMediaService] stopRecordVideoWithNeedConvert:self.needTransCode]) {
//                SPLogDebug(@"视频录制结束");
//
//            }
            if (self.clickTimer){
                [self.clickTimer invalidate];
                self.clickTimer = nil;
            }
            [self.progressLayer stopAnimation];
            [self.shootingButton setImage:[CWResourceUtil imageNamed:@"img_camera_shooting_default.png"] forState:UIControlStateNormal];
            
        }
            break;
            
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:{
            if (self.clickTimer == nil) {
                self.clickTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(getClickTime:) userInfo:nil repeats:NO];
            }
            [self.shootingButton setImage:[CWResourceUtil imageNamed:@"img_camera_shooting_sel.png"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)backClick:(id)sender{
    //关闭闪光灯
    AVCaptureDevice *device = self.device;
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        device.flashMode = AVCaptureFlashModeOff;
    }
    [device unlockForConfiguration];
//    [[[CubeEngine sharedSingleton] getMediaService] cancelRecordVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)transformClick:(id)sender{
    _transformButton.selected = !_transformButton.selected;

    if (_transformButton.isSelected) {
        _flashlightButton.hidden = YES;
    }else{
        _flashlightButton.hidden = NO;
    }
//    [[[CubeEngine sharedSingleton] getMediaService] switchRecordCamera];
}

- (void)cancleClick:(id)sender{
//    [[[CubeEngine sharedSingleton] getMediaService] removeVideoFile];
    if (self.type == CWCameraTypeTakePicture) {
        [self.takePictureImageView removeFromSuperview];
    }
    _hasPicture = YES;
//    _cancleButton.cw_centerX = UIScreenWidth/2;
//    _sendButton.cw_centerX = UIScreenWidth/2;
    self.cancleButton.alpha = 0.5f;
    self.sendButton.alpha = 0.5f;
    [self.playVideoView removeFromSuperview];
    [self.sendButton removeFromSuperview];
    [self.cancleButton removeFromSuperview];
    [self.originalButton removeFromSuperview];
    [self hideSendView];
    _canTakePic = YES;
}

- (long long)fileDataSizeWithFilePath:(NSString *)filePath {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:filePath error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

- (void)sendClick:(id)sender{
    NSLog(@"点击发送");
    _hasPicture = YES;
    if (self.type == CWCameraTypeTakeVideo) {
//        long long duration = [[CubeEngine sharedSingleton] getMediaService].videoDuration;
//        NSString *videoThumbFilePath = [[[CubeEngine sharedSingleton] getMediaService] getVideothumbImagePath];
//        NSString *videoFilePath = [[[CubeEngine sharedSingleton] getMediaService] getVideoFilePath];
//        if ([[[CubeEngine sharedSingleton] getMediaService] isVideoRecording]){
//            [CWToastUtil showTextMessage:@"视频正在录制不能发送"  andDelay:2];
//        }else{
//            if (duration < 1){
//                [CWToastUtil showTextMessage:@"录制视频时间太短" andDelay:2];
//            }else{
//                if (!videoThumbFilePath){
//                    [CWToastUtil showTextMessage:@"您并未录制视频" andDelay:2];
//                }else{
//                    long long fileSize = [self fileDataSizeWithFilePath:videoFilePath];
//                    //邮件附件大小判断
//                    if (self.currentImageLength + fileSize > self.totalImageLength) {
//                        NSString *tip = [NSString stringWithFormat:@"附件总大小不超过%@", [CWUtils stringForamtWithFileSize:_totalImageLength]];
//                        [CWToastUtil showTextMessage:tip  andDelay:2];
//                        return;
//                    }
//                    if ([self.delegate respondsToSelector:@selector(cameraPickerControllerWithThumbImagePath:andFilePath:andFileName:andVideoDuration:andController:andCameraType:)]) {
//                        [self.delegate cameraPickerControllerWithThumbImagePath:videoThumbFilePath andFilePath:videoFilePath andFileName:nil andVideoDuration:duration andController:self andCameraType:self.type];
//                    }
//                }
//            }
//        }
//        [[[CubeEngine sharedSingleton] getMediaService] stopPlayVideo];
    }else{
        NSString *dateStr = [CWUtils fileNameFromCurrentDate];
        NSString *fileName = [NSString stringWithFormat:@"image-%@.PNG", dateStr];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *testFolder = [CWUtils subFolderAtDocumentWithName:@"CubeEngine/Message/Image"];
        [fileManager createDirectoryAtPath:testFolder withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [testFolder stringByAppendingPathComponent:fileName];
        //写入沙盒
        NSData *imageData = UIImageJPEGRepresentation(_takePictureImage, 0.8);
        //邮件附件大小判断
        if (self.currentImageLength + imageData.length > self.totalImageLength) {
            NSString *tip = [NSString stringWithFormat:@"附件总大小不超过%@", [CWUtils stringForamtWithFileSize:_totalImageLength]];
            [CWToastUtil showTextMessage:tip  andDelay:2];
            return;
        }
        NSData *thumbImageData = nil;
        _takePictureImage = [CWUtils scaleAndRotateImage:_takePictureImage maxResolution:1472];
        CGFloat mult = 0.02;
        if (!_isOriginal)
        {
            if(imageData.length <= 100*1024)
            {
                imageData = UIImageJPEGRepresentation(_takePictureImage, 0.8);
            }
            else
            {
                while (imageData.length > 100*1024 && mult < 50) {
                    imageData = UIImageJPEGRepresentation(_takePictureImage, 0.4);
                    mult += 1;
                }
            }
            thumbImageData = imageData;
        }else{
            thumbImageData = UIImageJPEGRepresentation(_takePictureImage, 0.4);
        }
        
        [imageData writeToFile:filePath atomically:YES];
        
        NSString *imageThumbFolder = [CWUtils subFolderAtDocumentWithName:@"CubeEngine/Message/thumb"];
        NSString *thumbPath = [imageThumbFolder stringByAppendingPathComponent:fileName];
        [thumbImageData writeToFile:thumbPath atomically:YES];
        
        if ([self.delegate respondsToSelector:@selector(cameraPickerControllerWithThumbImagePath:andFilePath:andFileName:andVideoDuration:andController:andCameraType:)]) {
            [self.delegate cameraPickerControllerWithThumbImagePath:thumbPath andFilePath:filePath andFileName:fileName andVideoDuration:0 andController:self andCameraType:self.type];
        }
        
    }
}

- (void)originalClick:(id)sender{
    if (_isOriginal) {
        _isOriginal = NO;
        self.originalButton.selected = NO;
        [self.originalButton setTitle:@"原图" forState:UIControlStateNormal];
    }else {
        _isOriginal = YES;
        self.originalButton.selected = YES;
        [self.originalButton setTitle:[NSString stringWithFormat:@"原图(%@)", _bytes] forState:UIControlStateNormal];
    }
    [UIView showOscillatoryAnimationWithLayer:self.originalButton.layer type:CWOscillatoryAnimationToBigger];
}

- (void)flashlightClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    AVCaptureDevice *device = self.device;
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeOff;
        }
    }
    [device unlockForConfiguration];
}

- (void)hidesTipLabel:(id)sender{
    [UIView animateWithDuration:1.f animations:^{
        self.tipLabel.alpha = 0;
    }];
}

- (void)getClickTime:(NSTimer *)timer{
//    [[CubeEngine sharedSingleton] getMediaService].shouldScale = YES;
//    //[self.shootingButton setBackgroundImage:[CWResourceUtil imageNamed:@"img_camera_shooting_selected.png"] forState:UIControlStateNormal];
//    if ([[[CubeEngine sharedSingleton] getMediaService] startRecordVideo:MAX_VIDEO_DURATION]){
//        SPLogInfo(@"startRecordVideo");
//        //cubeware层不对时长进行记录，在引擎层进行最大时长的控制
//    }
////    [self addAnimation];
//    _canTakePic = NO;
}

#pragma mark - CWMediaServiceDelegate
- (void)onRecordVideoStart:(NSDictionary *)userInfo
{
    [self.progressLayer starAnimation:MAX_VIDEO_DURATION];
}

- (void)onRecordVideoStop:(NSDictionary *)userInfo
{
    NSNumber *typeNum = userInfo[@"type"];
//    if (typeNum.integerValue == VideoRecord) {
//        self.type = CWCameraTypeTakeVideo;
//        if ([[[CubeEngine sharedSingleton] getMediaService] stopRecordVideoWithNeedConvert:self.needTransCode]) {
//            SPLogInfo(@"stopRecordVideo");
//        }
//
//        NSString *filePath = [[[CubeEngine sharedSingleton] getMediaService] getVideoFilePath];
//        SPLogInfo(@"短视频路径%@",filePath);
//
//        if ([[[CubeEngine sharedSingleton] getMediaService] playVideoView:self.playVideoView andFrame:self.playVideoView.frame andVideoFilePath:filePath])
//        {
//            SPLogInfo(@"播放视频成功");
//
////            [self performSelector:@selector(showPlayVideoView) withObject:nil afterDelay:.1f];
//        }
//        else
//        {
//            SPLogInfo(@"播放视频失败");
//            _canTakePic = YES;
//        }
//        [self hideShootingView];
//    }
    [self.progressLayer stopAnimation];
}

- (void)onRecordReadyForDisplay:(NSDictionary *)userInfo
{
//    NSNumber *typeNum = userInfo[@"type"];
//    if (typeNum.integerValue == VideoRecord)
//    {
//        [self showPlayVideoView];
//    }
}

- (void)onRecordVideoFailed:(NSDictionary *)userInfo
{
//    NSNumber *typeNum = userInfo[@"type"];
//    NSNumber *errorSteteNum = userInfo[@"state"];
//    NSString *descString = userInfo[@"descString"];
//    if (typeNum.integerValue == VideoRecord) {
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [self resetStroke];
//
//            NSArray *array = [descString componentsSeparatedByString:@"desc:"];
//            NSString *descString = array.lastObject;
//            //判断一下错误描述是不是过长，过长就直接显示录制失败
//            if(descString && descString.length >=20)
//            {
//                [CWToastUtil showTextMessage:[NSString stringWithFormat:@"录制视频失败"] andDelay:1];
//            }
//            else
//            {
//                [CWToastUtil showTextMessage:[NSString stringWithFormat:@"%@", array.lastObject] andDelay:1];
//            }
////            SPLogInfo(@"onRecordVideoFailed : error code = %ld, desc:%@",errorSteteNum.integerValue,[NSString stringWithFormat:@"%@", array.lastObject]);
////            _cancleButton.cw_centerX = UIScreenWidth/2;
////            _sendButton.cw_centerX = UIScreenWidth/2;
//            self.cancleButton.alpha = 0.5f;
//            self.sendButton.alpha = 0.5f;
//            [self.playVideoView removeFromSuperview];
//            [self.sendButton removeFromSuperview];
//            [self.cancleButton removeFromSuperview];
//            [self.originalButton removeFromSuperview];
//            [self hideSendView];
//
//        });
////        SPLogError(@"录制短视频失败, error = %ld !!!", (long)errorSteteNum.integerValue);
//    }
//    _canTakePic = YES;
//    [self.progressLayer stopAnimation];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - privite methods
-(void)hideShootingView
{
    self.shootingButton.hidden = YES;
    self.backButton.hidden = YES;
    self.transformButton.hidden = YES;
    self.cancleButton.hidden = NO;
    self.sendButton.hidden = NO;
    self.originalButton.hidden = NO;
    self.flashlightButton.hidden = YES;
    if (_hasPicture) {
        _cancleButton.cw_centerX = UIScreenWidth/2;
        _sendButton.cw_centerX = UIScreenWidth/2;
        [UIView animateWithDuration:.5f animations:^{
            CGFloat y = _cancleButton.center.y;
            CGFloat x = UIScreenWidth / 2;
            CGPoint cancleButtonPoint = CGPointMake(x, y);
            cancleButtonPoint.x -= UIScreenWidth/2-60;
            [_cancleButton setCenter:cancleButtonPoint];
            CGPoint sendButtonPoint = CGPointMake(x, y);
            sendButtonPoint.x += UIScreenWidth/2-60;
            [_sendButton setCenter:sendButtonPoint];
            self.cancleButton.alpha = 1.f;
            self.sendButton.alpha = 1.f;
        } completion:^(BOOL finished) {

        }];
    }
    _hasPicture = NO;
}

-(void)hideSendView
{
    self.shootingButton.hidden = NO;
    self.backButton.hidden = NO;
    self.transformButton.hidden = NO;
    self.cancleButton.hidden = YES;
    self.sendButton.hidden = YES;
    self.originalButton.hidden = YES;
    self.flashlightButton.hidden = NO;
    _shootingButton.enabled = YES;
}

-(void)showPlayVideoView
{
    NSLog(@"--showPlayVideoView--");
    self.playVideoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playVideoView];
    [self.view addSubview:self.cancleButton];
    [self.view addSubview:self.sendButton];
}

//-(void)addAnimation{
//    if (_aninationStarted) {
//        return;
//    }
//    _aninationStarted = YES;
//    CABasicAnimation * strokeEndAnimate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    strokeEndAnimate.fromValue = [NSNumber numberWithFloat:0.0];
//    strokeEndAnimate.toValue = [NSNumber numberWithFloat:1.0];
//    CAAnimationGroup *strokeAnimateGroup = [CAAnimationGroup animation];
//    strokeAnimateGroup.duration = MAX_VIDEO_DURATION;
//    strokeAnimateGroup.repeatCount = 1;
//    strokeAnimateGroup.animations = @[strokeEndAnimate];
//    [self.circleShapeLayer addAnimation:strokeAnimateGroup forKey:nil];
//}

//- (void)resetStroke{
//    self.circleShapeLayer.strokeEnd = 0.f;
//    _aninationStarted = NO;
//    [self.circleShapeLayer removeAllAnimations];
//}

- (CWProgressLayer *)progressLayer{
    if(!_progressLayer){
        _progressLayer = [[CWProgressLayer alloc] init];
        _progressLayer.frame = CGRectMake(0, 0, self.shootingButton.frame.size.width, self.shootingButton.frame.size.height);
        _progressLayer.circleWidth = 5;
        [self.shootingButton.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}
@end
