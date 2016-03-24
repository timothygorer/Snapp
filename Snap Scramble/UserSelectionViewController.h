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

@interface UserSelectionViewController : UIViewController

// @property (nonatomic, strong) PFUser *opponent;
@property (weak, nonatomic) IBOutlet UIButton *friendsListButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (weak, nonatomic) IBOutlet SpringView *scoreView;

@end
