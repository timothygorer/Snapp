//
//  ChallengeViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ChallengeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *currentGames;
@property (nonatomic, strong) NSArray *currentPendingGames;
@property (nonatomic, strong) PFObject *selectedGame;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) IBOutlet UITableView *currentGamesTable;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, strong) NSMutableArray *usernames;
@property(strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *emptyTableScreen;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cogwheelLoadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *loadingBox;
@property (weak, nonatomic) IBOutlet UIButton *findARandomOpponent;
@property (weak, nonatomic) IBOutlet UIButton *logout;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *challengeButton;




@end
