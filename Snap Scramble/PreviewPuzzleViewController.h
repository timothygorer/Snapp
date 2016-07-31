//
//  PreviewPuzzleViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <KVNProgress/KVNProgress.h>
#import "RMPickerViewController.h"

@interface PreviewPuzzleViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) PFObject* createdGame;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) PFUser* opponent;
@property (weak, nonatomic) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton* startPuzzleButton;
@property (weak, nonatomic) IBOutlet UIButton* retakePhotoButton;
@property (nonatomic, strong) UIImage* previewImage;
@property (nonatomic, strong) UIImage* originalImage;
@property (nonatomic, strong) PFUser* currentUser;
@property (nonatomic, strong) UIImage* compressedUploadImage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *selectPuzzleSizeButton;
@property (nonatomic, strong) NSArray *puzzleSizes;
@property (nonatomic, strong) NSString *puzzleSize;


@end
