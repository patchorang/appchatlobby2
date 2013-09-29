//
//  InGameViewController.h
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
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
    BOOL done;
    int curSeconds;
    int secondsBelow;
    int totalTime;
    BOOL countingDown;
    GamoogaClient *gc;
    NSArray *actions; // action and time
    NSMutableDictionary *lookup; // time -> action
    NSTimer *timer;
}

@property (strong, nonatomic) NSArray *features;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end
