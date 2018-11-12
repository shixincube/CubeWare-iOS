//
//  CWFileMessageCell.m
//  CubeWare
//
//  Created by jianchengpan on 2018/1/3.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import "CWFileMessageCell.h"
#import "CWResourceUtil.h"
#import <Masonry.h>
#import "CubeWareGlobalMacro.h"
#import "CWMessageUtil.h"
#import "CWUtils.h"
#import "CWProgressLineView.h"
#import "CWWorkerFinder.h"
#import "CWFileRefreshDelegate.h"
@interface CWFileMessageCell()<CWFileRefreshDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *filesizeLabel;
//@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) CWProgressLineView *progressLineView;
@end

@implementation CWFileMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initView];
        [[CWWorkerFinder defaultFinder] registerWorker:self forProtocols:@[@protocol(CWFileServiceDelegate)]];
    }
    return self;
}

-(void)initView{
    _iconImageView = [[UIImageView alloc] init];
    
    [self.bubbleView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(69, 69));
		make.left.equalTo(self.bubbleView).with.offset(14);
		make.centerY.equalTo(self.bubbleView);
    }];


    _titleLabel = [[UILabel alloc] init];
	_titleLabel.textColor = CWRGBColor(9,15,13,1);
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

    [self.bubbleView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleView).with.offset(20);
        make.left.equalTo(_iconImageView.mas_right).with.offset(15);
        make.right.lessThanOrEqualTo(self.bubbleView).with.offset(-14);
    }];
    [_titleLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [_titleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];


    _filesizeLabel = [[UILabel alloc] init];
    _filesizeLabel.font = [UIFont systemFontOfSize:14.0f];
    _filesizeLabel.textColor = CWRGBColor(167,167,167,1);

    [self.bubbleView addSubview:_filesizeLabel];
    [_filesizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(_iconImageView);
    }];

    _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_statusBtn setTitleColor:CWRGBColor(69, 146, 249, 1) forState:UIControlStateNormal];
    _statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_statusBtn addTarget:self action:@selector(downLoadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleView addSubview:_statusBtn];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY .mas_equalTo(self.filesizeLabel);
        make.right.mas_equalTo(self.bubbleView.mas_right).offset(-14);
    }];
//    _statusLabel = [[UILabel alloc] init];
//    _statusLabel.font = [UIFont systemFontOfSize:11.0f];
//    _statusLabel.textColor = [UIColor lightGrayColor];
//
//    [self.bubbleView addSubview:_statusLabel];
//    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_filesizeLabel);
//        make.right.equalTo(self.bubbleView).with.offset(-14);
//    }];
    _progressLineView = [[CWProgressLineView alloc] init];
    _progressLineView.hidden = YES;
    [self.bubbleView addSubview:_progressLineView];
    [_progressLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.filesizeLabel);
        make.left.equalTo(self.filesizeLabel.mas_left);
        make.height.mas_equalTo(5);
        make.right.mas_equalTo(self.statusBtn.mas_right);
    }];
    [self.bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(220);
    }];
}
#pragma mark - Action
- (void)downLoadBtnAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBubbleOnCell:)]){
        [self.delegate didClickedBubbleOnCell:self];
    }
}
#pragma mark - content protocol

+(CGFloat)bubbleHeightForContent:(id)content inSession:(CWSession *)session{
	return 104;
}

-(void)configUIWithContent:(id)content{
    [super configUIWithContent:content];
    CubeFileMessage *msg = content;
    self.iconImage = [CWResourceUtil imageNamed:[CWUtils getImageWithFileName:msg.fileName]];
    self.filesize = msg.fileSize;
    self.title = msg.fileName;
    [self.statusBtn setTitle:msg.filePath ? @"已下载" : @"下载" forState:UIControlStateNormal];
    self.statusBtn.enabled = msg.filePath ? NO : YES;
}
#pragma mark - CWFileRefreshDelegate
- (void)onFileDownloadProgress:(CubeFileMessage *)message progress:(NSProgress *)progress
{
    if(self.currentContent.SN == message.SN){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showProgress:YES];
            self.progressLineView.progress = (CGFloat)progress.completedUnitCount/progress.totalUnitCount;
        });
    }
}

- (void)onFileDownloadSuccess:(CubeFileMessage *)message
{
    if(self.currentContent.SN == message.SN){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showProgress:NO];
        });
    }
}


#pragma mark - private Medths
- (void)showProgress:(BOOL)isShow{
    self.filesizeLabel.hidden = self.statusBtn.hidden = isShow;
    self.progressLineView.hidden = !isShow;
    
}
#pragma mark - getter and setter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIconUrl:(NSString *)iconUrl{
    if(iconUrl.length && ![iconUrl hasPrefix:@"http"])
    {
        self.iconImage = [UIImage imageWithContentsOfFile:iconUrl];
    }
    else
    {
        self.iconImage = nil;
    }
}

-(void)setIconImage:(UIImage *)iconImage{
    self.iconImageView.image = iconImage ? iconImage : [CWResourceUtil imageNamed:@"fileType_default"];
}

-(void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

-(void)setFilesize:(long long)filesize{
    _filesizeLabel.text = [CWMessageUtil fileSizeStringWithFileSize:filesize];
}

@end
