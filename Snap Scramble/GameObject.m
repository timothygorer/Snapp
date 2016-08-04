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

- (void)updateGame {
    NSLog(@"receiverName: %@    PFUser username: %@     game: %@", [self.createdGame objectForKey:@"receiverName"], [PFUser currentUser].username, self.createdGame);
    if ([[self.createdGame objectForKey:@"receiverName"] isEqualToString:[PFUser currentUser].username]) { // if current user is the receiver (we want the receiver to send back a puzzle)
        [self.createdGame setObject:[NSNumber numberWithBool:true] forKey:@"receiverPlayed"]; // receiver played, set true
        [self.createdGame setObject:self.totalSeconds forKey:@"receiverTime"];
        NSLog(@"current user is the receiver. let him see stats, and then reply or end game. RECEIVER HAS PLAYED");
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else {
                NSLog(@"game updated successfully.");
                [self.gameUIDelegate updateToGameOverUI]; // update the UI
                // [self.gameUIDelegate updateToShowStatsUI];
            }
        }];
    }
    
    else if ([[self.createdGame objectForKey:@"senderName"] isEqualToString:[PFUser currentUser].username]) { // if current user is the sender
        [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"]; // set that the receiver has not played. i did this already in PreviewPuzzleVC, but I'm doing it again here to stop any confusion.
        [self.createdGame setObject:self.totalSeconds forKey:@"senderTime"];
        NSLog(@"current user is not the receiver, he's the sender. let him see stats, switch turns / send a push notification and then go to main menu to wait. RECEIVER HAS NOT PLAYED.");
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else {
                NSLog(@"game updated successfully.");
                [self.gameUIDelegate updateToShowStatsUI];
            }
        }];
    }
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
            // [self updateGame]; // update the game on the server side
        }
    }
}

@end
