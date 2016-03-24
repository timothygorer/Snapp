//
//  HomeViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "HomeViewController.h"
#import "Snap_Scramble-Swift.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.challengeModeButton addTarget:self action:@selector(challengeModeButtonDidPress:) forControlEvents:UIControlEventTouchDown];
    //[self.challengeModeButton addTarget:self action:@selector(challengeModeButtonDidRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.timedModeButton addTarget:self action:@selector(timedModeButtonDidPress:) forControlEvents:UIControlEventTouchDown];
    [self.timedModeButton addTarget:self action:@selector(timedModeButtonDidRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.randomPuzzleButton addTarget:self action:@selector(randomPuzzleButtonDidPress:) forControlEvents:UIControlEventTouchDown];
    [self.randomPuzzleButton addTarget:self action:@selector(randomPuzzleButtonDidRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopWatchModeButton addTarget:self action:@selector(stopWatchModeButtonDidPress:) forControlEvents:UIControlEventTouchDown];
    [self.stopWatchModeButton addTarget:self action:@selector(stopWatchModeButtonDidRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutButton addTarget:self action:@selector(logoutButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.challengeModeButton.adjustsImageWhenHighlighted = NO;
    self.timedModeButton.adjustsImageWhenHighlighted = NO;
    self.randomPuzzleButton.adjustsImageWhenHighlighted = NO;
    self.stopWatchModeButton.adjustsImageWhenHighlighted = NO;
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
   /* NSString *username = @"timmyg99";
    NSString *password = @"";

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        else {
            self.usernameLabel.text = username;
        }
    }]; */
    
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"User"]; // questionable
        [[PFInstallation currentInstallation] saveEventually];
        self.usernameLabel.text = currentUser.username;
    }
    
    else {
        [self performSegueWithIdentifier:@"showSignup" sender:self];
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

/* - (IBAction)challengeModeButtonDidPress:(id)sender {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.1f];
    self.challengeModeButton.transform = CGAffineTransformMakeScale(1.1,1.1);
    [UIView commitAnimations];
}

- (IBAction)challengeModeButtonDidRelease:(id)sender {
    self.challengeModeButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
} */


- (IBAction)timedModeButtonDidPress:(id)sender {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.2f];
    self.timedModeButton.transform = CGAffineTransformMakeScale(1.1,1.1);
    [UIView commitAnimations];
}

- (IBAction)timedModeButtonDidRelease:(id)sender {
    self.timedModeButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (IBAction)randomPuzzleButtonDidPress:(id)sender {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.2f];
    self.randomPuzzleButton.transform = CGAffineTransformMakeScale(1.1,1.1);
    [UIView commitAnimations];
}

- (IBAction)randomPuzzleButtonDidRelease:(id)sender {
    self.randomPuzzleButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (IBAction)stopWatchModeButtonDidPress:(id)sender {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.2f];
    self.stopWatchModeButton.transform = CGAffineTransformMakeScale(1.1,1.1);
    [UIView commitAnimations];
}

- (IBAction)stopWatchModeButtonDidRelease:(id)sender {
    self.stopWatchModeButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (IBAction)logoutButtonDidPress:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showSignup" sender:self];
}

@end
