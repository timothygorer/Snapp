//
//  EditFriendsTableViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/6/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "EditFriendsTableViewController.h"
#import "Reachability.h"

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.friendsRelation = [[PFUser currentUser] relationForKey:@"friends"];
    self.mutableFriendsList = [NSMutableArray arrayWithArray:self.friendsList];
}

- (IBAction)addFriend:(id)sender {
     NSLog(@"NAHHH");
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Search for a user." message:@"Enter the person's username." preferredStyle:UIAlertControllerStyleAlert];
     [alert addTextFieldWithConfigurationHandler:nil];
     
     [alert addAction: [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     UITextField *textField = alert.textFields[0];
     NSString *username = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSLog(@"text was %@", textField.text);
     
     NSString *comparisonUsername = [[PFUser currentUser].username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     
     Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
     NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
     
     if ([username isEqualToString:comparisonUsername]) {
         NSLog(@"Still nope because you're trying to play yourself fam.");
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"You cannot play a game with yourself." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alertView show];
         // [self.navigationController popToRootViewControllerAnimated:YES];
     }
     
     else if (networkStatus == NotReachable) {
         NSLog(@"There IS NO internet connection");
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alertView show];
     }
     
     else {
         PFQuery *query = [PFUser query];
         [query whereKey:@"username" equalTo:username];
         PFUser *addedFriend = (PFUser *)[query getFirstObject];
         NSLog(@"adding friend: %@", addedFriend);
     
     
     if (addedFriend) {
         NSLog(@"yup");
         self.addedFriend = addedFriend;
         [self.mutableFriendsList addObject:addedFriend];
         [self.friendsRelation addObject:addedFriend];
         [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             if (error) {
                 NSLog(@"Error %@ %@", error, [error userInfo]);
             }
             
             else {
                 NSLog(@"WORKS1, mutable friends list: %@", self.friendsRelation);
                 [self.tableView reloadData];
             }
         }];
     }
     
     else {
         NSLog(@"nope");
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"This user does not exist." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alertView show];
         // [self.navigationController popToRootViewControllerAnimated:YES];
     }
     
     }
     }]];
     
     [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
     NSLog(@"Cancel pressed");
     }]];
     
     alert.popoverPresentationController.sourceView = self.view;
     
     [self presentViewController:alert animated:YES
     completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.mutableFriendsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFUser *user = [self.mutableFriendsList objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.mutableFriendsList objectAtIndex:indexPath.row];
    
    if (![self isFriend:user]) { // add friend if true
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.mutableFriendsList addObject:user];
        [self.friendsRelation addObject:user];
    }
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) { // save
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            NSLog(@"WORKS2, mutable friends list: %@", self.friendsRelation);
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Helper methods

- (BOOL)isFriend:(PFUser *)user {
    for(PFUser *friend in self.mutableFriendsList) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    
    return NO;
}


@end
