//
//  ViewController.m
//  Gyrogo
//
//  Created by Michael Cianni on 9/4/15.
//  Copyright (c) 2015 CMPLXLABS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _game = [[Game alloc] init];
    [_game setDelegate:self];
    
    [_longestStreakLabel setText:[NSString stringWithFormat:@"%i", [_game longestStreak]]];
    
    SCNScene *scn = [[SCNScene alloc] init];
    _phoneBox = [SCNBox boxWithWidth:5.0 height:0.8 length:12.0 chamferRadius:1.0];
    _phoneBox.firstMaterial.diffuse.contents = [UIColor orangeColor];
    _phoneNode = [SCNNode nodeWithGeometry:_phoneBox];
    
    SCNBox *currentPhoneBox = [SCNBox boxWithWidth:5.0 height:0.8 length:12.0 chamferRadius:1.0];
    currentPhoneBox.firstMaterial.diffuse.contents = [UIColor whiteColor];
    _currentPhoneNode = [SCNNode nodeWithGeometry:currentPhoneBox];
    _currentPhoneNode.position = SCNVector3Make(8, 8, 8);
    
    _phoneNode.position = SCNVector3Make(8, 8, 8);

    [scn.rootNode addChildNode:_phoneNode];
    [scn.rootNode addChildNode:_currentPhoneNode];

    _scene.scene = scn;
    
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.position = SCNVector3Make(5, 16, 30);
    
    cameraNode.camera = camera;
    [scn.rootNode addChildNode:cameraNode];
    
    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:_phoneNode];
    [constraint setGimbalLockEnabled:YES];
    cameraNode.constraints = @[constraint];

    [_scene setBackgroundColor:[UIColor clearColor]];
    [_scene setAutoenablesDefaultLighting:YES];
    [_scene setAllowsCameraControl:YES];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:recognizer];
    
    _motionManager = [[CMMotionManager alloc] init];
}

- (void)tap
{
    [_game start];
    [self randomizeAngles];
    [self startReceivingMotionUpdates];
    [_streakLabel setText:@"0"];
}

- (void)setupPlanes
{
    float planeHeight = 50.0;
    float planeWidth  = 50.0;
    SCNPlane *xPlane = [SCNPlane planeWithWidth:planeWidth height:planeHeight];
    xPlane.firstMaterial.doubleSided = YES;
    xPlane.firstMaterial.diffuse.contents = [UIColor yellowColor];
    SCNPlane *yPlane = [SCNPlane planeWithWidth:planeWidth height:planeHeight];
    yPlane.firstMaterial.doubleSided = YES;
    yPlane.firstMaterial.diffuse.contents = [UIColor greenColor];
    SCNPlane *zPlane = [SCNPlane planeWithWidth:planeWidth height:planeHeight];
    zPlane.firstMaterial.doubleSided = YES;
    zPlane.firstMaterial.diffuse.contents = [UIColor blueColor];
    
    SCNNode *xPlaneNode = [SCNNode nodeWithGeometry:xPlane];
    xPlaneNode.pivot = SCNMatrix4MakeTranslation(-planeWidth/2, 0, 0);
    xPlaneNode.rotation = SCNVector4Make(1, 0, 0, M_PI_2);
    SCNNode *yPlaneNode = [SCNNode nodeWithGeometry:yPlane];
    yPlaneNode.pivot = SCNMatrix4MakeTranslation(0, -planeHeight/2, 0);
    yPlaneNode.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    
    SCNNode *zPlaneNode = [SCNNode nodeWithGeometry:zPlane];
    zPlaneNode.pivot = SCNMatrix4MakeTranslation(-planeWidth/2, -planeHeight/2, planeHeight/2);
    zPlaneNode.position = SCNVector3Zero;
    //zPlaneNode.rotation = SCNVector4Make(0, 0, 1, M_PI_2);
    
    [_scene.scene.rootNode addChildNode:xPlaneNode];
    [_scene.scene.rootNode addChildNode:yPlaneNode];
    [_scene.scene.rootNode addChildNode:zPlaneNode];
}

- (void)updateMotion:(CMDeviceMotion *)motion
{
    [self performSelectorOnMainThread:@selector(updateLabels:) withObject:motion waitUntilDone:NO];
}

- (void)updateLabels:(CMDeviceMotion *)motion
{
    //[_yawLabel   setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(motion.attitude.yaw)]];
    [_rollLabel  setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(motion.attitude.roll)]];
    [_pitchLabel setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(motion.attitude.pitch)]];
    
    [SCNTransaction setAnimationDuration:0.01];
    [_currentPhoneNode setEulerAngles:SCNVector3Make(motion.attitude.pitch, 0, -motion.attitude.roll)];
    
    float maxDelta = 0.017 * 2; // 0.017 = 1 deg.
    if (fabs(motion.attitude.roll - _roll) < maxDelta) {
        [_rollLabel setTextColor:[UIColor greenColor]];
    } else {
        [_rollLabel setTextColor:[UIColor whiteColor]];
    }
    
    if (fabs(motion.attitude.pitch - _pitch) < maxDelta) {
        [_pitchLabel setTextColor:[UIColor greenColor]];
    } else {
        [_pitchLabel setTextColor:[UIColor whiteColor]];
    }
    
    if (
        (_roll  == 0 || fabs(motion.attitude.roll  - _roll) < maxDelta) &&
        (_pitch == 0 || fabs(motion.attitude.pitch - _pitch) < maxDelta)) // &&
        //(_yaw   == 0 || fabs(motion.attitude.yaw   - _yaw) < maxDelta) )
    {
        _phoneBox.firstMaterial.diffuse.contents = [UIColor greenColor];
        [self randomizeAngles];
        int streak = [_game gotOneRight];
        [_streakLabel setText:[NSString stringWithFormat:@"%i", streak]];
    } else {
        _phoneBox.firstMaterial.diffuse.contents = [UIColor orangeColor];
    }
    
}

- (void)randomizeAngles
{
    _yaw   = 0.0;
    _roll  = DEGREES_TO_RADIANS(arc4random_uniform(90) - 45.0);
    _pitch = DEGREES_TO_RADIANS(arc4random_uniform(90) - 45.0);
    
    UILabel *l1 = (UILabel *)[self.view viewWithTag:10];
    UILabel *l2 = (UILabel *)[self.view viewWithTag:11];
    UILabel *l3 = (UILabel *)[self.view viewWithTag:12];
    [l1 setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(_roll) ]];
    [l2 setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(_yaw) ]];
    [l3 setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(_pitch) ]];
    [self rotatePhoneBox];
}

- (void)rotatePhoneBox
{
    [SCNTransaction setAnimationDuration:1.0];
    [_phoneNode setEulerAngles:SCNVector3Make(_pitch, _yaw, -_roll)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [_game end];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startReceivingMotionUpdates
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __weak typeof(self) weakSelf = self;
    [_motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [weakSelf updateMotion:motion];
    }];
}

#pragma mark - GameDelegate
- (void)timesUp
{
    [_timerProgress setTintColor:[UIColor redColor]];
    [_motionManager stopDeviceMotionUpdates];
}

- (void)updateProgress:(float)progress
{
    [_timerProgress setProgress:progress];
}

- (void)newHighScore:(int)score
{
    [_longestStreakLabel setText:[NSString stringWithFormat:@"%i", score]];
}

@end