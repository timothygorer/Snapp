//
//  UserSelectionViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "UserSelectionViewController.h"
#import "Reachability.h"
#import "ChallengeViewController.h"
#import "Snap_Scramble-Swift.h"
#import "RandomUserTableViewController.h"
#import "CreatePuzzleViewController.h"
#import "FriendsTableViewController.h"

@interface UserSelectionViewController ()

@end

@implementation UserSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.friendsListButton addTarget:self action:@selector(openFriendsList:) forControlEvents:UIControlEventTouchUpInside];
   [self.randomUserButton addTarget:self action:@selector(openRandomUserList:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.adjustsImageWhenHighlighted = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:true];
    self.randomUserButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.randomUserButton.titleLabel.minimumScaleFactor = 0.5;
    self.friendsListButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.friendsListButton.titleLabel.minimumScaleFactor = 0.5;
    self.opponentSelectionLabel.adjustsFontSizeToFitWidth = YES;
    self.opponentSelectionLabel.minimumScaleFactor = 0.5;
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

- (IBAction)openFriendsList:(id)sender {
    [self performSegueWithIdentifier:@"selectFriend" sender:self];
}

- (IBAction)openRandomUserList:(id)sender {
    [self performSegueWithIdentifier:@"selectRandomUser" sender:self];
}

- (IBAction)cancelButtonDidPress:(id)sender {
    self.scoreView.animation = @"fall";
    [self.scoreView animate];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"selectRandomUser"]) {
        RandomUserTableViewController *randomUserTableViewController = (RandomUserTableViewController *)segue.destinationViewController;
        randomUserTableViewController.delegate = self;
    }
    
    else if ([segue.identifier isEqualToString:@"selectFriend"]) {
        FriendsTableViewController *friendsTableViewController = (FriendsTableViewController *)segue.destinationViewController;
        friendsTableViewController.delegate = self;
    }
    
    // only called when the delegate receives the random user. Then we can create the game.
    else if ([segue.identifier isEqualToString:@"createPuzzle"]) {
        CreatePuzzleViewController  *createPuzzleViewController = (CreatePuzzleViewController *)segue.destinationViewController;
        createPuzzleViewController.opponent = self.opponent; // random user that was selected
    }
}

#pragma mark - delegate methods

- (void)receiveRandomUserData:(PFUser *)opponent {
    self.opponent = opponent;
    NSLog(@"delegate success. (random) opponent selected: %@", self.opponent);
    [self performSegueWithIdentifier:@"createPuzzle" sender:self];
}

- (void)receiveFriendUserData:(PFUser *)opponent {
    self.opponent = opponent;
    NSLog(@"delegate success. (friend) opponent selected: %@", self.opponent);
    [self performSegueWithIdentifier:@"createPuzzle" sender:self];
}


@end
