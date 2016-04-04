//
//  RandomUserTableViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 4/2/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserSelectionViewController.h"

@class UserSelectionViewController;


@interface RandomUserTableViewController : UITableViewController
@property (weak, nonatomic) id<FirstVCDelegate> delegate;
@property (nonatomic, strong) NSArray *randomUserArray;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end
