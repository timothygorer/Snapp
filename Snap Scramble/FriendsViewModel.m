//
//  FriendsViewModel.m
//  
//
//  Created by Tim Gorer on 7/22/16.
//
//

#import "FriendsViewModel.h"

@implementation FriendsViewModel

- (id)init {
    self = [super init];
    if (self) {
        self.friendsRelation = [[PFUser currentUser] relationForKey:@"friends"];
        
    }
    
    return self;
}

// retrieve all friends on user's friends list
- (void)retrieveFriends:(void (^)(NSArray *objects, NSError *error))completion {
    // load all of the friends on user's friends list
    PFQuery *friendsQuery = [self.friendsRelation query];
    [friendsQuery findObjectsInBackgroundWithBlock:completion];
}

// add the founder of Snap Scramble to the friends list
- (void)addFounder:(void (^)(PFObject *founderUser, NSError *error))completion {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:@"tim"];
    [query getFirstObjectInBackgroundWithBlock:completion];
}

- (BOOL)isFriend:(PFUser *)user friendsList:(NSMutableArray *)mutableFriendsList {
    for(PFUser *friend in mutableFriendsList) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)saveCurrentUser:(void (^)(BOOL succeeded, NSError *error))completion {
    [[PFUser currentUser] saveInBackgroundWithBlock:completion];
}

- (void)getFriend:(NSString *)username completion:(void (^)(PFObject* friend, NSError *error))completion {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:completion];
}


@end
