//
//  PreviewPuzzleViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "PreviewPuzzleViewController.h"
#import "GameViewController.h"
#import "ChallengeViewController.h"

@interface PreviewPuzzleViewController ()

@end

@implementation PreviewPuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView = [UIImageView new];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0f;
    self.currentUser = [PFUser currentUser];
    
    if (self.image) { // if the image was just created by the player (sender) and is saved in memory
        self.imageView.image = self.image; // preview image
        UIImage* image = self.image; // preview image
        
        // create the image view frame and center it, then add to subview
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        [self.view addSubview:self.imageView];
        [self.startPuzzleButton addTarget:self action:@selector(sendGame:) forControlEvents:UIControlEventTouchUpInside];
        [self.startPuzzleButton setTitle:@"Send" forState:UIControlStateNormal];
    }
    
    else {
        NSLog(@"Some problem.");
    }
    
    // back button and retake button set up
    [self.backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchDown];
    self.backButton.adjustsImageWhenHighlighted = NO;
    [self.retakePhotoButton addTarget:self action:@selector(retakePhotoButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.retakePhotoButton.adjustsImageWhenHighlighted = NO;
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

- (IBAction)backButtonDidPress:(id)sender {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.5f];
    self.backButton.transform = CGAffineTransformMakeScale(1.1,1.1);
    [UIView commitAnimations];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)retakePhotoButtonDidPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGame:(id)sender {
    [self performSegueWithIdentifier:@"initiateGame" sender:self]; // start game
}

- (IBAction)sendGame:(id)sender { // after creating game, upload it
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.originalImage != nil) {
        // UIImage *newImage = [self resizeImage:self.resizedImage toWidth:375.0f andHeight:667.0f]; fix/delete?
        UIImage* tempOriginalImage = self.originalImage;
        fileData = UIImageJPEGRepresentation(tempOriginalImage, 0.6); // compress original image
        fileName = @"image.jpg";
        fileType = @"image";
        self.startPuzzleButton.userInteractionEnabled = NO;
        NSLog(@"compressed original image before upload: %@", self.originalImage);
        /* self.cogwheelLoadingIndicator = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.cogwheelLoadingIndicator.center = self.view.center;
        [self.view addSubview:self.cogwheelLoadingIndicator];
        [self.cogwheelLoadingIndicator startAnimating]; */
    
        // NSString *challengePuzzleSize = [NSString stringWithFormat: @"%ld", (long)self.sizeSegmentedControl.selectedSegmentIndex + 5];
        
        // Adds a status below the circle
        [KVNProgress showWithStatus:@"Uploading..."];
       
        
        PFFile* file; // file
        if ([self.createdGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { // if the receiver has played but the receiver has yet to send back, let him. this is code for the receiver.
            file = [PFFile fileWithName:fileName data:fileData];
            [self.createdGame setObject:file forKey:@"file"];
            [self.createdGame setObject:fileType forKey:@"fileType"];
            [self.createdGame setObject:self.opponent forKey:@"receiver"]; // is this necesary?
            [self.createdGame setObject:[PFUser currentUser] forKey:@"sender"]; // is this necessary?
            [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"]; // reset that receiver played
            [self.createdGame setObject:self.opponent.username forKey:@"receiverName"]; // sent back, so set receiver key to the opponent. this changes.
            [self.createdGame setObject:self.opponent.objectId forKey:@"receiverID"];
            [self.createdGame setObject:[PFUser currentUser].username forKey:@"senderName"]; // sent back, so set sender key to current user. this changes.
            [self.createdGame setObject:[[PFUser currentUser] objectId] forKey:@"senderID"];
            NSLog(@"a");
        }
        
        else if (self.createdGame == nil) { // if the game is a newly created game
            NSLog(@"b");
            self.createdGame = [PFObject objectWithClassName:@"Messages"];
            [self.createdGame setObject:[[PFUser currentUser] objectId] forKey:@"senderID"];
            [self.createdGame setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [self.createdGame setObject:self.opponent forKey:@"receiver"]; // is this necesary?
            [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"];
            [self.createdGame setObject:self.opponent.objectId forKey:@"receiverID"];
            [self.createdGame setObject:self.opponent.username forKey:@"receiverName"];
            // [self.createdGame setObject:challengePuzzleSize forKey:@"puzzleSize"];
            [self.createdGame setObject:[PFUser currentUser] forKey:@"sender"]; // is this necessary?
            file = [PFFile fileWithName:fileName data:fileData];
            [self.createdGame setObject:file forKey:@"file"];
            [self.createdGame setObject:fileType forKey:@"fileType"];
        }
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            else {
                [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    
                    else { // sent game
                        NSLog(@"this was the uploaded (created) game: %@", self.createdGame);
                        [self.navigationController popToRootViewControllerAnimated:NO]; // go back to first screen
                        //[self.cogwheelLoadingIndicator stopAnimating];
                        self.startPuzzleButton.userInteractionEnabled = YES;
                        [self sendNotificationToOpponent]; // send the push notification
                        [KVNProgress dismiss];
                    }
                }];
            }
        }];
    }
    
    else {
        NSLog(@"some problem");
    }
}

- (void)sendNotificationToOpponent {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *innerQuery = [PFUser query];
    
    NSLog(@"You sent a notification to: objectID: %@", self.opponent.objectId);
    [innerQuery whereKey:@"objectId" equalTo:self.opponent.objectId];
    
    // Build the actual push notification target query
    PFQuery *query = [PFInstallation query];
    
    // only return Installations that belong to a User that
    // matches the innerQuery
    [query whereKey:@"User" matchesQuery:innerQuery];
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    
    NSString *message = [NSString stringWithFormat:@"%@ has sent you a puzzle!", currentUser.username];
    [push setMessage:message];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          @"cheering.caf", @"sound",
                          nil];
    [push setData:data];
    [push sendPushInBackground];
}

#pragma mark - Navigation

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

@end