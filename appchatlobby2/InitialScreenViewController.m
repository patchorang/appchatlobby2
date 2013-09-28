//
//  InitialScreenViewController.m
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import "InitialScreenViewController.h"
#import "LobbyViewController.h"

@implementation InitialScreenViewController

- (IBAction)startGameButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LobbyViewController *lobby = [storyboard instantiateViewControllerWithIdentifier:@"LobbyViewController"];
    [lobby setUpPlayerWith:@"Computer" playerId:@"1" gameId:@"1"];
    [self.navigationController pushViewController:lobby animated:YES];
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"startGame"])
    {
        // Get reference to the destination view controller
        LobbyViewController *vc = [segue destinationViewController];
        [vc setUpPlayerWith:@"Computer" playerId:@"1" gameId:@"1"];
    }
}

@end
