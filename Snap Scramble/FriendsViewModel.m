//
//  FriendsViewModel.m
//  
//
//  Created by Tim Gorer on 7/22/16.
//
//

#import "FriendsViewModel.h"
@import Firebase;

@implementation FriendsViewModel

- (id)initWithFriendsRelation:(PFRelation *)friendsRelation {
    self = [super init];
    if (self) {
        self.friendsRelation = friendsRelation;
    }
    
    return self;
}

// retrieve all friends on user's friends list
- (void)retrieveFriends:(void (^)(NSArray *objects, NSError *error))completion {
    NSString *username = [[FIRAuth auth] currentUser].displayName;
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *userRef = [[ref child:@"users"] child:username];
    [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *snapshotDict = snapshot.value;
        if (snapshotDict && snapshotDict[@"friends"]) {
            completion(snapshotDict[@"friends"], nil);
        } else {
            completion(@[], nil);
        }
    }
    withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

// get the founder of Snap Scramble to add to the current user's friends list later
- (void)getFounder:(void (^)(NSString *founderUser, NSError *error))completion {
    completion(@"timg101", nil);
}

- (BOOL)isFriend:(NSString *)user friendsList:(NSMutableArray *)mutableFriendsList {
    for (NSString *friend in mutableFriendsList) {
        if ([friend isEqualToString:user]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setFriends:(NSMutableArray *)friends completion:(void (^)(BOOL succeeded, NSError *error))completion {
    NSString *username = [[FIRAuth auth] currentUser].displayName;
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *userRef = [[ref child:@"users"] child:username];
    [userRef setValue:@{@"friends": friends} withCompletionBlock:^(NSError *__nullable error, FIRDatabaseReference *ref) {
        if (error) {
            completion(false, error);
        } else {
            completion(true, nil);
        }
    }];
}

- (void)getFriend:(NSString *)username completion:(void (^)(NSString* friend, NSError *error))completion {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *userRef = [[ref child:@"users"] child:username];
    [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *snapshotDict = snapshot.value;
        if (![snapshotDict isEqual:[NSNull null]]) {
            completion(username, nil);
        } else {
            completion(nil, [NSError errorWithDomain:@"signup" code:500 userInfo:@{NSLocalizedDescriptionKey: @"User does not exist"}]);
        }
    }];
}


@end
