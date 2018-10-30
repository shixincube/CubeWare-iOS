//
//  CWAVMessageCell.m
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/9.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWAVMessageCell.h"
#import "CWResourceUtil.h"
#import "CWMessageUtil.h"

@interface CWAVMessageCell ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *contentLab;
@end

@implementation CWAVMessageCell

-(void)setShowLeft:(BOOL)showLeft{
    [super setShowLeft:showLeft];
    if(showLeft){
        [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageV.superview).offset(12);
            make.size.mas_equalTo(CGSizeMake(21, 21));
            make.centerY.mas_equalTo(_imageV.superview);
        }];
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageV.mas_right).offset(5);
            make.centerY.mas_equalTo(self.bubbleView);
            make.right.mas_equalTo(self.bubbleView).offset(-12);
        }];
        self.contentLab.textColor = [UIColor blackColor];
    }else{
        [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bubbleView.mas_right).offset(-12);
            make.size.mas_equalTo(CGSizeMake(21,21));
            make.centerY.mas_equalTo(self.imageV.superview);
        }];
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentLab.superview).offset(12);
            make.centerY.mas_equalTo(self.bubbleView);
            make.right.mas_equalTo(self.imageV.mas_left).offset(-5);
        }];
        
        self.contentLab.textColor = [UIColor whiteColor];
    }
}

#pragma mark - content protocol

+(CGFloat)cellHeigtForContent:(id)content inSession:(CWSession *)session{
    return 60;
}

-(void)configUIWithContent:(id)content{
    [super configUIWithContent:content];
    CubeMessageEntity *message = content;
    
    if(message.type == CubeMessageTypeCustom)
    {
        if(![message isKindOfClass:[CubeCustomMessage class]])return;
        CubeCustomMessage *avMsg = (CubeCustomMessage *)message;
        CWCustomMessageType type = [CWMessageUtil customMessageTypeForMessage:avMsg];
        if (type == CWNCustomMessageTypeNotity) {
            self.contentLab.text = @"通知类消息";
        }
        else if (type == CWNCustomMessageTypeChat)
        {
            NSString *operate = [avMsg.header objectForKey:@"operate"];
            if ([operate isEqualToString:kCWCustomMessageOperateShakeFriend]) {
                self.contentLab.text = @"抖了一下";
                if (avMsg.messageDirection == CubeMessageDirectionReceived)
                {
                    self.imageV.image = [UIImage imageNamed:@"shake_reciever.png"];
                }
                else
                {
                    self.imageV.image = [UIImage imageNamed:@"shake_sender.png"];
                }
            }
            else
            {
                self.contentLab.text = avMsg.body;
                if ([operate isEqualToString:@"videoCall"]) {
                    if (avMsg.messageDirection == CubeMessageDirectionReceived)
                    {
                        self.imageV.image = [UIImage imageNamed:@"chatBubble_video_receiver.png"];
                    }
                    else
                    {
                        self.imageV.image = [UIImage imageNamed:@"chatBubble_video_sender.png"];
                    }
                }
                else if ([operate isEqualToString:@"voiceCall"])
                {
                    if (avMsg.messageDirection == CubeMessageDirectionReceived)
                    {
                        self.imageV.image = [UIImage imageNamed:@"chatBubble_voice_receiver.png"];
                    }
                    else
                    {
                        self.imageV.image = [UIImage imageNamed:@"chatBubble_voice_sender.png"];
                    }
                }
//                else if ([operate isEqualToString:@"share_wb"])
//                {
//                    if (avMsg.messageDirection == CubeMessageDirectionReceived)
//                    {
//                        self.imageV.image = [UIImage imageNamed:@"chatBubble_whiteboard_receiver.png"];
//                    }
//                    else
//                    {
//                        self.imageV.image = [UIImage imageNamed:@"chatBubble_whiteboard_sender.png"];
//                    }
//                }
            }
        }
    }
}

#pragma mark - getter and setter
-(UIImageView *)imageV{
    if(!_imageV){
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeCenter;
        [self.bubbleView addSubview:_imageV];
    }
    return _imageV;
}

-(UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:15];
        [self.bubbleView addSubview:_contentLab];
    }
    return _contentLab;
}
@end
