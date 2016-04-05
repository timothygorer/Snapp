//
//  PauseViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/27/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()

@end

@implementation PauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.solveLaterButton addTarget:self action:@selector(solveLaterButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.resignButton addTarget:self action:@selector(resignButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
      [self.cancelButton addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.reportButton addTarget:self action:@selector(reportButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.adjustsImageWhenHighlighted = NO;
    // pause the timer here. this is for version 2.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:true];
    self.solveLaterButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.solveLaterButton.titleLabel.minimumScaleFactor = 0.5;
    self.reportButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.reportButton.titleLabel.minimumScaleFactor = 0.5;
    self.resignButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.resignButton.titleLabel.minimumScaleFactor = 0.5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonDidPress:(id)sender {
    self.pauseView.animation = @"fall";
    self.pauseView.delay = 5.0;
    [self.pauseView animate];
    // make sure that the game continues where it left off.
    // somehow pass the timer back and resume it. this is for version 2.
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)solveLaterButtonDidPress:(id)sender {
   // save the puzzle progress somehow
   [self.navigationController popToRootViewControllerAnimated:YES];
}

// resign this turn if pressed
- (IBAction)resignButtonDidPress:(id)sender {
    // make current user the sender now.
    NSLog(@"Resigned. receiverName: %@    PFUser username: %@", [self.createdGame objectForKey:@"receiverName"], [PFUser currentUser].username);
    if ([[self.createdGame objectForKey:@"receiverName"] isEqualToString:[PFUser currentUser].username]) { // 1: if user is the receiver and the receiver has already sent back.
        [self.createdGame setObject:[NSNumber numberWithBool:true] forKey:@"receiverPlayed"]; // receiver played, set true
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
                NSLog(@"test error");
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES]; // go to main menu
            }
        }];
    }
}

- (IBAction)reportButtonDidPress:(id)sender {
    NSLog(@"NAHHH");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Report Inappropriate Content" message:@"Are you sure you want to report this user? Reporting them will also block them from sending anymore puzzles to you." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // add code to report / block the user here
        self.blockedUsersRelation = [[PFUser currentUser] relationForKey:@"blockedUsers"];
        [self.blockedUsersRelation addObject:self.opponent];
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error %@ %@", error, [error userInfo]);
            }
            
            else {
                NSLog(@"blocked users: %@", self.blockedUsersRelation);
            }
        }];
        
        NSString *blockedText = [@"Successfully blocked: " stringByAppendingString:self.opponent.username];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Blocked" message:blockedText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // cancelled
    }]];
    
    alert.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alert animated:YES
                     completion:nil];
    
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
