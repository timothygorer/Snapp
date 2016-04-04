//
//  CreatePuzzleViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GameViewController.h"
#import "Snap_Scramble-Swift.h"

@interface CreatePuzzleViewController : UIViewController <UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImage* resizedImage;
@property (nonatomic, strong) UIImage* originalImage;
@property (nonatomic, strong) UIImagePickerController* imagePicker;
@property (nonatomic, strong) PFRelation* friendsRelation;
@property (nonatomic, strong) NSArray* friends;
@property (nonatomic, strong) PFUser* currentUser;
@property (nonatomic, strong) PFUser* opponent;
@property (nonatomic, strong) PFObject* createdGame;
@property (weak, nonatomic) IBOutlet UILabel* usernameDisplay;
@property (weak, nonatomic) IBOutlet UIImageView* previewPuzzle;
@property (weak, nonatomic) IBOutlet UIButton* takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton* choosePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) IBOutlet UILabel *createPuzzleLabel;
@property (weak, nonatomic) IBOutlet SpringView *createPuzzleView;


- (void)uploadGame;
- (UIImage *)resizeImage:(UIImage *)image withMaxDimension:(CGFloat)maxDimension;


@end
