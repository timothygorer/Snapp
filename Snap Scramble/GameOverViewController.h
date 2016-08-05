//
//  GameOverViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/27/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Snap_Scramble-Swift.h"
#import <Parse/Parse.h>
#import "GameOverViewController.h"

@interface GameOverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *headerStatsLabel;
@property (weak, nonatomic) IBOutlet DesignableTextField *currentUserTimeLabel; // the current user's time label
@property (weak, nonatomic) IBOutlet DesignableTextField *opponentTimeLabel; // the opponent's time label
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet SpringView *statsView;
@property (nonatomic, strong) PFObject *createdGame;
@property (nonatomic, strong) NSNumber* currentUserTotalSeconds;
@property (nonatomic, strong) NSNumber* opponentTotalSeconds;
@property (nonatomic, strong) PFUser* opponent;
@property (nonatomic, strong) PFObject* roundObject;




@end
