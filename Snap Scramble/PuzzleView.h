//
//  PuzzleView.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/6/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleView.h"
#import "PuzzleObject.h"
#import "GameObject.h"
#import "PieceView.h"
#import "TargetView.h"

@class PuzzleObject;
@class PuzzleView;
@class GameObject;

@protocol PuzzleViewDelegate

-(void)puzzleView:(PuzzleView *)view performSegueWithIdentifier:(NSString *)identifier;

@end


@interface PuzzleView : UIView

@property (nonatomic, weak) id<PuzzleViewDelegate> delegate;
@property (strong,nonatomic) PuzzleObject *puzzle;
@property (strong,nonatomic) GameObject *game;
@property (strong,nonatomic) NSMutableArray *targets;
@property (strong,nonatomic) NSMutableArray *pieces;
@property (nonatomic, strong) UILabel *timerLabel;

-(id)initWithGameObject:(GameObject *)gameObject andFrame:(CGRect)frame;
-(void)createVerticalPuzzleWithGridSize:(NSInteger)size;
-(void)createSquarePuzzleWithGridSize:(NSInteger)size;
-(void)createHorizontalPuzzleWithGridSize:(NSInteger)size;
-(void)createVerticalTargetViewInRect:(CGRect)targetRect WithImage:(UIImage *)image num:(NSInteger)pieceNum sideLenX:(CGFloat)sideLengthX sideLenY:(CGFloat)sideLengthY;
-(void)createVerticalPieceViewInRect:(CGRect)pieceRect WithImage:(UIImage *)image num:(NSInteger)pieceNum sideLenX:(CGFloat)sideLengthX sideLenY:(CGFloat)sideLengthY;
-(void)createHorizontalTargetViewInRect:(CGRect)targetRect WithImage:(UIImage *)image num:(NSInteger)pieceNum sideLenX:(CGFloat)sideLengthX sideLenY:(CGFloat)sideLengthY;
-(void)createHorizontalPieceViewInRect:(CGRect)pieceRect WithImage:(UIImage *)image num:(NSInteger)pieceNum sideLenX:(CGFloat)sideLengthX sideLenY:(CGFloat)sideLengthY;
- (NSMutableArray *)splitImageWith: (UIImage *)image andPieceNum: (NSInteger)pieceNum;
-(void)pieceView:(PieceView *)currentPieceView didDragToPoint: (CGPoint)pt;
-(void)updateTimerLabel:(NSNumber*)totalSeconds;
- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size;
-(UIColor*)colorWithHexString:(NSString*)hex;


@end
