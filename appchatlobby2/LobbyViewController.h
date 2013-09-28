//
//  LobbyViewController.h
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamoogaClient.h"

@interface LobbyViewController : UIViewController {
    GamoogaClient *gc;
    NSMutableArray *messages;
}

@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* playerId;
@property (nonatomic, strong) NSString* gameId;

@property (weak, nonatomic) IBOutlet UICollectionView *chatData;
@property (weak, nonatomic) IBOutlet UITextField *chatMsg;
@property (retain, nonatomic) NSMutableArray *messages;

- (IBAction)sendChat:(id)sender;
- (void) addItem:(NSString *)message;
- (void) initGamoogaClient;
- (IBAction)startGame:(id)sender;

- (void)setUpPlayerWith:(NSString *)userName playerId:(NSString *)playerId gameId:(NSString *)gameId;

@end