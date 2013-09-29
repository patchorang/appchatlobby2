//
//  InGameViewController.h
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "GamoogaClient.h"


double score;
double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;
double currentMaxRotX;
double currentMaxRotY;
double currentMaxRotZ;

@interface InGameViewController : UIViewController
{
    int secondsLeft;
    BOOL countingDown;
    GamoogaClient *gc;
    NSArray *actions;
}

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end
