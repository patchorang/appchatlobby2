//
//  InitialScreenViewController.h
//  appchatlobby2
//
//  Created by Eric Ertmann on 9/28/13.
//  Copyright (c) 2013 margarita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface InitialScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *faceScanView;
@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) UIImage *faceImage;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageOutputImageView;
@property (strong, nonatomic) NSTimer *faceImageTimer;
@property (weak, nonatomic) IBOutlet UIButton *joinLobbyButton;

@end
