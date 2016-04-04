//
//  GameOverViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/27/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "GameOverViewController.h"
#import "ChallengeViewController.h"
#import "Snap_Scramble-Swift.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.doneButton addTarget:self action:@selector(doneButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.adjustsImageWhenHighlighted = NO;
    NSString *pieceNum = [NSString stringWithFormat:@" / %ld |  Your time: %@", (long)self.pieceNum, [self.createdGame objectForKey:@"time"]];
    self.scoreLabel.text = [self.scoreString stringByAppendingString:pieceNum];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonDidPress:(id)sender {
    self.scoreView.animation = @"fall";
    self.scoreView.delay = 5.0;
    [self.scoreView animate];
    
    //This for loop iterates through all the view controllers in navigation stack.
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        NSLog(@"why");
        //This if condition checks whether the viewController's class is a CreatePuzzleViewController
        // if true that means its the FriendsViewController (which has been pushed at some point)
        if ([viewController isKindOfClass:[ChallengeViewController class]] ) {
            
            // Here viewController is a reference of UIViewController base class of CreatePuzzleViewController
            // but viewController holds CreatePuzzleViewController  object so we can type cast it here
            ChallengeViewController *challengeViewController = (ChallengeViewController *)viewController;
            [self.navigationController popToViewController:challengeViewController animated:YES];
            break;
        }
    }
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
