//
//  LoginViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 4/4/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Snap_Scramble-Swift.h"
#import <KVNProgress/KVNProgress.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet DesignableTextField *usernameField;
@property (weak, nonatomic) IBOutlet DesignableTextField *passwordField;
@property (weak, nonatomic) IBOutlet SpringView *loginView;

- (IBAction)loginButtonDidPress:(id)sender;
- (IBAction)signupScreenButtonDidPress:(id)sender;

@end
