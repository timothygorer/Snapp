//
//  ChallengeViewModel.h
//  Snap Scramble
//
//  Created by Tim Gorer on 6/20/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface ChallengeViewModel : NSObject

- (void)retrieveCurrentMatches:(void (^)(NSArray *matches, NSError *error))completion;
- (void)retrievePendingMatches:(void (^)(NSArray *matches, NSError *error))completion;
- (void)deleteGame:(PFObject *)gameToDelete completion:(void (^)(BOOL succeeded, NSError *error))completion;

@end
