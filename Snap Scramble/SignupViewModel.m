//
//  SignupViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/28/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "SignupViewModel.h"


@implementation SignupViewModel

- (void)signUpUser:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(FIRUser *user,  NSError *error))completion {
    [[FIRAuth auth]
     createUserWithEmail:email
     password:password
     completion:completion
         // ...
     ];
}



@end
