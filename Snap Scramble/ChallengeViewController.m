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
    //UINib *cellNib = [UINib nibWithNibName:@"SnapScrambleTableViewCell" bundle:[NSBundle mainBundle]];
    //[self.currentGamesTable registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveUserMatches) forControlEvents:UIControlEventValueChanged];
    [self.currentGamesTable addSubview:self.refreshControl];
    [self.headerView addSubview:self.findARandomOpponent];
    [self.headerView addSubview:self.logout];
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
        [self performSegueWithIdentifier:@"showSignup" sender:self];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.currentGamesTable reloadData];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self retrieveUserMatches];
    }
}

- (IBAction)selectUserFromOptions:(id)sender {
    /* NSLog(@"NAHHH");
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
            PFUser *opponent = (PFUser *)[query getFirstObject];
            NSLog(@"Searched for opponent: %@", opponent);
            
            
            if (opponent) {
                NSLog(@"yup");
                self.opponent = opponent;
                [self performSegueWithIdentifier:@"createPuzzle" sender:self];
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
                     completion:nil]; */
    [self performSegueWithIdentifier:@"selectUserOptionsScreen" sender:self];

}

#pragma mark - userMatchesTable code

- (void)retrieveUserMatches {
    PFQuery *currentGamesQuery = [PFQuery queryWithClassName:@"Messages"];
    [currentGamesQuery orderByDescending:@"createdAt"];
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
    [currentPendingGamesQuery orderByDescending:@"createdAt"];
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
    /* if ([self.currentGames count] == 0 && [self.currentPendingGames count] == 0) {
        
        self.emptyTableScreen.image = [UIImage imageNamed:@"empty_table_background"];
        self.emptyTableScreen.frame =  CGRectMake((self.view.frame.size.width - self.emptyTableScreen.image.size.width) / 2,self.view.frame.size.height - self.emptyTableScreen.image.size.height, self.emptyTableScreen.image.size.width, self.emptyTableScreen.image.size.height); // fix, the y part isn't how i want it.
        [self.view addSubview:self.emptyTableScreen];
        self.currentGamesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    } */
    
    if ([self.currentGames count] != 0 || [self.currentPendingGames count] != 0) {
        [self.emptyTableScreen removeFromSuperview];
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

/* - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Your turn";
    
    if (section == 1) {
        return @"Pending";
    }
    
    return nil;
} */


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell.dismissButton.hidden = true; // hide the dismiss button until game over

    

    NSLog(@"what......");
    SnapScrambleTableViewCell *cell = (SnapScrambleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    

    
    
    cell.statusLabel.text = @"Reply now";
    //[cell addSubview:cell.statusLabel];
    //[cell bringSubviewToFront:cell.statusLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    
    UIFont *myFont = [UIFont fontWithName: @"Avenir Next" size: 18.0 ];
    cell.textLabel.font = myFont;
    
    if (indexPath.section == 0) {
        PFObject *aCurrentGame = [self.currentGames objectAtIndex:indexPath.row];
        
        if ([[aCurrentGame objectForKey:@"receiverName"]  isEqualToString:[PFUser currentUser].username]) { // if user is the receiver
            NSString *senderName = [aCurrentGame objectForKey:@"senderName"];
            cell.textLabel.text = [NSString stringWithFormat:@"Your turn vs. %@", senderName];
            //cell.userInteractionEnabled = true;
        }
    }
    
    if (indexPath.section == 1) {
        NSLog(@"sec 1");
        PFObject *aCurrentPendingGame = [self.currentPendingGames objectAtIndex:indexPath.row];
        
        if ([[aCurrentPendingGame objectForKey:@"senderName"]  isEqualToString:[PFUser currentUser].username]) { // if user is the sender
            NSString *opponentName = [aCurrentPendingGame objectForKey:@"receiverName"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@'s turn vs. You", opponentName];
            //cell.userInteractionEnabled = false;
            //cell.dismissButton.hidden = false;
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
                if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { // if the receiver (you) didn't send back
                    [self performSegueWithIdentifier:@"createPuzzle" sender:self]; // if receiver (you) didn't send back yet, let him create another puzzle + play it + send it
                }
                
                else if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:false]) { // if receiver (you) did send back, lets play the sender's next puzzle
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
            [self performSegueWithIdentifier:@"gameOver" sender: self]; //????
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"startPuzzleScreen"]) {
         PreviewPuzzleViewController *previewPuzzleViewController = (PreviewPuzzleViewController *)segue.destinationViewController;
         previewPuzzleViewController.createdGame = self.selectedGame;
         previewPuzzleViewController.opponent = self.opponent; //
         NSLog(@"opponent, 1st segue %@:", self.opponent);
         NSLog(@"OPENED THIS PUZZLE, 1st segue: %@", self.selectedGame);
     }
    
    else if ([segue.identifier isEqualToString:@"createPuzzle"]) {
        CreatePuzzleViewController *createPuzzleViewController = (CreatePuzzleViewController *)segue.destinationViewController;
        NSLog(@"opponent %@:", self.opponent);
        createPuzzleViewController.opponent = self.opponent;
        
        if ([self.selectedGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { // this is the condition if the game already exists but the receiver has yet to send back. he's already played
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
