//
//  ScoreReportViewController.h
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamoogaClient.h"

@interface ScoreReportViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    GamoogaClient *gc;
    NSString *maxId;
    NSString *minId;
}
@property (weak, nonatomic) IBOutlet UIImageView *winnerImage;
@property (weak, nonatomic) IBOutlet UILabel *winnerScore;
@property (weak, nonatomic) IBOutlet UIImageView *loserImage;
@property (weak, nonatomic) IBOutlet UILabel *loserScore;

@property (weak, nonatomic) IBOutlet UICollectionView *scoreCollectionView;

@end
