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

- (void)retrieveCurrentMatches:(NSString *)username completion:(void (^)(NSArray *matches, NSError *error))completion;
- (void)retrievePendingMatches:(NSString *)username completion:(void (^)(NSArray *matches, NSError *error))completion;

@end
