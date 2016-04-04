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
    [self.navigationController.navigationBar setHidden:true];
    self.puzzleSizes = [[NSArray alloc] initWithObjects:@"3 x 3", @"4 x 4", @"5 x 5", @"6 x 6", @"7 x 7", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView = [UIImageView new];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0f;

    self.backButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.backButton.titleLabel.minimumScaleFactor = 0.5;
    self.selectPuzzleSizeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.selectPuzzleSizeButton.titleLabel.minimumScaleFactor = 0.5;
    self.sendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.sendButton.titleLabel.minimumScaleFactor = 0.5;

    self.currentUser = [PFUser currentUser];
    
    if (self.image) { // if the image was just created by the player (sender) and is saved in memory
        self.imageView.image = self.image; // preview image
        UIImage* image = self.image; // preview image
        
        // create the image view frame and center it, then add to subview
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        [self.view addSubview:self.imageView];
        [self.view bringSubviewToFront:self.sendButton];
        [self.view bringSubviewToFront:self.backButton];
        [self.view bringSubviewToFront:self.selectPuzzleSizeButton];
        [self.sendButton addTarget:self action:@selector(sendGame:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectPuzzleSizeButton addTarget:self action:@selector(selectPuzzleSizeButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        self.selectPuzzleSizeButton.adjustsImageWhenHighlighted = YES;
    }
    
    else {
        NSLog(@"Some problem.");
    }
}

- (IBAction)selectPuzzleSizeButtonDidPress:(id)sender {
    NSLog(@"....?");
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        
        for(NSInteger i=0 ; i<[picker numberOfComponents] ; i++) {
            self.puzzleSize = [self.puzzleSizes objectAtIndex:[picker selectedRowInComponent:i]];
            NSLog(@"index of puzzle size picker %ld", (long)[picker selectedRowInComponent:i]);
        }
        
        NSLog(@"puzzle size selected: %@", self.puzzleSize);
    }];
    
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Row selection was canceled");
    }];

    //Create picker view controller
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    pickerController.picker.delegate = self;
    pickerController.picker.dataSource = self;
    
    //Now just present the picker controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (IBAction)backButtonDidPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendGame:(id)sender { // after creating game, upload it
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.originalImage != nil) {
        if (self.puzzleSize != nil) { // make sure a puzzle size was chosen in memory
            // UIImage *newImage = [self resizeImage:self.resizedImage toWidth:375.0f andHeight:667.0f]; fix/delete?
            UIImage* tempOriginalImage = self.originalImage;
            fileData = UIImageJPEGRepresentation(tempOriginalImage, 0.6); // compress original image
            fileName = @"image.jpg";
            fileType = @"image";
            self.sendButton.userInteractionEnabled = NO;
            NSLog(@"compressed original image before upload: %@", self.originalImage);
   
            // Adds a status below the circle
            [KVNProgress showWithStatus:@"Uploading..."];
            
            
            PFFile* file; // file
            if ([self.createdGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { // if the receiver has played but the receiver has yet to send back, let him. this is code for the receiver.
                file = [PFFile fileWithName:fileName data:fileData];
                [self.createdGame setObject:self.puzzleSize forKey:@"puzzleSize"];
                [self.createdGame setObject:file forKey:@"file"];
                [self.createdGame setObject:fileType forKey:@"fileType"];
                [self.createdGame setObject:self.opponent forKey:@"receiver"]; // is this necesary?
                [self.createdGame setObject:[PFUser currentUser] forKey:@"sender"]; // is this necessary?
                [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"]; // reset that receiver played
                [self.createdGame setObject:self.opponent.username forKey:@"receiverName"]; // sent back, so set receiver key to the opponent. this changes.
                [self.createdGame setObject:self.opponent.objectId forKey:@"receiverID"];
                [self.createdGame setObject:[PFUser currentUser].username forKey:@"senderName"]; // sent back, so set sender key to current user. this changes.
                [self.createdGame setObject:[[PFUser currentUser] objectId] forKey:@"senderID"];
            }
            
            else if (self.createdGame == nil) { // if the game is a NEWLY created game
                NSLog(@"b");
                self.createdGame = [PFObject objectWithClassName:@"Messages"];
                [self.createdGame setObject:self.puzzleSize forKey:@"puzzleSize"];
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
                            self.sendButton.userInteractionEnabled = YES;
                            [self sendNotificationToOpponent]; // send the push notification
                            [KVNProgress dismiss];
                        }
                    }];
                }
            }];
        }
        else {
            NSLog(@"you didn't choose a size");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Puzzle Size" message:@"Please select a puzzle size." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
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

#pragma mark - UIPickerView code


/* - (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
} */

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.puzzleSizes objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.puzzleSizes count];
}

@end
