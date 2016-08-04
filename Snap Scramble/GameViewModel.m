//
//  GameViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 8/2/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "GameViewModel.h"

@implementation GameViewModel

-(id)initWithOpponent:(PFUser *)opponent andGame:(PFObject *)createdGame {
    self = [super init];
    if (self) {
        self.opponent = opponent;
        self.createdGame = createdGame;
    }
    
    return self;
}


// change the turn - make the receiver the opponent
- (void)switchTurns {
    [self.createdGame setObject:self.opponent.objectId forKey:@"receiverID"];
    [self.createdGame setObject:self.opponent.username forKey:@"receiverName"];
}


// save the game cloud object
- (void)saveCurrentGame:(void (^)(BOOL succeeded, NSError *error))completion {
    [self.createdGame saveInBackgroundWithBlock:completion];
}

@end
