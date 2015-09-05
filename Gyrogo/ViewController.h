//
//  ViewController.h
//  Gyrogo
//
//  Created by Michael Cianni on 9/4/15.
//  Copyright (c) 2015 CMPLXLABS. All rights reserved.
//

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#import <UIKit/UIKit.h>
@import CoreMotion;
@import SceneKit;

@interface ViewController : UIViewController

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet UILabel *yawLabel;
@property (strong, nonatomic) IBOutlet UILabel *rollLabel;
@property (strong, nonatomic) IBOutlet UILabel *pitchLabel;
@property (strong, nonatomic) IBOutlet SCNView *scene;

@end

