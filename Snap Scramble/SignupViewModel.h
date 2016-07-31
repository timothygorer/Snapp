//
//  SignupViewModel.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/28/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@import Firebase;

@interface SignupViewModel : NSObject

- (void)signUpUser:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(FIRUser *user,  NSError *error))completion;

@end
