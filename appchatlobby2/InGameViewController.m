//
//  InGameViewController.m
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import "InGameViewController.h"

@interface InGameViewController ()

@end

@implementation InGameViewController

@synthesize scoreLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self becomeFirstResponder];
    
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    score = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
        [self outputRotationData:gyroData.rotationRate];
    }];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventTypeMotion){
        NSLog(@"MOtion");
    }
}

-(void)outputRotationData:(CMRotationRate)rotation
{
    currentMaxRotX = rotation.x;
    currentMaxRotY = rotation.y;
    currentMaxRotZ = rotation.z;
    
    double gyroVector = sqrt(pow(rotation.x, 2) + pow(rotation.x, 2) + pow(rotation.x, 2));
    if (gyroVector > .5){
        score += gyroVector;
    }
    
    scoreLabel.text = [NSString stringWithFormat:@"%d", ((int)score)/10];
}

@end
