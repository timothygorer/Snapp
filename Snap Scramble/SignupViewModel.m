//
//  SignupViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/28/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "SignupViewModel.h"

@implementation SignupViewModel

- (void)signUpUser:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(BOOL succeeded, NSError *error))completion {
    PFUser *newUser = [PFUser user];
    newUser.username = username;
    newUser.password = password;
    newUser.email = email;
    [newUser signUpInBackgroundWithBlock:completion];
}


@end
