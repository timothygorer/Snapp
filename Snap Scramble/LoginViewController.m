//
//  LoginViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 4/4/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem.backBarButtonItem setTitle:@""];
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.passwordField setDelegate:self];
    [self.usernameField setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:true];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:false];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.passwordField) {
        [theTextField resignFirstResponder];
    }
    
    else if (theTextField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    return YES;
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

- (IBAction)signupScreenButtonDidPress:(id)sender {
    [self performSegueWithIdentifier:@"showSignup" sender:self];
}


- (IBAction)loginButtonDidPress:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [KVNProgress showWithStatus:@"Logging in..."];
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:@"Your e-mail or password don't match an account we have in our database."
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [KVNProgress dismiss];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES]; // go to the main menu
                NSLog(@"User %@ logged in.", user);
                [KVNProgress dismiss];
                self.loginView.animation = @"fall";
                self.loginView.delay = 1.0;
                [self.loginView animate];
            }
        }];
    }
}

@end
