//
//  FriendsViewModel.h
//  
//
//  Created by Tim Gorer on 7/22/16.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface FriendsViewModel : NSObject

@property (nonatomic, strong) PFRelation *friendsRelation;

- (void)retrieveFriends:(void (^)(NSArray *objects, NSError *error))completion;
- (void)addFounder:(void (^)(PFObject *founderUser, NSError *error))completion;
- (BOOL)isFriend:(PFUser *)user friendsList:(NSMutableArray *)mutableFriendsList;
- (void)saveCurrentUser:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)getFriend:(NSString *)username completion:(void (^)(PFObject* friend, NSError *error))completion;

@end
