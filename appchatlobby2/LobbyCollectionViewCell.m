//
//  LobbyCollectionViewCell.m
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import "LobbyCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LobbyCollectionViewCell

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
    /*CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(ctx);*/
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    
    
    //self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2.0;
    self.avatarImageView.layer.borderWidth = 0.5;
    self.avatarImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];//[[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    self.avatarImageView.clipsToBounds = YES;
}

@end
