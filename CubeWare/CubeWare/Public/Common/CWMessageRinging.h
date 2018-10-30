//
//  CWMessageRinging.h
//  CubeWare
//
//  Created by Mario on 17/3/21.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWMessageRinging : NSObject

+ (CWMessageRinging *)sharedSingleton;

- (void)stopCallSound;

- (void)playCallSound;

- (void)configCallPlayer;

- (void)stopRingBackSound;

- (void)playRingBackSound;

- (void)configRingBackPlayer;

- (void)configMessageReceivedPlayer;

- (void)playMessageSound;

- (void)stopMessageSound;

- (void)playNetConnectedSound;

- (void)stopConnectedSound;

- (void)configNetConnectedPlayer;

- (void)shake;
@end
