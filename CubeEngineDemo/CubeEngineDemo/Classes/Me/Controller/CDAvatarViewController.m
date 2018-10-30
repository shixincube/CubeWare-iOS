//
//  CDAvatarViewController.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/9/27.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDAvatarViewController.h"
#import "CWActionSheet.h"
#import "CWImagePickerController.h"
#import <Photos/Photos.h>
#import "CDDateUtil.h"
#import "CDHudUtil.h"
#import "CWWorkerFinder.h"
#import "CWUserDelegate.h"
#import "CWToastUtil.h"
@interface CDAvatarViewController ()<CWActionSheetDelegate,CWImagePickerControllerDelegate>

@end

@implementation CDAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBlackColor;
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longGes];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];

    [self.view addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.width);
    }];

    [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWUserServiceDelegate),@protocol(CWGroupServiceDelegate)]];
    if(self.group)
    {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.group.avatar] placeholderImage:[UIImage imageNamed:@"invalid"]];
    }
    else
    {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[CubeEngine sharedSingleton].userService.currentUser.avatar] placeholderImage:[UIImage imageNamed:@"invalid"]];
    }
}

- (UIImageView *)avatarView
{
    if (nil == _avatarView) {
        _avatarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invalid"]];
    }
    return _avatarView;
}

- (void)tap:(UITapGestureRecognizer *)ges
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)longPress:(UILongPressGestureRecognizer *)ges
{
//    NSLog(@"long press!");
    if(ges.state == UIGestureRecognizerStateBegan)
    {
        CWActionSheet *sheet = [CWActionSheet sheetWithTitle:nil buttonTitles:@[@"从相册选择"] redButtonIndex:0 delegate:self];
        [sheet show];
    }
}

- (void)actionSheet:(CWActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //跳转相册选择
        CWImagePickerController *imagePickerVc =
        [[CWImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.imageLength = 10 * 1024 * 1024;
        imagePickerVc.totalImageLength = NSIntegerMax;
        imagePickerVc.imageSize = CGSizeMake(4096, 4096);
        imagePickerVc.isSelectOriginalPhoto = NO;
        imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        imagePickerVc.oKButtonTitleColorNormal = UIColorFromRGB(0x8a8fa4);
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - CWImagePickerControllerDelegate (相册选择发送)
- (void)imagePickerController:(CWImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
//调用文件服务上传头像，上传后，更新头像URL
    int imageCout = assets.count;
    __block NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:imageCout];
    for (int i = 0 ; i< imageCout; i++) {
        [imageArr addObject:@""];
    }

    PHCachingImageManager *imageManager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    PHImageRequestOptions* itemOptions = [[PHImageRequestOptions alloc]init];
    if (isSelectOriginalPhoto) {
        itemOptions.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }else{
        itemOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    }
    itemOptions.networkAccessAllowed = YES;

    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //需要判断ios11以上系统是否是heif格式图片
        __block BOOL isHEIF = NO;
        NSArray *resourceList = [PHAssetResource assetResourcesForAsset:obj];
        [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetResource *resource = obj;
            NSString *UTI = resource.uniformTypeIdentifier;
            if ([UTI isEqualToString:@"public.heif"] || [UTI isEqualToString:@"public.heic"]) {
                isHEIF = YES;
                *stop = YES;
            }
        }];

        [imageManager requestImageDataForAsset:obj options:itemOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __block NSInteger currentidx = idx;
                __block NSData *originImageDate = imageData;
                if(!imageData)return ;//图片不存在
                NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[info objectForKey:@"PHImageFileURLKey"]]];
                NSString *imageContentType = isHEIF ?  @"jpeg" : [imageUrl pathExtension];//图片类型
                bool isFile = NO;
                __block NSData *thumbImageData;
//                CGSize thumbSize ;
                UIImage *orginalImage;
                NSString *imageName = [NSString stringWithFormat:@"image-%lu.%@", (unsigned long)[NSDate date].timeIntervalSince1970,imageContentType];

                if([[imageContentType lowercaseString] isEqualToString:@"gif"]){
                    //gif图暂时不处理
                    thumbImageData =imageData;
                    orginalImage= [UIImage imageWithData:imageData];
                }else{
                    originImageDate = imageData;
                    thumbImageData = imageData;
                    orginalImage = [UIImage imageWithData:thumbImageData];
                }

                NSString *imageFolder = [self subFolderAtDocumentWithName:@"CubeEngine/Message/Image"];
                NSString *filePath = [imageFolder stringByAppendingPathComponent:imageName];
                [thumbImageData writeToFile:filePath atomically:YES];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [CDHudUtil showDefultHud];
                });
               UploadCubeFile *uploadFile = [UploadCubeFile uploadFileWithIdentify:imageName andFilePath:filePath andFileName:imageName];
                [[CubeEngine sharedSingleton].fileService startUploadFileWithCubeFile:uploadFile progress:^(NSProgress *progress) {
                    CGFloat percent = ((CGFloat )progress.completedUnitCount)  / ((CGFloat )progress.totalUnitCount);
//                    NSLog(@"upload test  upload progress : %.2lf%%",percent * 100);
                } success:^(NSDictionary *responseData) {
//                    NSLog(@"upload test success with response : \n %@",responseData);
                    if (responseData[@"fileInfo"]) {
//                        NSLog(@"fileInfo is : %@",responseData[@"fileInfo"]);
                        NSString *url = responseData[@"fileInfo"][@"url"];
                        if (self.group!=nil) {
                            self.group.avatar = url;
                            [[CubeWare sharedSingleton].groupService updateGroup:self.group];
                        }
                        else
                        {
                            CubeUser *user =  [CubeEngine sharedSingleton].userService.currentUser;
                            user.avatar = url;
                            [[CubeEngine sharedSingleton].userService updateUser:user];
                        }
                    }
                } failure:^(CubeError *error) {
//                    NSLog(@"upload failed ");
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [CDHudUtil hideDefultHud];
                    });
                }];

            });
        }];
    }];



}
#pragma mark - delegate
- (void)updateUserSuccess:(CubeUser *)user
{
    //更新成功
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil hideDefultHud];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"invalid"]];
    });
}

- (void)updateUserFailed:(CubeError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //弹窗
        [CDHudUtil hideDefultHud];
        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
    });
}

- (void)updateGroup:(CubeGroup *)group from:(CubeUser *)from
{
    //更新成功
    dispatch_async(dispatch_get_main_queue(), ^{
        [CDHudUtil hideDefultHud];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:group.avatar] placeholderImage:[UIImage imageNamed:@"invalid"]];
    });
}
- (void)groupFail:(CubeError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //弹窗
        [CDHudUtil hideDefultHud];
        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
    });
}

#pragma mark - privite

- (NSString *)subFolderAtDocumentWithName:(NSString *)name
{
    NSString *path = nil;
    NSString *docDirPath = [self documentDirectoryPath];
    if (name) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *subFolder = [docDirPath stringByAppendingPathComponent:name];
        NSError *error = nil;
        [fileManager createDirectoryAtPath:subFolder
               withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
//            NSLog(@"%@", error);
        } else {
            path = subFolder;
        }
    }
    return path;
}

- (NSString *)documentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

@end
