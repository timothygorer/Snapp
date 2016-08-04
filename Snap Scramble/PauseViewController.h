//
//  PauseViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 3/27/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Snap_Scramble-Swift.h"
#import "Parse/Parse.h"
#import "GameObject.h"

@interface PauseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton* reportButton;
@property (weak, nonatomic) IBOutlet UIButton* resignButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (weak, nonatomic) IBOutlet SpringView *pauseView;
@property (nonatomic, strong) PFObject *createdGame;
@property (nonatomic, strong) GameObject *game;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, strong) PFRelation *blockedUsersRelation;


@end
