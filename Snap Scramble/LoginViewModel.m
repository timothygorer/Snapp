//
//  LoginViewModel.m
//  
//
//  Created by Tim Gorer on 7/28/16.
//
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (void)logInUser:(NSString *)username password:(NSString *)password completion:(void (^)(PFUser *user, NSError *error))completion {
    [PFUser logInWithUsernameInBackground:username password:password block:completion];
}

@end
