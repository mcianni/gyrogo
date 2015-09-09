//
//  Game.h
//  Gyrogo
//
//  Created by Michael Cianni on 9/8/15.
//  Copyright (c) 2015 CMPLXLABS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameDelegate <NSObject>

- (void)timesUp;
- (void)updateProgress:(float)progress;
- (void)newHighScore:(int)score;

@end



@interface Game : NSObject

@property (nonatomic, weak) id<GameDelegate> delegate;

- (void)start;
- (void)end;
- (int)gotOneRight;
- (int)longestStreak;

@end
