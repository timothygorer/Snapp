//
//  GameViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "GameViewController.h"
#import "GameOverViewController.h"
#import "ChallengeViewController.h"
#import "CreatePuzzleViewController.h"
#import "PauseViewController.h"
#import "PuzzleView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "GameViewModel.h"


@interface GameViewController () 

@property (nonatomic) NSInteger pieceNum;
@property (strong,nonatomic) NSMutableArray* targets;
@property (strong,nonatomic) NSMutableArray* pieces;
@property(nonatomic, strong) GameViewModel *viewModel;

@end

@implementation GameViewController


- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _viewModel = [[GameViewModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.statsButton.hidden = YES;
    self.statsButton.userInteractionEnabled = NO;
    [self.view addSubview:self.statsButton];
    self.replyButton.hidden = YES;
    self.replyLaterButton.hidden = YES;
    self.replyButton.userInteractionEnabled = NO;
    self.replyLaterButton.userInteractionEnabled = NO;
    [self.replyButton addTarget:self action:@selector(replyButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.replyLaterButton addTarget:self action:@selector(replyLaterButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // GAME & PUZZLE INITIALIZATION code
    PuzzleObject *puzzle = [[PuzzleObject alloc] initWithImage:self.puzzleImage andPuzzleSize:[self.createdGame objectForKey:@"puzzleSize"]];
    self.game = [[GameObject alloc] initWithPuzzle:puzzle opponent:self.opponent andPFObject:self.createdGame]; // this line of code creates the game object
    PuzzleView* puzzleView; // puzzle view variable
    puzzleView = [[PuzzleView alloc] initWithGameObject:self.game andFrame:CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"stop before here?");
    [self.view addSubview:puzzleView]; // add the puzzle view to the main view


    // Set the delegate
    puzzleView.delegate = self; // set the delegate of the puzzle view to be this view controller so that the pause button segue works
    self.game.gameDelegate = puzzleView; // this delegate is so that the game object can constantly update the puzzle view's timer label
    self.game.gameUIDelegate = self; // this delegate is so that the game object can update the UI
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // disable swipe back functionality
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setHidden:true];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

# pragma mark - delegate method

// pause the timer and perform the segue - this method is called by this VC's delegate in PuzzleView.m
- (void)pause {
    [self.game pause];
    NSLog(@"game is paused");
    [self performSegueWithIdentifier:@"pauseMenu" sender:self];
}

# pragma mark - UI updates

- (void)updateToGameOverUI {
    // update the UI
    NSLog(@"executing here to update the game over UI");
    self.replyButton.showsTouchWhenHighlighted = YES;
    self.replyLaterButton.showsTouchWhenHighlighted = YES;
    self.replyButton.hidden = NO;
    self.replyLaterButton.hidden = NO;
    self.replyLaterButton.userInteractionEnabled = YES;
    self.replyButton.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:self.replyButton];
    [self.view bringSubviewToFront:self.replyLaterButton];
}

- (void)updateToShowStatsUI {
    // update the UI
    NSLog(@"executing here to update the stats UI");
    self.statsButton.showsTouchWhenHighlighted = YES;
    self.statsButton.hidden = NO;
    self.statsButton.userInteractionEnabled = YES;
    self.statsButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Next-Medium" size:17];
    self.statsButton.layer.cornerRadius = 5.0;
    
    // set the button size
    CGRect statsButtonFrame = self.statsButton.frame;
    statsButtonFrame.size = CGSizeMake(295.0, 40.0);
    self.statsButton.frame = statsButtonFrame;
    
    [self.statsButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60)];
    [self.statsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.statsButton setTitle:@"Show Stats" forState:UIControlStateNormal];
    self.statsButton.backgroundColor = [self colorWithHexString:@"71C7F0"]; // blue
    [self.view bringSubviewToFront:self.statsButton];
    [self.statsButton addTarget:self action:@selector(statsButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Navigation

- (IBAction)replyLaterButtonDidPress:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)replyButtonDidPress:(id)sender {
    // delegate allows us to transfer user's data back to previous view controller for creating puzzle game
    [self.delegate receiveReplyGameData2:self.createdGame andOpponent:self.opponent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)statsButtonDidPress:(id)sender {
    // show stats menu and then change turns
    
    self.viewModel = [[GameViewModel alloc] initWithOpponent:self.opponent andGame:self.createdGame];
    [self.viewModel switchTurns]; // switch turns, then update in the cloud
    [self.viewModel saveCurrentGame:^(BOOL succeeded, NSError *error) { // update in the cloud
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else {
            NSLog(@"switched turns. game saved.");
            [self performSegueWithIdentifier:@"showStats" sender:self];
        }
    }];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showStats"]) {
         GameOverViewController *gameOverViewController = (GameOverViewController *)segue.destinationViewController;
        gameOverViewController.createdGame = self.createdGame;
    }
    
    if ([segue.identifier isEqualToString:@"pauseMenu"]) {
        PauseViewController *pauseViewController = (PauseViewController *)segue.destinationViewController;
        pauseViewController.createdGame = self.createdGame;
        pauseViewController.opponent = self.opponent;
    }
}

# pragma mark - color method
// create a hex color
-(UIColor*)colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end