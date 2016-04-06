//
//  ChallengeViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "ChallengeViewController.h"
#import "PreviewPuzzleViewController.h"
#import "CreatePuzzleViewController.h"
#import "SnapScrambleTableViewCell.h"
#import "Reachability.h"

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentGamesTable.delegate = self;
    self.currentGamesTable.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTheTable" object:nil];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveUserMatches) forControlEvents:UIControlEventValueChanged];
    [self.currentGamesTable addSubview:self.refreshControl];
    [self.headerView addSubview:self.usernameLabel];
    
    self.currentGamesTable.tableHeaderView = self.headerView;
    self.currentGamesTable.delaysContentTouches = NO;
    // self.currentGamesTable.allowsSelection = NO;
    
    // initialize a view for displaying the empty table screen if a user has no games.
     self.emptyTableScreen = [[UIImageView alloc] init];
    [self.challengeButton addTarget:self action:@selector(selectUserFromOptions:) forControlEvents:UIControlEventTouchUpInside];
    self.challengeButton.adjustsImageWhenHighlighted = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:false];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"User"]; // questionable
        [[PFInstallation currentInstallation] saveInBackground];
        [self.currentGamesTable reloadData];
        [self retrieveUserMatches];
        NSString* usernameText = @"Username: ";
        usernameText = [usernameText stringByAppendingString:currentUser.username];
        [self.usernameLabel setText:usernameText];
    }
    
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self]; // show log in screen if user not signed in
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.currentGamesTable reloadData];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self retrieveUserMatches];
    }
}

- (void)reloadTable:(NSNotification *)notification {
    [self retrieveUserMatches];
}

- (IBAction)selectUserFromOptions:(id)sender {
    [self performSegueWithIdentifier:@"selectUserOptionsScreen" sender:self];
}

#pragma mark - userMatchesTable code

- (void)retrieveUserMatches {
    PFQuery *currentGamesQuery = [PFQuery queryWithClassName:@"Messages"];
    [currentGamesQuery orderByDescending:@"updatedAt"];
    [currentGamesQuery whereKey:@"receiverName" equalTo:[PFUser currentUser].username];
    [currentGamesQuery includeKey:@"sender"];
    [currentGamesQuery includeKey:@"receiver"];
    //[currentGamesQuery includeKey:@"file"];
    [currentGamesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        else {
            NSLog(@"howcome1 %@", objects);
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
             }
            
            self.currentGames = objects;
            [self.currentGamesTable reloadData];
        }
    }];
    
    PFQuery *currentPendingGamesQuery = [PFQuery queryWithClassName:@"Messages"];
    [currentPendingGamesQuery orderByDescending:@"updatedAt"];
    [currentPendingGamesQuery whereKey:@"senderName" equalTo:[PFUser currentUser].username];
    [currentPendingGamesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        else {
            NSLog(@"howcome2");
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
            
            self.currentPendingGames = objects;
            [self.currentGamesTable reloadData];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self.currentGames count] == 0 && [self.currentPendingGames count] == 0) {
        
       /*  self.emptyTableScreen.image = [UIImage imageNamed:@"empty_table_background"];
        self.emptyTableScreen.frame =  CGRectMake((self.view.frame.size.width - self.emptyTableScreen.image.size.width) / 2,self.view.frame.size.height - self.emptyTableScreen.image.size.height, self.emptyTableScreen.image.size.width, self.emptyTableScreen.image.size.height); // fix, the y part isn't how i want it. */
        //[self.view addSubview:self.emptyTableScreen];
        self.currentGamesTable.backgroundView = self.backgroundView;
        self.currentGamesTable.backgroundView.hidden = NO;
        self.currentGamesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.currentGamesTable.scrollEnabled = true;
    }
    
    if ([self.currentGames count] != 0 || [self.currentPendingGames count] != 0) {
        //[self.emptyTableScreen removeFromSuperview];
        self.currentGamesTable.backgroundView.hidden = YES;
        self.currentGamesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.currentGamesTable.scrollEnabled = true;
    }
    
    if (section == 0) {
        return [self.currentGames count];
    }
    
    if (section == 1) {
        return [self.currentPendingGames count];
    }
    
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

// deletion functionality
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // current games section
        PFObject *gameToDelete = [self.currentGames objectAtIndex:indexPath.row];
        NSMutableArray* tempCurrentGames = [NSMutableArray arrayWithArray:self.currentGames];
        
        [gameToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                for (PFObject *object in self.currentGames) {
                    if ([object.objectId isEqualToString:gameToDelete.objectId]) {
                        [tempCurrentGames removeObject:object];
                        break;
                    }
                }
                
                self.currentGames = tempCurrentGames;
                [self.currentGamesTable reloadData];
                UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Game deleted successfully." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,  nil];
                [alert show];
            }
        }];
    }
    
    else if (indexPath.section == 1) { // current pending games section
        PFObject *gameToDelete = [self.currentPendingGames objectAtIndex:indexPath.row];
        NSMutableArray* tempCurrentPendingGames = [NSMutableArray arrayWithArray:self.currentGames];
        
        [gameToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                for (PFObject *object in self.currentGames) {
                    if ([object.objectId isEqualToString:gameToDelete.objectId]) {
                        [tempCurrentPendingGames removeObject:object];
                        break;
                    }
                }
                
                self.currentGames = tempCurrentPendingGames;
                [self.currentGamesTable reloadData];
                UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Game deleted successfully." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,  nil];
                [alert show];
            }
        }];
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    UIFont *myFont = [UIFont fontWithName: @"Avenir Next" size: 18.0 ];
    cell.textLabel.font = myFont;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumScaleFactor = 0.5;
    
    if (indexPath.section == 0) { // current games section
        PFObject *aCurrentGame = [self.currentGames objectAtIndex:indexPath.row];
        
        if ([[aCurrentGame objectForKey:@"receiverName"]  isEqualToString:[PFUser currentUser].username]) { // if user is the receiver
            NSString *senderName = [aCurrentGame objectForKey:@"senderName"];
            cell.textLabel.text = [NSString stringWithFormat:@"Your turn vs. %@", senderName];
            if ([aCurrentGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) {
                cell.detailTextLabel.text = @"Your turn to reply";
                NSLog(@"1");
            }
            else if ([aCurrentGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:false]) {
                cell.detailTextLabel.text = @"Your turn to play";
                NSLog(@"2");
            }
        }
    }
    
    if (indexPath.section == 1) { // pending games section
        NSLog(@"sec 1");
        PFObject *aCurrentPendingGame = [self.currentPendingGames objectAtIndex:indexPath.row];
        
        if ([[aCurrentPendingGame objectForKey:@"senderName"]  isEqualToString:[PFUser currentUser].username]) { // if user is the sender
            NSString *opponentName = [aCurrentPendingGame objectForKey:@"receiverName"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@'s turn vs. You", opponentName];
            cell.detailTextLabel.text = @""; // blank text on purpose
        }
    }
    
    return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //self.loadingBox.hidden = NO;
    //[self.cogwheelLoadingIndicator startAnimating];
     
     Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
     NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (indexPath.section == 0) { // all of the user's current games (user is receiver here)
        if (networkStatus == NotReachable) { // if there's no internet
            NSLog(@"There IS NO internet connection");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        else {
            NSLog(@"pressed sec 0 %@", self.selectedGame);
            self.selectedGame = [self.currentGames objectAtIndex:indexPath.row];
            
            if ([[self.selectedGame objectForKey:@"receiverName"]  isEqualToString:[PFUser currentUser].username]) {
                self.opponent = [self.selectedGame objectForKey:@"sender"];
                NSLog(@"OK1.");
                if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { // if the receiver (you) played
                    [self performSegueWithIdentifier:@"createPuzzle" sender:self]; // if receiver (you) played, let him create another puzzle + send it
                }
                
                else if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:false]) { // if receiver (you) didn't play yet
                    [self performSegueWithIdentifier:@"startPuzzleScreen" sender:self];
                }
            }
        }
    }
    
    else if (indexPath.section == 1) { // all of the user's pending games (user is sender here)
        if (networkStatus == NotReachable) {
            NSLog(@"There IS NO internet connection");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        else {
            NSLog(@"pressed sec 1");
            self.selectedGame = [self.currentPendingGames objectAtIndex:indexPath.row];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"startPuzzleScreen"]) {
         StartPuzzleViewController *startPuzzleViewController = (StartPuzzleViewController *)segue.destinationViewController;
        startPuzzleViewController.delegate = self;
         startPuzzleViewController.createdGame = self.selectedGame;
         startPuzzleViewController.opponent = self.opponent; //
         NSLog(@"opponent, 1st segue %@:", self.opponent);
         NSLog(@"OPENED THIS PUZZLE, 1st segue: %@", self.selectedGame);
     }
    
    else if ([segue.identifier isEqualToString:@"createPuzzle"]) {
        CreatePuzzleViewController *createPuzzleViewController = (CreatePuzzleViewController *)segue.destinationViewController;
        NSLog(@"opponent %@:", self.opponent);
        createPuzzleViewController.opponent = self.opponent;
        
        if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { // this is the condition if the game already exists but the receiver has yet to send back. he's already played.
            createPuzzleViewController.createdGame = self.selectedGame;
            NSLog(@"opponent, 2nd segue, %@:", self.opponent);
            NSLog(@"receiver didn't send back");
        }
        
        if (createPuzzleViewController.createdGame != nil) {
            NSLog(@"created THIS PUZZLE receiver didn't send back, 2nd segue %@", createPuzzleViewController.createdGame);
        }
        
        else {
            NSLog(@"created THIS PUZZLE first game, 2nd segue %@", self.selectedGame);
        }
    }
}


#pragma mark - delegate methods

- (void)receiveReplyGameData:(PFObject *)selectedGame andOpponent:(PFUser *)opponent {
    self.opponent = opponent;
    self.selectedGame = selectedGame;
    NSLog(@"delegate success. replying... opponent: %@    game: %@", self.opponent, self.selectedGame);
    [self performSegueWithIdentifier:@"createPuzzle" sender:self]; // if receiver (you) played, let him create another puzzle + send it
}

- (void)showLoginScreen {
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)showSignupScreen {
    [self performSegueWithIdentifier:@"showSignup" sender:self];
}


 /* - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
     cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"CurrentGameButtonUnpressed.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
     UIImageView *pressed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CurrentGameNewGameButton.png"]];
     cell.selectedBackgroundView = pressed;  
    
    
    
    // [cell.layer setMasksToBounds:NO];
    
    //[cell.layer setCornerRadius:10.0f];
    //cell.layer.cornerRadius = 5;
    /* UIView *selectedView = [[UIView alloc]init];
    [selectedView.layer setCornerRadius:5.0f];
    selectedView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:170.0/255.0 blue:235.0/255.0 alpha:100];
    
    cell.selectedBackgroundView =  selectedView;
} */


@end
