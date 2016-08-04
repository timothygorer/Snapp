//
//  ChallengeViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 6/20/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "ChallengeViewModel.h"

@implementation ChallengeViewModel

- (void)retrieveCurrentMatches:(void (^)(NSArray *matches, NSError *error))completion{
    PFQuery *currentGamesQuery = [PFQuery queryWithClassName:@"Messages"];
    [currentGamesQuery orderByDescending:@"updatedAt"];
    [currentGamesQuery whereKey:@"receiverName" equalTo:[PFUser currentUser].username];
    [currentGamesQuery includeKey:@"sender"]; // delete?
    [currentGamesQuery includeKey:@"receiver"]; // delete?
    [currentGamesQuery findObjectsInBackgroundWithBlock:completion];
}

- (void)retrievePendingMatches:(void (^)(NSArray *matches, NSError *error))completion {
    PFQuery *currentPendingGamesQuery = [PFQuery queryWithClassName:@"Messages"];
    [currentPendingGamesQuery orderByDescending:@"updatedAt"];
    [currentPendingGamesQuery whereKey:@"senderName" equalTo:[PFUser currentUser].username];
    [currentPendingGamesQuery findObjectsInBackgroundWithBlock:completion];
}

- (void)deleteGame:(PFObject *)gameToDelete completion:(void (^)(BOOL succeeded, NSError *error))completion {
    [gameToDelete deleteInBackgroundWithBlock:completion];
}



@end
