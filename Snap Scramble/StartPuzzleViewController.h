//
//  StartPuzzleViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 3/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Snap_Scramble-Swift.h"
#import <Parse/Parse.h>
#import <KVNProgress/KVNProgress.h>

@interface StartPuzzleViewController : UIViewController

@property (nonatomic, strong) PFObject* createdGame;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) PFUser* opponent;
@property (weak, nonatomic) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton* startPuzzleButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) PFUser* currentUser;
@property (nonatomic, strong) UIImage* compressedUploadImage;
@property (weak, nonatomic) IBOutlet SpringView *scoreView;

@end
