//
//  CWApplyJoinView.h
//  CubeWare
//
//  Created by 美少女 on 2018/1/5.
//  Copyright © 2018年 shixinyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CWApplyJoinViewDelegate <NSObject>
@optional
- (void)joinInAudio;
- (void)back;
@end
@interface CWApplyJoinView : UIView
@property (nonatomic,weak) id<CWApplyJoinViewDelegate> delegate;

/**
 * 会议
 */
@property (nonatomic, strong) CubeConference *conference;

/**
 更新成员列表
 */
- (void)updateCollectView;
@end
