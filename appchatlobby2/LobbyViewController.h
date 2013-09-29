//
//  LobbyViewController.h
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamoogaClient.h"
#import "LobbyCollectionViewCell.h"

@interface LobbyViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    GamoogaClient *gc;
    NSMutableArray *messages;
}

@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* playerId;
@property (nonatomic, strong) NSString* gameId;
@property (nonatomic, strong) UIImage* imageItem;
@property (nonatomic, strong) NSString* photoUrl;

- (IBAction)startGame:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *chatData;
@property (weak, nonatomic) IBOutlet UITextField *chatMsg;
@property (retain, nonatomic) NSMutableArray *messages;

- (IBAction)sendChat:(id)sender;
- (void) addItem:(NSString *)message;
- (void) initGamoogaClient;
- (void) setImage:(UIImage *)image;
- (void)setUpPlayerWith:(NSString *)userName playerId:(NSString *)playerId gameId:(NSString *)gameId;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UICollectionView *lobbyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *containerView;

@end