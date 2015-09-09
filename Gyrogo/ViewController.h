//
//  ViewController.h
//  Gyrogo
//
//  Created by Michael Cianni on 9/4/15.
//  Copyright (c) 2015 CMPLXLABS. All rights reserved.
//

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(degrees) ((degrees) / 180.0 * M_PI )

#import <UIKit/UIKit.h>
@import CoreMotion;
@import SceneKit;
#import "Game.h"

@interface ViewController : UIViewController <GameDelegate>

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet UILabel *yawLabel;
@property (strong, nonatomic) IBOutlet UILabel *rollLabel;
@property (strong, nonatomic) IBOutlet UILabel *pitchLabel;
@property (strong, nonatomic) IBOutlet SCNView *scene;
@property (strong, nonatomic) IBOutlet UILabel *streakLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *timerProgress;
@property (strong, nonatomic) SCNBox *phoneBox;
@property (strong, nonatomic) SCNNode *phoneNode;
@property (strong, nonatomic) SCNNode *currentPhoneNode;
@property (strong, nonatomic) Game *game;
@property float yaw;
@property float roll;
@property float pitch;

@end

