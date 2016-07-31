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
        [self setTimer]; // game timer
    }
    
    return self;
}

- (void)stopTimer {
    
}

- (void)setTimer {
    self.totalSeconds = [NSNumber numberWithInt:0];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameOver) userInfo:nil repeats:YES];
}

// set current user to reply
- (void)updateGame {
    NSLog(@"receiverName: %@    PFUSer username: %@", [self.createdGame objectForKey:@"receiverName"], [PFUser currentUser].username);
    if ([[self.createdGame objectForKey:@"receiverName"] isEqualToString:[PFUser currentUser].username]) { // if user is the receiver and the receiver has already sent back.
        NSLog(@"why %@", self.createdGame);
        NSLog(@"booltest1");
        [self.createdGame setObject:[NSNumber numberWithBool:true] forKey:@"receiverPlayed"]; // receiver played, set true
        NSLog(@"why2 %@", self.createdGame);
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
                NSLog(@"test error");
            }
            else {
                NSLog(@"game updated successfully.");
                [self.gameUIDelegate updateToGameOverUI]; // update the UI
            }
        }];
    }
}

- (void)gameOver {
    int value = [self.totalSeconds intValue];
    self.totalSeconds = [NSNumber numberWithInt:value + 1];
    [self.gameDelegate updateTimerLabel:self.totalSeconds]; // update timer label so that the time is shown
    // NSLog(@"time: %@", self.totalSeconds);
     if (self.puzzle.puzzleSolved) {
         NSLog(@"solved the puzzle in: %@ seconds", self.totalSeconds);
         [self.gameTimer invalidate];
         NSLog(@"executing here because the puzzle was solved. next step is to update the UI.");
         [self updateGame]; // update the game on the server side
     }
}

@end
