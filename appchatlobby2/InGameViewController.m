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
    
    //NSLog(@"%@", data);

    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    //NSLog(@"%@", dict);

    actions = [dict objectForKey:@"actions"];
    [self runTimer];
    //NSDictionary *jsonDict = [data JSONValue];
}

- (void)runTimer {
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
}

@end
