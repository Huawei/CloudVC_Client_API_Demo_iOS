//
//  CallRingMode.m
//  VC_SDK_DEMO
//
//  Created by tupservice on 2018/1/19.
//  Copyright © 2018年 cWX160907. All rights reserved.
//

#import "CallRingMode.h"
#import <AVFoundation/AVFoundation.h>
@interface CallRingMode () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *ringPlayer;
@property (nonatomic, strong) NSTimer *vibrateLoopTimer;

@end
@implementation CallRingMode

+(instancetype)shareInstace
{
    static CallRingMode* ringMode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ringMode = [[CallRingMode alloc]init];
    });
    return ringMode;
}

-(void)playRing
{
    if (_ringPlayer == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"In"
                                                            ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        NSError * err = nil;
        AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        player.numberOfLoops = -1;
        player.delegate = self;
        
        _ringPlayer = player;
    }
    if (![_ringPlayer isPlaying]) {
        [_ringPlayer prepareToPlay];
        [_ringPlayer play];
    }
    if ([self.vibrateLoopTimer isValid]) {
        [self.vibrateLoopTimer invalidate];
        self.vibrateLoopTimer = nil;
    }
    self.vibrateLoopTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
}

- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)stopRing
{
    if (_ringPlayer != nil && [_ringPlayer isPlaying]) {
        [_ringPlayer stop];
    }
    if ([self.vibrateLoopTimer isValid]) {
        [self.vibrateLoopTimer invalidate];
    }
    self.vibrateLoopTimer = nil;
}

@end
