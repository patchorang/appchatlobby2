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
    
    [self.joinLobbyButton setEnabled:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.cardContainer.layer.cornerRadius = 4;
    self.cardContainer.layer.shadowColor = [[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0] CGColor];
    self.cardContainer.layer.shadowOpacity = 0.7;
    self.cardContainer.layer.shadowOffset = CGSizeMake(0, 0);
    self.cardContainer.layer.shadowRadius = 1.5;
    
    //self.faceScanView.backgroundColor = [UIColor clearColor];
    self.faceScanView.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    self.faceScanView.layer.borderWidth = 0.5;
    self.faceScanView.layer.cornerRadius = 2;
    
    //self.takePictureButton.backgroundColor = [UIColor clearColor];
    self.takePictureButton.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    self.takePictureButton.layer.borderWidth = 0.5;
    self.takePictureButton.layer.cornerRadius = 2;
    
    //self.faceImageOutputImageView.backgroundColor = [UIColor clearColor];
    self.faceImageOutputImageView.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    self.faceImageOutputImageView.layer.borderWidth = 0.5;
    self.faceImageOutputImageView.layer.cornerRadius = 2;
    
    //self.joinLobbyButton.backgroundColor = [UIColor clearColor];
    self.joinLobbyButton.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    self.joinLobbyButton.layer.borderWidth = 0.5;
    self.joinLobbyButton.layer.cornerRadius = 2;
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    
    AVCaptureDevice *inputDevice = [self frontCamera];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ([self.session canAddInput:deviceInput] )
        [self.session addInput:deviceInput];
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *faceScanViewLayer = [self.faceScanView layer];
    [faceScanViewLayer setMasksToBounds:YES];
    [previewLayer setFrame:CGRectMake(0, 0, faceScanViewLayer.bounds.size.width, self.faceScanView.bounds.size.height)];
    [faceScanViewLayer insertSublayer:previewLayer atIndex:0];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePictureButtonPressed:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    //NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer,kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             //NSLog(@"attachements: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         self.faceImage = [[UIImage alloc] initWithData:imageData];
         self.faceImageOutputImageView.image = self.faceImage;
         self.faceImageOutputImageView.transform = CGAffineTransformMakeScale(-1, 1);
         
         [self.joinLobbyButton setEnabled:YES];
         self.joinLobbyButton.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:188.0/255.0 blue:122.0/255.0 alpha:1.0];
         [self.joinLobbyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     }];
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
