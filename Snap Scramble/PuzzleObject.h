//
//  PuzzleObject.h
//  Snap Scramble
//
//  Created by Tim Gorer on 6/30/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TargetView.h"
#import "PieceView.h"
#import "PuzzleView.h"
#import "GameViewController.h"

@class PuzzleView;

@interface PuzzleObject : NSObject

@property (nonatomic, strong) UIImage *puzzleImage;
@property (nonatomic, strong) NSString *puzzleSizeString;
@property (nonatomic) NSInteger numberofPieces;
@property (strong,nonatomic) NSMutableArray *targets;
@property (strong,nonatomic) NSMutableArray *pieces;


-(id)initWithImage:(UIImage *)image andPuzzleSize:(NSString *)puzzleSizeString;
-(NSInteger)getNumberOfPieces;
- (void)deletePuzzle;
- (BOOL)puzzleSolved;





@end
