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
#import "Reachability.h"
#import "ChallengeViewModel.h"

@interface ChallengeViewController ()

@property(nonatomic, strong) ChallengeViewModel *viewModel;

@end

@implementation ChallengeViewController

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _viewModel = [[ChallengeViewModel alloc] init];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:false];
    self.currentGamesTable.delegate = self;
    self.currentGamesTable.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTheTable" object:nil]; // reload the table if the user receives a notification?
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveUserMatches) forControlEvents:UIControlEventValueChanged];
    [self.currentGamesTable addSubview:self.refreshControl];
    [self.headerView addSubview:self.usernameLabel];
    
    self.currentGamesTable.tableHeaderView = self.headerView;
    self.currentGamesTable.delaysContentTouches = NO;
    
    // initialize a view for displaying the empty table screen if a user has no games.
     self.emptyTableScreen = [[UIImageView alloc] init];
    [self.challengeButton addTarget:self action:@selector(selectUserFromOptions:) forControlEvents:UIControlEventTouchUpInside]; // starts an entirely new game if pressed. don't be confused
    self.challengeButton.adjustsImageWhenHighlighted = NO;
    
    
    // check for internet connection, send a friendly message.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) { // if there's no internet
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection. Unfortunately Snap Scramble requires internet to play." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    // this is for push notifications.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"User"]; // questionable
        [[PFInstallation currentInstallation] saveInBackground];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:false];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        [self.currentGamesTable reloadData]; // reload the table view
        [self retrieveUserMatches]; // retrieve all games, both pending and current
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

// this starts an entirely new game, don't be confused.
- (IBAction)selectUserFromOptions:(id)sender {
    [self performSegueWithIdentifier:@"selectUserOptionsScreen" sender:self];
}

#pragma mark - userMatchesTable code

- (void)retrieveUserMatches {
    [self.viewModel retrievePendingMatches:^(NSArray *matches, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        else {
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
            
            self.currentPendingGames = matches;
            [self.currentGamesTable reloadData];
        }
    }];
    
    [self.viewModel retrieveCurrentMatches:^(NSArray *matches, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
        else {
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
            
            self.currentGames = matches;
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
        
        // set the "no games" background image. change this code later on.
        self.currentGamesTable.backgroundView = self.backgroundView;
        self.currentGamesTable.backgroundView.hidden = NO;
        self.currentGamesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.currentGamesTable.scrollEnabled = true;
    }
    
    if ([self.currentGames count] != 0 || [self.currentPendingGames count] != 0) {
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

// a method so that the user can delete games he doesn't want to play anymore
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete rows
    return YES;
}

// deletion functionality
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // current games section
        PFObject *gameToDelete = [self.currentGames objectAtIndex:indexPath.row];
        NSMutableArray* tempCurrentGames = [NSMutableArray arrayWithArray:self.currentGames];
        
        [self.viewModel deleteGame:gameToDelete completion:^(BOOL succeeded, NSError *error) {
            if (!error) {
                for (PFObject *object in self.currentGames) {
                    if ([object.objectId isEqualToString:gameToDelete.objectId]) {
                        [tempCurrentGames removeObject:object];
                        break;
                    }
                }
                
                self.currentGames = tempCurrentGames;
                [self.currentGamesTable reloadData]; // update table view
                UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Game deleted successfully." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,  nil];
                [alert show];
            }
        }];
    }
    
    else if (indexPath.section == 1) { // current pending games section
        PFObject *gameToDelete = [self.currentPendingGames objectAtIndex:indexPath.row];
        NSMutableArray* tempCurrentPendingGames = [NSMutableArray arrayWithArray:self.currentPendingGames];
        
        [self.viewModel deleteGame:gameToDelete completion:^(BOOL succeeded, NSError *error) {
            if (!error) {
                for (PFObject *object in self.currentPendingGames) {
                    if ([object.objectId isEqualToString:gameToDelete.objectId]) {
                        [tempCurrentPendingGames removeObject:object];
                        break;
                    }
                }
                
                self.currentPendingGames = tempCurrentPendingGames;
                [self.currentGamesTable reloadData]; // update table view
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

    // styling the cell
    UIFont *myFont = [UIFont fontWithName: @"Avenir Next" size: 18.0 ];
    cell.textLabel.font = myFont;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumScaleFactor = 0.5;
    
    if (indexPath.section == 0) { // current games section
        PFObject *aCurrentGame = [self.currentGames objectAtIndex:indexPath.row];
        
        // if current user is the receiver for the round
        if ([[aCurrentGame objectForKey:@"receiverName"]  isEqualToString:[PFUser currentUser].username]) {
            NSString *senderName = [aCurrentGame objectForKey:@"senderName"];
            cell.textLabel.text = [NSString stringWithFormat:@"Your turn vs. %@", senderName];
            
            // check if it is the receiver's (the current user in this case) turn to reply or to play for the round
            if ([aCurrentGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) {
                cell.detailTextLabel.text = @"Your turn to reply";
            }
            else if ([aCurrentGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:false]) {
                cell.detailTextLabel.text = @"Your turn to play";
            }
        }
    }
    
    if (indexPath.section == 1) { // pending games section
        PFObject *aCurrentPendingGame = [self.currentPendingGames objectAtIndex:indexPath.row];
        
        // if current user is the sender for the round
        if ([[aCurrentPendingGame objectForKey:@"senderName"]  isEqualToString:[PFUser currentUser].username]) {
            NSString *opponentName = [aCurrentPendingGame objectForKey:@"receiverName"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@'s turn vs. You", opponentName];
            
            // check if it is the receiver's (not the current user in this case) turn to reply or to play for the round
            if ([aCurrentPendingGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) {
                cell.detailTextLabel.text = @"Opponent's turn to reply";
            }
            else if ([aCurrentPendingGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:false]) {
                cell.detailTextLabel.text = @"Opponent's turn to play";
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
     NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    // all of the current user's current games (current user is receiver here)
    if (indexPath.section == 0) {
        if (networkStatus == NotReachable) { // if there's no internet
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection. Unfortunately Snap Scramble requires internet to play." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        else {
            self.selectedGame = [self.currentGames objectAtIndex:indexPath.row];
            
            // if current user is the receiver for the round (just a safety check if statement)
            if ([[self.selectedGame objectForKey:@"receiverName"]  isEqualToString:[PFUser currentUser].username]) {
                self.opponent = [self.selectedGame objectForKey:@"sender"];

                if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { //  this is the condition if the game already exists but the receiver has yet to send back. he's already played.
                    [self performSegueWithIdentifier:@"createPuzzle" sender:self]; // if receiver (you) played, let you create another puzzle, play it, and send it
                }
                
                else if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:false]) { // if receiver (you) didn't play yet
                    [self performSegueWithIdentifier:@"startPuzzleScreen" sender:self];
                } //  we are going to have to get rid of this last part for new version.
            }
        }
    }
    
    // all of the user's pending games (user is sender here)
    else if (indexPath.section == 1) {
        if (networkStatus == NotReachable) {
            NSLog(@"There IS NO internet connection");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Your device appears to not have an internet connection. Unfortunately Snap Scramble requires internet to play." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        else {
            self.selectedGame = [self.currentPendingGames objectAtIndex:indexPath.row];
            // do nothing currently, but in a next version display stats.
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"startPuzzleScreen"]) {
         StartPuzzleViewController *startPuzzleViewController = (StartPuzzleViewController *)segue.destinationViewController;
         startPuzzleViewController.delegate = self;
         startPuzzleViewController.createdGame = self.selectedGame;
         startPuzzleViewController.opponent = self.opponent;
         NSLog(@"Start puzzle screen opening...");
         NSLog(@"opponent: %@   current user selected this game: %@", self.opponent, self.selectedGame);
     }
    
    else if ([segue.identifier isEqualToString:@"createPuzzle"]) {
        CreatePuzzleViewController *createPuzzleViewController = (CreatePuzzleViewController *)segue.destinationViewController;
        createPuzzleViewController.opponent = self.opponent;
        createPuzzleViewController.createdGame = self.selectedGame;
        createPuzzleViewController.roundObject = [self.selectedGame objectForKey:@"round"];
        NSLog(@"create puzzle screen opening... the current user has yet to start a new round by playing and sending back.");
        NSLog(@"opponent: %@   current user selected this game: %@", self.opponent, self.selectedGame);
    }
}


#pragma mark - delegate methods

- (void)receiveReplyGameData:(PFObject *)selectedGame andOpponent:(PFUser *)opponent andRound:(PFObject *)roundObject {
    self.opponent = opponent;
    self.selectedGame = selectedGame;
    self.roundObject = roundObject;
    
    NSLog(@"delegate success. replying... opponent: %@    game: %@", self.opponent, self.selectedGame);
    [self performSegueWithIdentifier:@"createPuzzle" sender:self]; // if receiver (you) played, let him create another puzzle + send it from CreatePuzzleVC
}

- (void)showLoginScreen {
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)showSignupScreen {
    [self performSegueWithIdentifier:@"showSignup" sender:self];
}

@end
