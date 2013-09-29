//
//  ScoreReportViewController.m
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import "ScoreReportViewController.h"
#import "ScoreCollectionViewCell.h"

@interface ScoreReportViewController ()

@end

@implementation ScoreReportViewController

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
    self.scoreCollectionView.layer.cornerRadius = 4;
    self.scoreCollectionView.layer.shadowColor = [[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0] CGColor];
    self.scoreCollectionView.layer.shadowOpacity = 0.7;
    self.scoreCollectionView.layer.shadowOffset = CGSizeMake(0, 0);
    self.scoreCollectionView.layer.shadowRadius = 1.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"win cell" forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(260.0, (self.scoreCollectionView.frame.size.height/2.0)-15);
}

@end
