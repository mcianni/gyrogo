//
//  Game.m
//  Gyrogo
//
//  Created by Michael Cianni on 9/8/15.
//  Copyright (c) 2015 CMPLXLABS. All rights reserved.
//

#import "Game.h"

@implementation Game
{
    NSDate *startTime;
    NSTimer *timer;
    int streak;
    int timeLimit;
}

- (id)init
{
    self = [super init];
    if (self) {
        timeLimit = 3000;  //miliseconds
    }
    return self;
}

- (void)start
{
    streak = 0;
    [self resetTimer];
    [self startTimer];
}

- (void)end
{
    NSLog(@"[GAME] - end");
    [timer invalidate];
}

- (void)resetTimer
{
    startTime = [NSDate date];
    [_delegate updateProgress:0];
}

- (void)startTimer
{
    timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (int)gotOneRight
{
    [self resetTimer];
    return ++streak;
}

- (void)tick:(NSTimer *)t
{
    float elapsedTime = [[NSDate date] timeIntervalSinceDate:startTime] * 1000.0;
    if (elapsedTime >= timeLimit) {
        [timer invalidate];
        [_delegate timesUp];
    } else {
        [_delegate updateProgress:(elapsedTime/timeLimit)];
    }
}

@end
