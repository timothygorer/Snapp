//
//  FriendsTableViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 3/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "Reachability.h"
#import "CreatePuzzleViewController.h"
#import "FriendsViewModel.h"


@interface FriendsTableViewController ()

@property(nonatomic, strong) FriendsViewModel *viewModel;

@end

@implementation FriendsTableViewController

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _viewModel = [[FriendsViewModel alloc] init];
    }
    
    return self;
}

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
    
    [self.viewModel retrieveFriends:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        else {
            self.friends = objects;
            self.mutableFriendsList = [NSMutableArray arrayWithArray:self.friends]; // set mutable list
            [self.tableView reloadData];
            
            [self.viewModel addFounder:^(PFObject* founderUser, NSError* error) {
                if(!error) {
                    if (![self.viewModel isFriend:founderUser friendsList:self.mutableFriendsList]) {
                        [self.mutableFriendsList addObject:founderUser];
                        [self.friendsRelation addObject:founderUser];
                        [self.viewModel saveCurrentUser:^(BOOL succeeded, NSError *error) {
                            if (error) {
                                NSLog(@"Error %@ %@", error, [error userInfo]);
                            }
                            
                            else {
                                NSLog(@"friends list: %@", self.mutableFriendsList);
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Search for a user." message:@"Enter the person's username." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        
        if (textField) {
            [KVNProgress showWithStatus:@"Adding friend..."];
        }
        
        NSString *username = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"text was %@", textField.text);
        NSString *comparisonUsername = [[PFUser currentUser].username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if ([username length] == 0) {
            [KVNProgress dismiss];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Please enter a username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        
        else if ([username isEqualToString:comparisonUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"You cannot play a game with yourself." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        else if (networkStatus == NotReachable) {
            [KVNProgress dismiss];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        // if everything is ok, start searching for the friend
        else {
            [self.viewModel getFriend:username completion:^(PFObject *searchedUser, NSError *error) {
                if (!error) {
                    NSLog(@"trying to add friend: %@", searchedUser);
                    if (searchedUser != nil) { // if the friend exists
                        
                        // if the user isn't already a friend, add him
                        if (![self.viewModel isFriend:searchedUser friendsList:self.mutableFriendsList]) {
                            [self.mutableFriendsList addObject:searchedUser];
                            [self.friendsRelation addObject:searchedUser];
                            [self.viewModel saveCurrentUser:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    [KVNProgress dismiss];
                                    NSLog(@"new friends list: %@", self.mutableFriendsList);
                                    [self.tableView reloadData];
                                }
                            }];
                        }
                        
                        // if the user is already a friend, don't add him
                        else {
                            [KVNProgress dismiss];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"This user is already on your friends list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                    }
                    
                    // if the user doesn't exist, display a message
                    else {
                        [KVNProgress dismiss];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"This user does not exist." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                }
            }];
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
    NSLog(@"opponent: %@", self.opponent);
    
    // delegate allows us to transfer opponent's data back to previous view controller for creating puzzle game
    [self.delegate receiveFriendUserData:self.opponent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createPuzzle"]) {
        CreatePuzzleViewController *createPuzzleViewController = (CreatePuzzleViewController *)segue.destinationViewController;
        createPuzzleViewController.opponent = self.opponent;
    }
}

@end
