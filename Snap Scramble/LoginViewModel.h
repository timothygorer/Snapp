//
//  LoginViewModel.h
//  
//
//  Created by Tim Gorer on 7/28/16.
//
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
@import Firebase;

@interface LoginViewModel : NSObject

- (void)logInUser:(NSString *)email password:(NSString *)password completion:(void (^)(FIRUser *user, NSError *error))completion;


@end
