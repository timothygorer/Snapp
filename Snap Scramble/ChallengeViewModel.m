//
//  ChallengeViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 6/20/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "ChallengeViewModel.h"

@implementation ChallengeViewModel

- (void)retrieveCurrentMatches:(NSString *)username completion:(void (^)(NSArray *matches, NSError *error))completion{
    PFQuery *currentGamesQuery = [PFQuery queryWithClassName:@"Messages"];
    [currentGamesQuery orderByDescending:@"updatedAt"];
    [currentGamesQuery whereKey:@"receiverName" equalTo:username];
    [currentGamesQuery includeKey:@"sender"];
    [currentGamesQuery includeKey:@"receiver"];
    [currentGamesQuery findObjectsInBackgroundWithBlock:completion];
}

- (void)retrievePendingMatches:(NSString *)username completion:(void (^)(NSArray *matches, NSError *error))completion {
    PFQuery *currentPendingGamesQuery = [PFQuery queryWithClassName:@"Messages"];
    [currentPendingGamesQuery orderByDescending:@"updatedAt"];
    [currentPendingGamesQuery whereKey:@"senderName" equalTo:username];
    [currentPendingGamesQuery findObjectsInBackgroundWithBlock:completion];
}



@end
