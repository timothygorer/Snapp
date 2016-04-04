//
//  StartPuzzleViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "StartPuzzleViewController.h"
#import "GameViewController.h"
#import "ChallengeViewController.h"
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

    if (!self.image) { // or, if the image is being retrieved from the server by the receiving player
        // Adds a status below the circle
        [KVNProgress showWithStatus:@"Downloading..."];
        self.startPuzzleButton.userInteractionEnabled = false;
        [self.startPuzzleButton setTitle:@"Start" forState:UIControlStateNormal];
        [[self.createdGame objectForKey:@"file"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                NSLog(@"downloaded image before resizing: %@", image);
                
                // resizing the photo when it's sent from a sender to the receiver. should work for all screen sizes
                if (image.size.height > image.size.width) { // portrait
                    image = [self imageWithImage:image scaledToFillSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                    self.image = image;
                }
                
                else if (image.size.width > image.size.height) { // landscape or square
                    self.image = [self resizeImage:image withMaxDimension:self.view.frame.size.width - 20];
                }
                
                else if (image.size.width == image.size.height) {
                    self.image = [self resizeImage:image withMaxDimension:self.view.frame.size.width - 20];
                }
                
                /* resizing the photo when it's sent from a sender to the receiver. should work for all screen sizes
                if (image.size.height > image.size.width) {  // portrait
                    //image = [self resizeImage:image withMaxDimension:self.view.frame.size.height - 200];
                    self.image = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                    NSLog(@"what1");
                }
                
                else if (image.size.width > image.size.height || image.size.width == image.size.height) {  // landscape or square
                    image = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
                    NSLog(@"what2");
                }*/
                
                
                // set the image, create the image view frame and center it on all screen sizes, then add to subview
                //self.imageView.image = image;
                //self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                //[self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
                //[self.view addSubview:self.imageView];
                NSLog(@"downloaded image after resizing: %@", self.image);
                self.startPuzzleButton.userInteractionEnabled = true;
                [KVNProgress dismiss];
            }
        }];
    }
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
    
    self.scoreView.delay = 5.0;
    [self.scoreView animate];
    
    //This for loop iterates through all the view controllers in navigation stack.
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        NSLog(@"why");
        //This if condition checks whether the viewController's class is a CreatePuzzleViewController
        // if true that means its the FriendsViewController (which has been pushed at some point)
        if ([viewController isKindOfClass:[ChallengeViewController class]] ) {
            
            // Here viewController is a reference of UIViewController base class of CreatePuzzleViewController
            // but viewController holds CreatePuzzleViewController  object so we can type cast it here
            ChallengeViewController *challengeViewController = (ChallengeViewController *)viewController;
            [self.navigationController popToViewController:challengeViewController animated:YES];
            break;
        }
    }
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
    if ([segue.identifier isEqualToString:@"initiateGame"]) {
        GameViewController *gameViewController = (GameViewController *)segue.destinationViewController;
        //gameViewController.puzzleImage = self.imageView.image;
        gameViewController.puzzleImage = self.image;
        // gameViewController.opponent = [self.createdGame objectForKey:@"receiver"]; // idk why this doesn't work. figure it out.... now i know
        gameViewController.opponent = self.opponent;
        NSLog(@"opponent %@",gameViewController.opponent);
        gameViewController.createdGame = self.createdGame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
