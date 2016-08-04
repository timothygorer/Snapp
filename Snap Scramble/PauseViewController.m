//
//  PauseViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/27/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "PauseViewController.h"
#import "GameViewController.h"
#import "PauseViewModel.h"

@interface PauseViewController ()

@property(nonatomic, strong) PauseViewModel *viewModel;

@end

@implementation PauseViewController

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _viewModel = [[PauseViewModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.resignButton addTarget:self action:@selector(resignButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
      [self.cancelButton addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.reportButton addTarget:self action:@selector(reportButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.adjustsImageWhenHighlighted = NO;
    // pause the timer here. this is for version 2.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:true];
    self.reportButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.reportButton.titleLabel.minimumScaleFactor = 0.5;
    self.resignButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.resignButton.titleLabel.minimumScaleFactor = 0.5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonDidPress:(id)sender {
    self.pauseView.animation = @"fall";
    self.pauseView.delay = 5.0;
    [self.pauseView animate];
    
    //This for loop iterates through all the view controllers in navigation stack.
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[GameViewController class]] ) {
            
            // Here viewController is a reference of UIViewController base class of CreatePuzzleViewController
            // but viewController holds CreatePuzzleViewController  object so we can type cast it here
            GameViewController *gameViewController = (GameViewController *)viewController;
            [gameViewController.game resume]; // resume the timer
            [self.navigationController popToViewController:gameViewController animated:YES];
            break;
        }
    }
}

// delete the game if pressed
- (IBAction)resignButtonDidPress:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game too hard?" message:@"Are you sure you want to delete this game? You may start a new one if this puzzle is too difficult." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.viewModel deleteGame:self.createdGame completion:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            else {
                NSLog(@"game deleted successfully.");
                [self.navigationController popToRootViewControllerAnimated:YES]; // go to main menu
            }
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // cancelled
    }]];
    
    alert.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alert animated:YES
                     completion:nil];
 
}

- (IBAction)reportButtonDidPress:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Report Inappropriate Content" message:@"Are you sure you want to report this user? Reporting them will also block them from sending anymore puzzles to you." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // add code to report / block the user here
        self.blockedUsersRelation = [[PFUser currentUser] relationForKey:@"blockedUsers"];
        [self.blockedUsersRelation addObject:self.opponent];
        
        [self.viewModel saveCurrentUser:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error %@ %@", error, [error userInfo]);
            }
            
            else {
                NSLog(@"blocked users: %@", self.blockedUsersRelation);
            }
        }];
        
        
        NSString *blockedText = [@"Successfully blocked: " stringByAppendingString:self.opponent.username];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Blocked" message:blockedText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // cancelled
    }]];
    
    alert.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alert animated:YES
                     completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
