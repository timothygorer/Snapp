//
//  LoginViewModel.m
//  
//
//  Created by Tim Gorer on 7/28/16.
//
//

#import "LoginViewModel.h"


@implementation LoginViewModel

- (void)logInUser:(NSString *)email password:(NSString *)password completion:(void (^)(FIRUser *user, NSError *error))completion {
    [[FIRAuth auth] signInWithEmail:email password:password completion:completion];
}


@end
