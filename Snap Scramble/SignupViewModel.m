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
     completion:^(FIRUser *user, NSError *error) {
         FIRDatabaseReference *ref = [[FIRDatabase database] reference];
         FIRDatabaseReference *userRef = [[ref child:@"users"] child:username];
         [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
             NSDictionary *snapshotDict = snapshot.value;
             if (![snapshotDict isEqual:[NSNull null]]) {
                 NSLog(@"user already exists!");
                 completion(nil, [NSError errorWithDomain:@"signup" code:500 userInfo:@{NSLocalizedDescriptionKey: @"User already exists"}]);
             } else {
                 [userRef setValue:@{@"uid": user.uid}];
                 FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
                 changeRequest.displayName = username;
                 [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
                     if (error) {
                         completion(nil, error);
                     } else {
                         completion(user, nil);
                     }
                 }];
             }
         }
       withCancelBlock:^(NSError * _Nonnull error) {
           NSLog(@"%@", error.localizedDescription);
       }];
     }];
}




@end
