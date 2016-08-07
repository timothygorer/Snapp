//
//  FriendsViewModel.h
//  
//
//  Created by Tim Gorer on 7/22/16.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@import Firebase;


@interface FriendsViewModel : NSObject

@property (nonatomic, strong) PFRelation *friendsRelation;

- (id)initWithFriendsRelation:(PFRelation *)friendsRelation;
- (void)retrieveFriends:(void (^)(NSArray *objects, NSError *error))completion;
- (void)getFounder:(void (^)(NSString *founderUser, NSError *error))completion;
- (BOOL)isFriend:(NSString *)user friendsList:(NSMutableArray *)mutableFriendsList;
- (void)setFriends:(NSArray *)friends completion:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)getFriend:(NSString *)username completion:(void (^)(NSString *friend, NSError *error))completion;

@end
