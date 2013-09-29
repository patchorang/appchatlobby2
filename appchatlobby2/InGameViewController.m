//
//  InGameViewController.m
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import "InGameViewController.h"
#import "ACLAppDelegate.h"

@interface InGameViewController ()

@end

@implementation InGameViewController

@synthesize scoreLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        ACLAppDelegate *appDelegate = (ACLAppDelegate *)[[UIApplication sharedApplication] delegate];
        gc = [appDelegate gc];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self becomeFirstResponder];
    [self initGamoogaClient];
    [gc sendMessage:[NSString stringWithFormat:@""] withType:@"getscript"];
    
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

#pragma mark - Gamooga init and callbacks

- (void) initGamoogaClient {
    [gc onMessageCallback:@selector(processScript:) withTarget:self forType:@"script"];
}

- (void) processScript:(NSString *)data {
    
    if (!countingDown) {
        countingDown = YES;
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
        actions = [dict objectForKey:@"actions"];
        lookup = [NSMutableDictionary dictionary];
        
        int count = 0;
        for (int i = 0; i < [actions count]; i++) {
            [lookup setObject:[[actions objectAtIndex:i] objectForKey:@"action"] forKey:[NSNumber numberWithInt:count]];
            count += [[[actions objectAtIndex:i] objectForKey:@"time"] integerValue];
            if (i == [actions count] - 1) {
                [lookup setObject:@"done" forKey:[NSNumber numberWithInt:count]];
                totalTime = count;
            }
        }

        [self countdownTimer];
    }
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(curSeconds < totalTime ){
        if ([lookup objectForKey:[NSNumber numberWithInt:curSeconds]] != nil) {
            self.actionLabel.text = [lookup objectForKey:[NSNumber numberWithInt:curSeconds]];
        }
        curSeconds++ ;
        self.timerLabel.text = [NSString stringWithFormat:@"%d", [self timeTill:curSeconds]];  //[NSString stringWithFormat:@"%d", curSeconds];
    }
    else{
        NSLog(@"Final Score is: %f", score);
        if (!done) {
            done = YES;
            curSeconds = 16925;
            [self performSegueWithIdentifier:@"finishGame" sender:self];
        }
    }
}

- (void)countdownTimer{
    curSeconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (int)timeTill:(int)currentTime {
    int smallestDiff = 100000;

    
    for (id key in lookup) {
        int curNum = [key integerValue];
        if (curNum - currentTime < smallestDiff && curNum - currentTime >= 0) {
            smallestDiff = curNum - currentTime;
        }
    }
//    for (int i = 0; i < [lookup count]; i++) {
//        int curNum = [[[actions objectAtIndex:i] objectForKey:@"time"] integerValue];
//        NSLog(@"%d", curNum- currentTime);
//        if (curNum - currentTime < smallestDiff && curNum - currentTime >= 0) {
//            smallestDiff = curNum - currentTime;
//        }
//    }
    return smallestDiff;
}


/*- (void)runTimer {
    double delayInSeconds = 0;
    for(int i = 0; i < [actions count]; i++) {
        
        NSLog(@"Delay seconds %f", delayInSeconds);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self runInterval:[actions objectAtIndex:i]];
        });
        delayInSeconds += [[[actions objectAtIndex:i] objectForKey:@"time"] integerValue];
    }
}

- (void)runInterval:(NSDictionary *)interval {
    countingDown = YES;
    NSLog(@"Delay Time is %d", [[interval objectForKey:@"time"] integerValue]);
    self.actionLabel.text = [interval objectForKey:@"action"];
    [self countDownFor:[[interval objectForKey:@"time"] integerValue]];
}

- (void)countDownFor:(int)seconds
{
    self.timerLabel.text = [NSString stringWithFormat:@"%d",seconds];
    if (seconds == 1) {
        countingDown = NO;
        return;
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self countDownFor:(seconds - 1)];
    });
}*/

@end
