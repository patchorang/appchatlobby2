//
//  testViewController.m
//  AppChatLobby
//
//  Copyright (c) 2012 Gamooga. All rights reserved.
//

#import "LobbyViewController.h"
#import "ACLAppDelegate.h"

@implementation LobbyViewController

@synthesize chatData;
@synthesize chatMsg;
@synthesize messages;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        ACLAppDelegate *appDelegate = (ACLAppDelegate *)[[UIApplication sharedApplication] delegate];
        gc = [appDelegate gc];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"Lobby";
	
    [self initGamoogaClient];
    
    messages = [[NSMutableArray alloc] init];
    
    // Ugly UI Shit
    // This is gross.
    self.startGameButton.layer.borderWidth = 0.5;
    self.startGameButton.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    self.startGameButton.layer.cornerRadius = 2;
    
    [self.navigationController setNavigationBarHidden:YES];
    self.lobbyCollectionView.layer.cornerRadius = 4;
    self.lobbyCollectionView.layer.shadowColor = [[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0] CGColor];
    self.lobbyCollectionView.layer.shadowOpacity = 0.7;
    self.lobbyCollectionView.layer.shadowOffset = CGSizeMake(0, 0);
    self.lobbyCollectionView.layer.shadowRadius = 1.5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Gamooga init and callbacks

- (void) initGamoogaClient {
    
    /**
     On connection, call 'onConnect' callback.
     */
    [gc onConnectCallback:@selector(onConnect) withTarget:self];
    
    /**
     We receive a "userjoin" message from the room.lua when a new user joins the
     room, call 'onUserJoin' when we receive this message.
     */
    [gc onMessageCallback:@selector(onUserjoin:) withTarget:self forType:@"userjoin"];
    
    /**
     On user connection, the server sends a "userlist" message with the list of
     all the users currently online. We call 'onUserList' when we receive this
     message.
     */
    [gc onMessageCallback:@selector(onUserlist:) withTarget:self forType:@"userlist"];
    
    /**
     A chat message is sent by the server. We call 'onChatMsg' to add this message
     to the stream.
     */
    [gc onMessageCallback:@selector(onChatMsg:) withTarget:self forType:@"chat"];
    
    /**
     A user is disconnected, we call 'onUsergone'.
     */
    [gc onMessageCallback:@selector(onUsergone:) withTarget:self forType:@"usergone"];
    
    /**
     Game is starting, we call 'onStartGame'.
     */
    [gc onMessageCallback:@selector(start:) withTarget:self forType:@"startgame"];
    
    /**
     We have been disconnected from the server, call 'onDisconnect'.
     */
    [gc onDisconnectCallback:@selector(onDisconnect) withTarget:self];
    
    /**
     onerror callback
     */
    [gc onErrorCallback:@selector(onError:) withTarget:self];
    
    // Connect to room
    [gc connectToRoomWithAppId:670 andAppUuid:@"bcd7aa5c-289d-11e3-a291-f23c91df4bc1"];
}

- (IBAction)startGame:(id)sender {
    [gc sendMessage:@"start" withType:@"sendstartmessage"];
}


- (void) onConnect {
    [gc sendMessage:[NSString stringWithFormat:@"%@ %@", self.userName, self.playerId] withType:@"mynick"];
}

- (void) start:(NSString *)data {
    [self performSegueWithIdentifier:@"startGame" sender:self];
}

- (void) onUserjoin:(NSString *)data {
    [self addItem:data];
}

- (void) onUserlist:(NSDictionary *)data {
    for (NSString *user in (NSArray *)[data objectForKey:@"ol"]) {
        [self addItem:[[data objectForKey:@"ol"] objectForKey:user]];
    }
}

- (void) onChatMsg:(NSDictionary *)data {
    [self addItem:[NSString stringWithFormat:@"%@: %@", (NSString *)[data objectForKey:@"f"], (NSString *)[data objectForKey:@"c"]]];
}

- (void) onUsergone:(NSString *)data {
    // TODO: Handle users leaving the game
}

- (void) onDisconnect {
    //[self addItem:@"*** disconnected"];
}

- (void) onError:(int)errn {
    //[self addItem:[NSString stringWithFormat:@"error: %d", errn]];
}

- (void) addItem:(NSString *)message {
	[self.messages addObject:message];
	[self.chatData reloadData];
}

- (IBAction)sendChat:(id)sender {
    [gc sendMessage:chatMsg.text withType:@"chat"];
	chatMsg.text = @"";
}

//- (IBAction)sendChat:(id)sender {
//    [gc sendMessage:chatMsg.text withType:@"chat"];
//	chatMsg.text = @"";
//}

#pragma mark Colection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2; // Number of players.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LobbyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lobby cell" forIndexPath:indexPath];
    return cell;
}

- (void)setUpPlayerWith:(NSString *)userName playerId:(NSString *)playerId gameId:(NSString *)gameId {
    ((ACLAppDelegate *)[[UIApplication sharedApplication] delegate]).playerId = playerId;
    self.userName = userName;
    self.playerId = playerId;
    self.gameId = gameId;
}

@end

