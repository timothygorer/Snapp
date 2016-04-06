//
//  FriendsTableViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "EditFriendsTableViewController.h"
#import "Reachability.h"
#import "CreatePuzzleViewController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:false];
    NSLog(@"..........");
    self.friendsRelation = [[PFUser currentUser] relationForKey:@"friends"];
    PFQuery *friendsQuery = [self.friendsRelation query];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        else {
            self.friends = objects;
            self.mutableFriendsList = [NSMutableArray arrayWithArray:self.friends]; // set mutable list
            NSLog(@"friends: %@", self.friends);
            [self.tableView reloadData];
            
            // add the founder of Snap Scramble to the friends list
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:@"tim"];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject* founderUser, NSError* error) {
                if(!error) {
                    if (![self isFriend:founderUser]) {
                        [self.mutableFriendsList addObject:founderUser];
                        [self.friendsRelation addObject:founderUser];
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (error) {
                                NSLog(@"Error %@ %@", error, [error userInfo]);
                            }
                            
                            else {
                                NSLog(@"mutable friends list: %@", self.friendsRelation);
                                [self.tableView reloadData];
                            }
                        }];
                    }
                    
                    else {
                        NSLog(@"Good. Founder is already a friend.");
                    }
                }
            }];
        }
    }];
}

- (IBAction)addFriend:(id)sender {
    NSLog(@"NAHHH");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Search for a user." message:@"Enter the person's username." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [KVNProgress showWithStatus:@"Adding friend..."];
        UITextField *textField = alert.textFields[0];
        NSString *username = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"text was %@", textField.text);
        
        NSString *comparisonUsername = [[PFUser currentUser].username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if ([username isEqualToString:comparisonUsername]) {
            [KVNProgress dismiss];
            NSLog(@"Still nope because you're trying to play yourself fam.");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"You cannot play a game with yourself." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            // [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        else if (networkStatus == NotReachable) {
            [KVNProgress dismiss];
            NSLog(@"There IS NO internet connection");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        else {
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:username];
            PFUser *addedFriend = (PFUser *)[query getFirstObject];
            NSLog(@"adding friend: %@", addedFriend);
           
            if (addedFriend) { // if the friend exists
                if (![self isFriend:addedFriend]) { // if the user isn't already a friend, add him
                    NSLog(@"yup");
                    [self.mutableFriendsList addObject:addedFriend];
                    [self.friendsRelation addObject:addedFriend];
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"Error %@ %@", error, [error userInfo]);
                        }
                        
                        else {
                            [KVNProgress dismiss];
                            NSLog(@"WORKS1, mutable friends list: %@", self.friendsRelation);
                            [self.tableView reloadData];
                        }
                    }];
                }
                
                else {
                    [KVNProgress dismiss];
                    NSLog(@"this user is already on your friends list.");
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"This user is already on your friends list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
            else {
                [KVNProgress dismiss];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    UIFont *myFont = [UIFont fontWithName: @"Avenir Next" size: 18.0 ];
    cell.textLabel.font = myFont;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumScaleFactor = 0.5;
    PFUser* friend = [self.mutableFriendsList objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.username;
    
    if ([friend.username isEqualToString:@"tim"]) {
        cell.detailTextLabel.text = @"Snap Scramble founder";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0];
    }
    
    else {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // set this friend as the opponent.
    self.opponent = [self.mutableFriendsList objectAtIndex:indexPath.row];
    
    // delegate allows us to transfer user's data back to previous view controller for creating puzzle game
    [self.delegate receiveFriendUserData:self.opponent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createPuzzle"]) {
        CreatePuzzleViewController *createPuzzleViewController = (CreatePuzzleViewController *)segue.destinationViewController;
        createPuzzleViewController.opponent = self.opponent;
    }
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
