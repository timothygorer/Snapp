//
//  GameViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetView.h"
#import "PieceView.h"
#import <Parse/Parse.h>
#import "GameOverViewController.h"
#import "Snap_Scramble-Swift.h"
#import "StartPuzzleViewController.h"
#import "GameObject.h"
#import "PuzzleObject.h"

@interface GameViewController : UIViewController

@property (weak, nonatomic) id<StartVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *replyLaterButton;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, strong) PFObject *createdGame;
@property (nonatomic, strong) UIImage *puzzleImage;



@end
