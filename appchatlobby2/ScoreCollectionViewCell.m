//
//  ScoreCollectionViewCell.m
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/29/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import "ScoreCollectionViewCell.h"

@implementation ScoreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
}


@end
