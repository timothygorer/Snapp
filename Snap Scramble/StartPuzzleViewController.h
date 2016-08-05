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
#import "ChallengeViewController.h"

@protocol StartVCDelegate <NSObject>
- (void)receiveReplyGameData2:(PFObject *)selectedGame andOpponent:(PFUser *)opponent andRound:(PFObject *)roundObject;
@end

@interface StartPuzzleViewController : UIViewController <StartVCDelegate>

@property (weak, nonatomic) id<ChallengeVCDelegate> delegate;
@property (nonatomic, strong) PFObject* createdGame;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) PFUser* opponent;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton* startPuzzleButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) PFUser* currentUser;
@property (nonatomic, strong) UIImage* compressedUploadImage;
@property (weak, nonatomic) IBOutlet SpringView *scoreView;
@property (nonatomic, strong) PFObject* roundObject;

@end
