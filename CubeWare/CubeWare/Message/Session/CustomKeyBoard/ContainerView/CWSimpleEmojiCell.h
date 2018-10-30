//
//  CWSimpleEmojiCell.h
//  CWRebuild
//
//  Created by luchuan on 2018/1/2.
//  Copyright © 2018年 luchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CWSimpleEmojiModel.h"
#import "CWEmojiModel.h"

@interface CWSimpleEmojiCell : UICollectionViewCell

//@property (nonatomic, strong) CWSimpleEmojiModel *simpleEmojiModel;
@property (nonatomic,strong) CWEmojiModel *emojiModel;

@property (nonatomic, assign) BOOL showTitle;
@end
