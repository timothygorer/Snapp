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


@interface GameViewController () 

@property (nonatomic) NSInteger pieceNum;
@property (strong,nonatomic) NSMutableArray* targets;
@property (strong,nonatomic) NSMutableArray* pieces;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.replyButton.hidden = YES;
    self.replyLaterButton.hidden = YES;
    [self.replyButton addTarget:self action:@selector(replyButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.replyLaterButton addTarget:self action:@selector(replyLaterButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // GAME & PUZZLE INITIALIZATION code
    PuzzleObject *puzzle = [[PuzzleObject alloc] initWithImage:self.puzzleImage andPuzzleSize:[self.createdGame objectForKey:@"puzzleSize"]];
    GameObject *currentGame = [[GameObject alloc] initWithPuzzle:puzzle opponent:self.opponent andPFObject:self.createdGame]; // this line of code creates the game object
    PuzzleView* puzzleView; // puzzle view variable
    puzzleView = [[PuzzleView alloc] initWithGameObject:currentGame andFrame:CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:puzzleView]; // add the puzzle view to the main view


    // Set the delegate
    puzzleView.delegate = self; // set the delegate of the puzzle view to be this view controller so that the pause button segue works
    currentGame.gameDelegate = puzzleView; // this delegate is so that the game object can constantly update the puzzle view's timer label
    currentGame.gameUIDelegate = self; // this delegate is so that the game object can update the UI
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // disable swipe back functionality
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setHidden:true];
}

- (void)updateToGameOverUI {
    // update the UI
    NSLog(@"executing here to update the game over UI");
    self.replyButton.showsTouchWhenHighlighted = YES;
    self.replyLaterButton.showsTouchWhenHighlighted = YES;
    self.replyButton.hidden = NO;
    self.replyLaterButton.hidden = NO;
    [self.view bringSubviewToFront:self.replyButton];
    [self.view bringSubviewToFront:self.replyLaterButton];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gameOver"]) {
        GameOverViewController *gameOverViewController = (GameOverViewController *)segue.destinationViewController;
        gameOverViewController.pieceNum = self.pieceNum;
    }
    
    else if ([segue.identifier isEqualToString:@"pauseMenu"]) {
        PauseViewController *pauseViewController = (PauseViewController *)segue.destinationViewController;
        pauseViewController.createdGame = self.createdGame;
        pauseViewController.opponent = self.opponent;
        NSLog(@"here99");
    }
}

- (IBAction)replyLaterButtonDidPress:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)replyButtonDidPress:(id)sender { // delegate method
    // delegate allows us to transfer user's data back to previous view controller for creating puzzle game
    [self.delegate receiveReplyGameData2:self.createdGame andOpponent:self.opponent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

# pragma mark - delegate method controlling the puzzle view
-(void)puzzleView:(PuzzleView *)view performSegueWithIdentifier:(NSString *)identifier {
    [self performSegueWithIdentifier:identifier sender:self];
}



@end