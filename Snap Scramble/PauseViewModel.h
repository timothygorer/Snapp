//
//  PauseViewModel.h
//  Snap Scramble
//
//  Created by Tim Gorer on 8/2/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface PauseViewModel : NSObject


- (void)deleteGame:(PFObject *)gameToDelete completion:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)saveCurrentUser:(void (^)(BOOL succeeded, NSError *error))completion;

@end
