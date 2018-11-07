//
//  CDJoinView.m
//  CubeEngineDemo
//  
//  Created by pretty on 2018/9/10.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDJoinView.h"
#import "CWToastUtil.h"
#import "CDConnectedView.h"
#import "CDHudUtil.h"
@interface CDJoinView()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 标题
 */
@property (nonatomic,strong) UILabel *title;

/**
 加入按钮
 */
@property (nonatomic,strong) UIButton *joinButton;

/**
 返回按钮
 */
@property (nonatomic,strong) UIButton *backButton;
/**
 成员列表
 */
@property (nonatomic,strong) UICollectionView *listView;
@end
@implementation CDJoinView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KWhiteColor;
        [self addSubview:self.backButton];
        [self addSubview:self.title];
        [self addSubview:self.joinButton];
        [self addSubview:self.listView];
        [self setUI];
        [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWConferenceServiceDelegate)]];
    }
    return self;
}

- (UILabel *)title
{
    if(nil == _title)
    {
        _title = [[UILabel alloc]initWithFrame:CGRectZero];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = RGBA(0x26, 0x25, 0x2A, 1);
    }
    return _title;
}

- (UIButton *)joinButton
{
    if (nil == _joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton addTarget:self action:@selector(onClickJoin:) forControlEvents:UIControlEventTouchUpInside];
        _joinButton.layer.cornerRadius = 5;
        [_joinButton setTitle:@"立即加入" forState:UIControlStateNormal];
        [_joinButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [_joinButton setBackgroundColor:RGBA(0x43,0x93,0xf9,1)];
    }
    return _joinButton;
}

- (UIButton *)backButton
{
    if (nil == _backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"img_return_normal"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UICollectionView *)listView
{
    if (nil == _listView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 27;
        layout.minimumInteritemSpacing = 27;
        layout.itemSize = CGSizeMake(70, 70);
//        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = KWhiteColor;
        _listView.showsVerticalScrollIndicator = YES;
        [_listView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    }
    return _listView;
}

- (void)setUI
{
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@40);
        make.left.mas_equalTo(@15);
        make.top.mas_equalTo(@30);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(@100);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@16);
    }];
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width).offset(-70);
        make.top.mas_equalTo(self.mas_bottom).offset(-84);
        make.height.mas_equalTo(@44);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.title.mas_bottom).offset(50);
        make.width.height.mas_equalTo(self.mas_width).offset(-100);
    }];
}
- (void)onClickJoin:(UIButton *)button
{
//加入
    [[CubeWare sharedSingleton].conferenceService joinConference:self.conference];
}

- (void)onClickBack:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)showView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    });
}

- (void)setConference:(CubeConference *)conference
{
    _conference = conference;
    if (conference.type == CubeGroupType_Share_Desktop_Conference) {
        self.title.text = [NSString stringWithFormat:@"%lu人正在屏幕分享",(unsigned long)_conference.members.count];
    }
    else if (conference.type ==CubeGroupType_Voice_Conference || conference.type ==CubeGroupType_Voice_Call)
    {
        self.title.text = [NSString stringWithFormat:@"%lu人正在多人语音",(unsigned long)_conference.members.count];
    }
    else if (conference.type ==CubeGroupType_Share_WB)
    {
        self.title.text = [NSString stringWithFormat:@"%lu人正在白板展示",(unsigned long)_conference.members.count];
    }
    else if(conference.type ==CubeGroupType_Video_Conference || conference.type ==CubeGroupType_Video_Call)
    {
        self.title.text = [NSString stringWithFormat:@"%lu人正在多人视频",(unsigned long)_conference.members.count];
    }
}

#pragma mark -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.conference.members.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    CubeGroupMember *member = [self.conference.members objectAtIndex:indexPath.row];
    UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(0 ,0, 70, 70)];
    userView.layer.cornerRadius = 70/2;
    userView.layer.masksToBounds = YES;
    [userView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default.png"]];
    [cell addSubview:userView];
    return cell;
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//
//}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

#pragma mark -
- (void)joinConference:(CubeConference *)conference andJoin:(CubeUser *)joiner
{
    //加入会议成功
#warning wai to do
//    show hud loading
    if ([joiner.cubeId isEqualToString:[CDShareInstance sharedSingleton].loginModel.cubeId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CWToastUtil showTextMessage:@"加入成功" andDelay:1.0f];
        });
    }
}

- (void)connectedConference:(CubeConference *)conference andView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.conference.groupId isEqualToString:conference.groupId])
        {
            CDConnectedView *connectedView = [CDConnectedView shareInstance];
            [connectedView.showView addSubview:view];
            connectedView.conference = conference;
            [connectedView show];
            [self removeFromSuperview];
        }
    });
}


- (void)conferenceFail:(CubeConference *)conference andError:(CubeError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CWToastUtil showTextMessage:error.errorInfo andDelay:1.0f];
        [self removeFromSuperview];
    });
}

- (void)destroyConference:(CubeConference *)conference byUser:(CubeUser *)user
{
    if ([conference.groupId isEqualToString:self.conference.groupId])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}
@end
