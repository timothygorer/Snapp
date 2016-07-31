//
//  LoginViewModel.h
//  
//
//  Created by Tim Gorer on 7/28/16.
//
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface LoginViewModel : NSObject

- (void)logInUser:(NSString *)username password:(NSString *)password completion:(void (^)(PFUser *user, NSError *error))completion;
    


@end
