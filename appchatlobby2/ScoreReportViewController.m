//
//  ScoreReportViewController.m
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import "ScoreReportViewController.h"
#import "ACLAppDelegate.h"

@interface ScoreReportViewController ()

@end

@implementation ScoreReportViewController

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
    
    [self initGamoogaClient];
    [gc sendMessage:@"getscorereport" withType:@"getscorereport"];

}

- (void) initGamoogaClient {
    [gc onMessageCallback:@selector(showFinalReport:) withTarget:self forType:@"scores"];
    [gc onMessageCallback:@selector(showFinalReportPhotos:) withTarget:self forType:@"photos"];
}

- (void)showFinalReport:(NSDictionary *)data {
    NSLog(@"Show final %@", data);
    int firstVal = -1;
    NSString *firstKey = @"";
    for(id key in data) {
        if (firstVal == -1) {
            firstVal = [[data objectForKey:key] intValue];
            firstKey = key;
        } else {
            if (firstVal > [[data objectForKey:key] intValue]) {
                maxId = firstKey;
                minId = key;
            } else {
                minId = firstKey;
                maxId = key;
            }
        }
    }
    
//    NSData *winImageData = [NSData dataWithContentsOfURL:[data objectForKey:maxId]];
//    self.winnerImage.image = [UIImage imageWithData:winImageData];
//    
//    NSData *loseImageData = [NSData dataWithContentsOfURL:[data objectForKey:minId]];
//    self.loserImage.image = [UIImage imageWithData:loseImageData];
    
    NSString *winScore = [data objectForKey:maxId];
    NSString *loseScore = [data objectForKey:minId];
    self.winnerScore.text = winScore;
    self.loserScore.text = loseScore;
    
}

- (void)showFinalReportPhotos:(NSDictionary *)data {
    int firstVal = -1;
    NSString *firstKey = @"";
    for(id key in data) {
        if (firstVal == -1) {
            firstVal = [[data objectForKey:key] intValue];
            firstKey = key;
        } else {
            if (firstVal > [[data objectForKey:key] intValue]) {
                maxId = firstKey;
                minId = key;
            } else {
                minId = firstKey;
                maxId = key;
            }
        }
    }
    
    NSData *winImageData = [NSData dataWithContentsOfURL:[data objectForKey:maxId]];
    self.winnerImage.image = [UIImage imageWithData:winImageData];

    NSData *loseImageData = [NSData dataWithContentsOfURL:[data objectForKey:minId]];
    self.loserImage.image = [UIImage imageWithData:loseImageData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
