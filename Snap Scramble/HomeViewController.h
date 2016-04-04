//
//  HomeViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *challengeModeButton;
@property (weak, nonatomic) IBOutlet UIButton *timedModeButton;
@property (weak, nonatomic) IBOutlet UIButton *randomPuzzleButton;
@property (weak, nonatomic) IBOutlet UIButton *stopWatchModeButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end
