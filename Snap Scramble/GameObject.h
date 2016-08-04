//
//  GameObject.h
//  Snap Scramble
//
//  Created by Tim Gorer on 6/29/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PuzzleObject.h"

@class PuzzleObject;


@protocol GameDelegate

-(void)updateTimerLabel:(NSNumber*)totalSeconds;

@end

@protocol GameUIDelegate

-(void)updateToGameOverUI;
-(void)updateToShowStatsUI;

@end

@interface GameObject : NSObject

@property (nonatomic, weak) id<GameDelegate> gameDelegate;
@property (nonatomic, weak) id<GameUIDelegate> gameUIDelegate;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSNumber* totalSeconds;
@property (strong,nonatomic) PuzzleObject *puzzle;
@property (nonatomic, strong) PFUser *opponent;
@property (nonatomic, strong) PFObject *createdGame;
@property (nonatomic, strong) NSNumber *isPaused;


- (id)initWithPuzzle:(PuzzleObject *)puzzle opponent:(PFUser *)opponent andPFObject:(PFObject *)createdGame; // start the game
- (NSTimer*)getTimer;
- (void)pause;
- (void)resume;
-(void)setTimer;
-(void)gameOver; // check if user solved puzzle, or if time has run out.
- (void)updateGame;
- (NSInteger)getRound; // ?? delete?

@end
