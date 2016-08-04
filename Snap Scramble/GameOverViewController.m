//
//  GameOverViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/27/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "GameOverViewController.h"
#import "ChallengeViewController.h"
#import "Snap_Scramble-Swift.h"

@interface GameOverViewController ()

@end

// this view controller displays stats
@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.doneButton addTarget:self action:@selector(doneButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.adjustsImageWhenHighlighted = NO;
    NSNumber* time = [self.createdGame objectForKey:@"time"];
    NSString *timeString = [NSString stringWithFormat:@"Your time: %@", time];
    self.timeLabelOne.text = timeString;
    self.timeLabelTwo.text = @"opponent's time: 1:23";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:true];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonDidPress:(id)sender {
    self.statsView.animation = @"fall";
    self.statsView.delay = 5.0;
    [self.statsView animate];
    [self.navigationController popToRootViewControllerAnimated:YES]; // go to main menu
}

// set whether current user has to reply or not
/* - (void)updateGame {
    NSLog(@"receiverName: %@    PFUser username: %@     game: %@", [self.createdGame objectForKey:@"receiverName"], [PFUser currentUser].username, self.createdGame);
    if ([[self.createdGame objectForKey:@"receiverName"] isEqualToString:[PFUser currentUser].username]) { // if current user is the receiver (we want the receiver to send back a puzzle)
        [self.createdGame setObject:[NSNumber numberWithBool:true] forKey:@"receiverPlayed"]; // receiver played, set true
        [self.createdGame setObject:self.totalSeconds forKey:@"receiverTime"];
        NSLog(@"current user is the receiver. let him see stats, and then reply or end game. RECEIVER HAS PLAYED");
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else {
                NSLog(@"game updated successfully.");
                [self.gameUIDelegate updateToGameOverUI]; // update the UI
                // [self.gameUIDelegate updateToShowStatsUI];
            }
        }];
    }
    
    else if ([[self.createdGame objectForKey:@"senderName"] isEqualToString:[PFUser currentUser].username]) { // if current user is the sender
        [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"]; // set that the receiver has not played. i did this already in PreviewPuzzleVC, but I'm doing it again here to stop any confusion.
        [self.createdGame setObject:self.totalSeconds forKey:@"senderTime"];
        NSLog(@"current user is not the receiver, he's the sender. let him see stats, switch turns / send a push notification and then go to main menu to wait. RECEIVER HAS NOT PLAYED.");
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else {
                NSLog(@"game updated successfully.");
                [self.gameUIDelegate updateToShowStatsUI];
            }
        }];
    }
} */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
