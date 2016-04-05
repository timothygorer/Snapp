//
//  SignupViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Snap_Scramble-Swift.h"
#import <KVNProgress/KVNProgress.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet DesignableTextField *usernameField;
@property (weak, nonatomic) IBOutlet DesignableTextField *passwordField;
@property (weak, nonatomic) IBOutlet DesignableTextField *reenterPasswordField;
@property (weak, nonatomic) IBOutlet DesignableTextField *emailField;
@property (weak, nonatomic) IBOutlet SpringView *signupView;
@property (weak, nonatomic) IBOutlet UIButton *legalButton;


- (IBAction)signupButtonDidPress:(id)sender;
- (IBAction)loginScreenButtonDidPress:(id)sender;


@end
