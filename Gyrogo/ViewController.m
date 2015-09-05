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
    
    SCNScene *scn = [[SCNScene alloc] init];
    SCNBox *box = [SCNBox boxWithWidth:50.0 height:8.0 length:120.0 chamferRadius:1.0];
    box.firstMaterial.diffuse.contents = [UIColor orangeColor];
    SCNNode *node = [SCNNode nodeWithGeometry:box];
    [scn.rootNode addChildNode:node];
    _scene.scene = scn;
    [_scene setBackgroundColor:[UIColor clearColor]];
    [_scene setAutoenablesDefaultLighting:YES];
    [_scene setAllowsCameraControl:YES];
    
    
    
    _motionManager = [[CMMotionManager alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __weak typeof(self) weakSelf = self;
    [_motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [weakSelf updateMotion:motion];
    }];
}

- (void)updateMotion:(CMDeviceMotion *)motion
{
    [self performSelectorOnMainThread:@selector(updateLabels:) withObject:motion waitUntilDone:NO];
}

- (void)updateLabels:(CMDeviceMotion *)motion
{
    [_yawLabel   setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(motion.attitude.yaw)]];
    [_rollLabel  setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(motion.attitude.roll)]];
    [_pitchLabel setText:[NSString stringWithFormat:@"%0.1f˚", RADIANS_TO_DEGREES(motion.attitude.pitch)]];
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
