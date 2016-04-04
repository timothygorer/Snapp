//
//  PauseViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/27/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()

@end

@implementation PauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.solveLaterButton addTarget:self action:@selector(solveLaterButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.resignButton addTarget:self action:@selector(resignButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
      [self.cancelButton addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.adjustsImageWhenHighlighted = NO;
    // pause the timer here. this is for version 2.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonDidPress:(id)sender {
    self.pauseView.animation = @"fall";
    self.pauseView.delay = 5.0;
    [self.pauseView animate];
    // make sure that the game continues where it left off.
    // somehow pass the timer back and resume it. this is for version 2.
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)solveLaterButtonDidPress:(id)sender {
   // save the puzzle progress somehow
   [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)resignButtonDidPress:(id)sender {
    // make current user the sender now.
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
