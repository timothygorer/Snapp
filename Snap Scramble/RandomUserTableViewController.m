//
//  RandomUserTableViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 4/2/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "RandomUserTableViewController.h"
#import "CreatePuzzleViewController.h"
 

@interface RandomUserTableViewController ()

@end

@implementation RandomUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startRandomUserSearch];
    [self findRandomUsers]; // creates a list of 20 random users searching for a game.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(findRandomUsers) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self startRandomUserSearch];
    [self findRandomUsers]; // creates a list of 20 random users searching for a game.
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.isMovingFromParentViewController) {
        [self stopRandomUserSearch];
    }
}


- (void)findRandomUsers {
    [self startRandomUserSearch]; // this is just in case (for if the user closes the app)
     PFQuery *query = [PFUser query];
     [query whereKey:@"username" notEqualTo:[PFUser currentUser].username];
     [query whereKey:@"searchingForGame" equalTo:[NSNumber numberWithBool:YES]];
     [query orderByAscending:@"editedAt"]; // order the users from oldest game searchers to newest searchers
     query.limit = 20;
     [query findObjectsInBackgroundWithBlock:^(NSArray *randomUserArray, NSError *error) {
         if (error) {
         }
         else {
             if ([self.refreshControl isRefreshing]) {
                 [self.refreshControl endRefreshing];
             }
             
             self.randomUserArray = [NSArray arrayWithArray:randomUserArray];
             [self.tableView reloadData];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.randomUserArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UIFont *myFont = [UIFont fontWithName: @"Avenir Next" size: 18.0 ];
    cell.textLabel.font = myFont;
    PFUser *randomUser = [self.randomUserArray objectAtIndex:indexPath.row];
    NSString *randomUserName = [randomUser objectForKey:@"username"];
    cell.textLabel.text = randomUserName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopRandomUserSearch];
    self.opponent = [self.randomUserArray objectAtIndex:indexPath.row]; // this was the random user selected

    // delegate allows us to transfer user's data back to previous view controller for creating puzzle game
    [self.delegate receiveRandomUserData:self.opponent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - current user methods

- (void)stopRandomUserSearch {
    [[PFUser currentUser] setObject:[NSNumber numberWithBool:NO] forKey:@"searchingForGame"]; // set it so current user isn't searching for a random user anymore
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (void)startRandomUserSearch {
    [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"searchingForGame"]; // set it so current user isn't searching for a random user anymore
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"createPuzzle"]) {
        CreatePuzzleViewController *createPuzzleViewController = (CreatePuzzleViewController *)segue.destinationViewController;
        createPuzzleViewController.opponent = self.opponent;
    }
}


@end
