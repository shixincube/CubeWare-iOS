//
//  CWAVPlayerManager.m
//  SPCubeWareDev
//
//  Created by 陆川 on 2018/4/2.
//  Copyright © 2018年 陆川. All rights reserved.
//

#import "CWAVPlayerManager.h"
@interface CWAVPlayerManager()<CubeMediaPlayServiceDelegate>
/**
 播放的delegate
 */
@property (nonatomic, weak) id<CWAVPlayerManagerDelegate> delegate;
/**
 当前正在播放的音频的identifier
 */
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation CWAVPlayerManager
static CWAVPlayerManager * AVplayerManager = nil;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AVplayerManager = [[super allocWithZone:nil] init];
        
    });
    return AVplayerManager;
}

- (void)playAudioWithFilePath:(NSString *)filePath identifier:(NSString *)identifier delegate:(id<CWAVPlayerManagerDelegate>)delegate{
    //先停止当前播放
	[[CubeEngine sharedSingleton].mediaService stopCurrentPlay];
    if(_delegate && [_delegate respondsToSelector:@selector(playAudioDidEnd:)]){
        [_delegate playAudioDidEnd:self.identifier];
    }
    self.identifier = identifier;
    self.delegate = delegate;
    if(filePath.length<1){
        if(_delegate && [_delegate respondsToSelector:@selector(playAudioFail:error:)]){
            [_delegate playAudioFail:self.identifier error:[NSError errorWithDomain:@"filePaht == nil" code:12306 userInfo:nil]];
        }
        return;
    }
    [[CubeEngine sharedSingleton] mediaService].mediaPlayServiceDelegate = self;
    [[[CubeEngine sharedSingleton] mediaService] play:filePath repeatTimes:0];
	
}

-(void)stopPlay{
    [[[CubeEngine sharedSingleton] mediaService] stopCurrentPlay];
}

- (void)setDelegate:(id<CWAVPlayerManagerDelegate>)delegate identifier:(NSString *)identifier{
    if([identifier isEqualToString:self.identifier]){
        self.delegate = delegate;
    }
}
- (BOOL)isPlayingWithIdentifier:(NSString *)identifier{
    if([self.identifier isEqualToString:identifier]){
        return _isPlaying;
    }else{
        return NO;
    }
}

#pragma mark - CubePlayDelegate

-(void)didStartedPlay:(NSString *)file duration:(CMTime)duration viewLayer:(AVPlayerLayer *)layer{
	_isPlaying = YES;
	if(_delegate && [_delegate respondsToSelector:@selector(playAudioHDidStart:)]){
		[_delegate playAudioHDidStart:self.identifier];
	}
}

-(void)didCompletedPlay:(NSString *)file withError:(CubeError *)error{
	_isPlaying = NO;
	if(error)
	{
		if(_delegate && [_delegate respondsToSelector:@selector(playAudioFail:error:)]){
			[_delegate playAudioFail:self.identifier error:[NSError errorWithDomain:error.errorInfo code:error.errorCode userInfo:nil]];
		}
		
	}
	else
	{
		if(_delegate && [_delegate respondsToSelector:@selector(playAudioDidEnd:)]){
			[_delegate playAudioDidEnd:self.identifier];
		}
	}
}

@end
