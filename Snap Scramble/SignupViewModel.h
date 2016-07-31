//
//  SignupViewModel.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/28/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface SignupViewModel : NSObject

- (void)signUpUser:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(BOOL succeeded, NSError *error))completion;

@end
