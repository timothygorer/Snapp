//
//  PauseViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 8/2/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "PauseViewModel.h"

@implementation PauseViewModel

- (void)deleteGame:(PFObject *)gameToDelete completion:(void (^)(BOOL succeeded, NSError *error))completion {
    [gameToDelete deleteInBackgroundWithBlock:completion];
}

- (void)saveCurrentUser:(void (^)(BOOL succeeded, NSError *error))completion {
    [[PFUser currentUser] saveInBackgroundWithBlock:completion];
}

@end
