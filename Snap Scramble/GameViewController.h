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

@interface GameViewController : UIViewController

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *previewView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *puzzleImage;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, readwrite) int totalSeconds;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, strong) PFObject *createdGame;
@property (nonatomic, strong) UISegmentedControl *puzzleSizeControl;
@property (nonatomic)BOOL solvedPuzzle;
@property (nonatomic)BOOL puzzleCreated;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) UIImageView* imageView;


- (IBAction)backButtonDidPress:(id)sender;
-(void)createTargetViewInRect: (CGRect)targetRect WithImage: (UIImage*)image
                          num: (NSInteger)pieceNum sideLenX: (CGFloat)sideLengthX sideLenY: (CGFloat)sideLengthY;
-(void)createPieceViewInRect: (CGRect)pieceRect WithImage: (UIImage*)image
                      num: (NSInteger)pieceNum sideLenX: (CGFloat)sideLengthX sideLenY: (CGFloat)sideLengthY;
- (NSMutableArray *)splitImageWith: (UIImage *)image andPieceNum: (int)pieceNum;
-(void)pieceView:(PieceView*)pieceView didDragToPoint: (CGPoint)pt;
//-(void)placePiece:(PieceView*)pieceView atTarget:(TargetView*)targetView;

@end
