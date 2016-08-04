//
//  StartPuzzleViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "StartPuzzleViewController.h"
#import "GameViewController.h"
#import "Snap_Scramble-Swift.h"

@interface StartPuzzleViewController ()

@end

@implementation StartPuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.cancelButton addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.adjustsImageWhenHighlighted = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:false];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:true];
    NSLog(@"Screen Width: %f    Screen Height: %f", self.view.frame.size.width, self.view.frame.size.height);
    [self.startPuzzleButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    self.startPuzzleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.startPuzzleButton.titleLabel.minimumScaleFactor = 0.5;
    self.cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.cancelButton.titleLabel.minimumScaleFactor = 0.5;
 

    if (!self.image) { // if the image is being retrieved from the server by the receiving player
        // Adds a status below the circle
        [KVNProgress showWithStatus:@"Downloading..."];
        self.startPuzzleButton.userInteractionEnabled = false;
        [self.startPuzzleButton setTitle:@"Start Puzzle" forState:UIControlStateNormal];
        [[self.createdGame objectForKey:@"file"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                NSLog(@"downloaded image before resizing: %@", image);
                
                // resizing the photo when it's sent from a sender to the receiver. should work for all screen sizes.
                self.image = [self prepareImageForGame:image];
                
                NSLog(@"downloaded image after resizing: %@", self.image);
                self.startPuzzleButton.userInteractionEnabled = true;
                [KVNProgress dismiss];
            }
        }];
    }
}

-(UIImage*)prepareImageForGame:(UIImage*)image {
    if (image.size.height > image.size.width) { // portrait
        image = [self imageWithImage:image scaledToFillSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)]; // portrait; resizing photo so it fits the entire device screen
    }
    
    else if (image.size.width > image.size.height) { // landscape
        image = [self imageWithImage:image scaledToFillSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)]; 
    }
    
    else if (image.size.width == image.size.height) { // square
        image = [self resizeImage:image withMaxDimension:self.view.frame.size.width - 20];
    }
    
    NSLog(@"image after resizing: %@", image);
    return image;
}

- (IBAction)startGame:(id)sender {
    [self performSegueWithIdentifier:@"beginGame" sender:self];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)cancelButtonDidPress:(id)sender {
    self.scoreView.animation = @"fall";
    [self.scoreView animate];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIImage *)resizeImage:(UIImage *)image withMaxDimension:(CGFloat)maxDimension {
    if (fmax(image.size.width, image.size.height) <= maxDimension) {
        return image;
    }
    
    CGFloat aspect = image.size.width / image.size.height;
    CGSize newSize;
    
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension / aspect);
    } else {
        newSize = CGSizeMake(maxDimension * aspect, maxDimension);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"beginGame"]) {
        GameViewController *gameViewController = (GameViewController *)segue.destinationViewController;
        gameViewController.puzzleImage = self.image;
        gameViewController.opponent = self.opponent;
        NSLog(@"opponent %@",gameViewController.opponent);
        gameViewController.createdGame = self.createdGame;
        gameViewController.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate methods

- (void)receiveReplyGameData2:(PFObject *)selectedGame andOpponent:(PFUser *)opponent {
    self.createdGame = selectedGame;
    self.opponent = opponent;
    
    // delegate allows us to transfer user's data back to ChallengeViewController for creating puzzle game, which then sends data to CreatePuzzleVC
    [self.delegate receiveReplyGameData:self.createdGame andOpponent:self.opponent];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
