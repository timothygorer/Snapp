//
//  ChallengeViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol ChallengeVCDelegate <NSObject>
- (void)receiveReplyGameData:(PFObject *)selectedGame andOpponent:(PFUser *)opponent andRound:(PFObject *)roundObject;
@end

@interface ChallengeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ChallengeVCDelegate>

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
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *challengeButton;
@property (nonatomic, strong) PFObject* roundObject;


// background view properties
@property (weak, nonatomic) IBOutlet UIView *backgroundView;




@end
