//
//  GameObject.m
//  Snap Scramble
//
//  Created by Tim Gorer on 6/29/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "GameObject.h"

@interface GameObject ()

@end

@implementation GameObject

-(id)initWithPuzzle:(PuzzleObject *)puzzle opponent:(PFUser *)opponent andPFObject:(PFObject *)createdGame {
    self = [super init];
    if (self) {
        self.puzzle = puzzle;
        self.opponent = opponent;
        self.createdGame = createdGame;
        self.isPaused = [NSNumber numberWithBool:false];
        [self setTimer]; // game timer
    }
    
    return self;
}

- (void)pause {
    self.isPaused = [NSNumber numberWithBool:true];
    [self.gameTimer invalidate];
}

- (void)resume {
    NSLog(@"resumed?");
    self.isPaused = [NSNumber numberWithBool:false];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameOver) userInfo:nil repeats:YES];
}

- (void)setTimer {
    self.totalSeconds = [NSNumber numberWithInt:0];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameOver) userInfo:nil repeats:YES];
}

- (void)gameOver {
    if (self.isPaused == [NSNumber numberWithBool:false]) {
        int value = [self.totalSeconds intValue];
        self.totalSeconds = [NSNumber numberWithInt:value + 1];
        [self.gameDelegate updateTimerLabel:self.totalSeconds]; // update timer label so that the time is shown
        // NSLog(@"time: %@", self.totalSeconds);
        if (self.puzzle.puzzleSolved) {
            NSLog(@"solved the puzzle in: %@ seconds", self.totalSeconds);
            [self.gameTimer invalidate];
            NSLog(@"executing here because the puzzle was solved. next step is to update the UI.");
            [self.gameUIDelegate updateToShowStatsButtonUI]; // update to show the stats button
        }
    }
}



@end
