//
//  CWApplyJoinView.m
//  CubeWare
//  申请加入语音聊天
//  Created by 美少女 on 2018/1/5.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWApplyJoinView.h"
#import "CWColorUtil.h"
#import "CWResourceUtil.h"
#import "AFNetworking.h"
#import "CWApplyjoinCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CWDBManager.h"
#import <Masonry.h>
#import "CubeWareGlobalMacro.h"

@interface CWApplyJoinView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 背景
 */
@property (nonatomic,strong) UIImageView *backgroundView;

/**
 返回按钮
 */
@property (nonatomic,strong) UIButton *backButton;

/**
 当前成员描述
 */
@property (nonatomic,strong) UILabel *memberLabel;

/**
 当前成员列表
 */
@property (nonatomic,strong) UICollectionView *memberCollectView;

/**
 网络连接状态
 */
@property (nonatomic,strong) UILabel *netWorkStatusLabel;

/**
 加入按钮
 */
@property (nonatomic,strong) UIButton *joinButton;

/**
 成员数组
 */
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
@implementation CWApplyJoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createView];
        [self addViewConstraints];
        [self isNetWorkReachable];
    }
    return self;
}

- (void)createView
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.backButton];
    [self addSubview:self.memberLabel];
    [self addSubview:self.memberCollectView];
    [self addSubview:self.netWorkStatusLabel];
    [self addSubview:self.joinButton];
}

- (void)addViewConstraints
{
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62, 36 * RatioHeight));
        make.left.equalTo(@13);
        make.top.equalTo(@20);
    }];
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset((100 + 10) * RatioHeight + 20);
    }];
    [self.memberCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((UIScreenWidth - 110), (UIScreenWidth - 110)));
        make.centerX.equalTo(self);
        make.top.equalTo(self.memberLabel.mas_bottom).offset(50);
    }];
    [self.netWorkStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memberCollectView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 20));
        make.centerX.equalTo(self);
    }];
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(UIScreenWidth - 100, 43));
        make.bottom.equalTo(self).offset(- 50);
        make.centerX.equalTo(self);
    }];
}
#pragma mark - public methods
- (void)updateCollectView
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //更新成员列表
//        [self.memberCollectView  reloadData];
//         self.memberLabel.text = [NSString stringWithFormat:@"%ld人正在通话中",self.conference.members.allKeys.count];
//    });
}
#pragma mark -events
- (void)backBtnClick:(UIButton *)button
{
    //移除页面
    if (_delegate && [_delegate respondsToSelector:@selector(back)]) {
        [_delegate back];
    }
}
- (void)joinBtnClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(joinInAudio)])
    {
        [_delegate joinInAudio];
    }
}
#pragma mark - getters
- (UIImageView *)backgroundView
{
    if (nil == _backgroundView)
    {
        _backgroundView = [[UIImageView alloc]init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UIButton *)backButton
{
    if (nil == _backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[CWResourceUtil imageNamed:@"img_return_normal"] forState:UIControlStateNormal];
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_backButton setTitleColor:[CWColorUtil colorWithRGB:0x8a8fa4 andAlpha:1.0] forState:UIControlStateNormal];
        [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 0)];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)memberLabel
{
    if (nil == _memberLabel)
    {
        _memberLabel = [[UILabel alloc]init];
        _memberLabel.font = [UIFont systemFontOfSize:12.f];
        _memberLabel.textColor = [CWColorUtil colorWithRGB:0x999999 andAlpha:1.0];
        _memberLabel.textAlignment = NSTextAlignmentCenter;
        _memberLabel.backgroundColor = [UIColor clearColor];

    }
    return _memberLabel;
}

- (UICollectionView *)memberCollectView
{
    if (nil == _memberCollectView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = (UIScreenWidth - 110 - 70 * 3) / 2;
        CGFloat itemWH = 70;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        _memberCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _memberCollectView.backgroundColor = [UIColor clearColor];
        _memberCollectView.dataSource = self;
        _memberCollectView.delegate = self;
        _memberCollectView.alwaysBounceHorizontal = NO;
        [_memberCollectView registerClass:[CWApplyjoinCollectionViewCell class] forCellWithReuseIdentifier:@"collect"];
    }
    return _memberCollectView;
}

- (UILabel *)netWorkStatusLabel
{
    if (nil == _netWorkStatusLabel)
    {
        _netWorkStatusLabel = [[UILabel alloc]init];
        _netWorkStatusLabel.textAlignment = NSTextAlignmentCenter;
        _netWorkStatusLabel.font = [UIFont systemFontOfSize:12];
        _netWorkStatusLabel.textColor = [CWColorUtil colorWithRGB:0x333333 andAlpha:0.6];
    }
    return _netWorkStatusLabel;
}

- (UIButton *)joinButton
{
    if (nil == _joinButton)
    {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_joinButton setTitleColor:[CWColorUtil colorWithRGB:0xffffff andAlpha:1] forState:UIControlStateNormal];
        [_joinButton setBackgroundColor:[CWColorUtil colorWithRGB:0x7a8fdf andAlpha:1]];
        [_joinButton setTitle:@"立即加入" forState:UIControlStateNormal];
        _joinButton.layer.cornerRadius = 5.f;
        _joinButton.layer.masksToBounds = YES;
        [_joinButton addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}

//- (void)setConference:(Conference *)conference
//{
//    if (!_dataSource) {
//        _dataSource = [[NSMutableArray alloc] init];
//    }else{
//        [_dataSource removeAllObjects];
//    }
//    BOOL isExistMember = YES;
////    CWUserModel *mineUserMdoel = [[CWUserModelManager defaultManager] userIsSelf];
//    for (NSString *cubeId in conference.members.allKeys)
//    {
////        CWUserModel *userModel = [[CWDBManager shareManager]userWithUserId:cubeId];
//        /*
//        CWUserNickModel *userNickModel = [[CubeUserNickDBManager defaultManager] nickNameModelWithGroupCubeId:conference.bindGroup andUserCubeId:cubeId];
//        if ([cubeId isEqualToString:mineUserMdoel.cubeId]) {
//            userNickModel = [[CWUserNickModel alloc] initWithGroupCubeId:conference.bindGroup nickname:mineUserMdoel.name userCubeId:mineUserMdoel.cubeId name:mineUserMdoel.name];
//            userNickModel.avatarUrl = mineUserMdoel.avatarUrl;
//        }
//        if (!userNickModel) {
//            userNickModel = [[CubeWare sharedSingleton].provider userNickByGroupCubeId:conference.bindGroup andUserCubeId:cubeId];
//        }
//        if (!(userNickModel && userNickModel.avatarUrl && userNickModel.name)) {
//            isExistMember = NO;
//        }
//        if (!userNickModel) {
//            userNickModel = [[CWUserNickModel alloc] initWithGroupCubeId:conference.bindGroup nickname:nil userCubeId:cubeId name:nil];
//        }
//         */
//        @synchronized (_dataSource) {
//            if ([cubeId isEqualToString:conference.founder])
//            {
////                [_dataSource insertObject:userNickModel atIndex:0];
//            }else{
////                [_dataSource addObject:userNickModel];
//            }
//        }
//    }
////    if (!isExistMember && _isRefresh) {
////        [self reloadMembersList:conference];
////    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _memberLabel.text = [NSString stringWithFormat:@"%lu人正在进行通话", (unsigned long)self.dataSource.count];
//        [_memberCollectView reloadData];
//    });
//}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 0; //self.conference.members.allKeys.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"collect";

    CWApplyjoinCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    if (!cell) {
        cell = [[CWApplyjoinCollectionViewCell alloc] init];
    }
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    //        if (_dataSource.count) {
    //            if (indexPath.row >= _dataSource.count) {
    //                NSLog(@"cell out of bounds");
    //                return nil;
    //            }
    //            CWUserNickModel *model = _dataSource[indexPath.row];
    //            NSURL * url = [NSURL URLWithString:model.avatarUrl];
    //            UIImage *image = [CWUtils cacheImageForKey:url];
    //            if (!image){
//    CWUserModel *userModel = [];

                UIImage *  image = [CWResourceUtil imageNamed:@"defaultAvatar.png"];
    //            }
                [cell.imageView sd_setImageWithURL:nil placeholderImage:image];
    //            NSLog(@"userNickModeluserNickModelAvatarUrl:%@", model.avatarUrl);
    //        }

    return cell;
}


#pragma mark - privite method
-(void)isNetWorkReachable
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                self.netWorkStatusLabel.text = @"正在使用手机流量";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                self.netWorkStatusLabel.text = @"您正在使用WiFi网络,通话免费";
            }
                break;
            default:
                break;
        }
    }];
    [mgr startMonitoring];
}
@end
