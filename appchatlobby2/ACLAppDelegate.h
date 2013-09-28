//
//  ACLAppDelegate.h
//  appchatlobby2
//
//  Created by Adam Menz on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamoogaClient.h"

@interface ACLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSString *playerId;
@property (strong, nonatomic) GamoogaClient *gc;
@property (strong, nonatomic) UIWindow *window;

@end
