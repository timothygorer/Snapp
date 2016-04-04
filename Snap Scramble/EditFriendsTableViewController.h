//
//  EditFriendsTableViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 3/6/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsTableViewController : UITableViewController

@property (nonatomic, strong) PFUser *currentUserPFObject;
@property (nonatomic, strong) NSArray *friendsList;
@property (nonatomic, strong) NSMutableArray *mutableFriendsList;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addFriendBarButton;
@property (nonatomic, strong) PFUser *addedFriend;

- (BOOL)isFriend:(PFUser *)user;


@end
