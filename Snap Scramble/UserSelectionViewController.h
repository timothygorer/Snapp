//
//  UserSelectionViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 3/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Snap_Scramble-Swift.h"

@protocol FirstVCDelegate <NSObject>
- (void)receiveRandomUserData:(PFUser *)opponent;
- (void)receiveFriendUserData:(PFUser *)opponent;
@end

@interface UserSelectionViewController : UIViewController <FirstVCDelegate>

// @property (nonatomic, strong) PFUser *opponent;
@property (weak, nonatomic) IBOutlet UIButton *friendsListButton;
@property (weak, nonatomic) IBOutlet UIButton *randomUserButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (weak, nonatomic) IBOutlet SpringView *scoreView;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, strong) IBOutlet UILabel *opponentSelectionLabel;


@end
