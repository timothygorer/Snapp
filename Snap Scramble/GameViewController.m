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
    
    [self createGame]; // this creates the game
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

#pragma  mark - puzzle game methods

- (void)createGame {
    NSInteger size = 0;
    
    self.puzzleSize = [self.createdGame objectForKey:@"puzzleSize"]; // get the puzzle size
    NSLog(@"retrieved puzzle size: %@", self.puzzleSize);
    
    if ([self.puzzleSize isEqualToString:@"3 x 3"]) {
        size = 9;
    }
    
    else if ([self.puzzleSize isEqualToString:@"4 x 4"]) {
        size = 16;
    }

    else if ([self.puzzleSize isEqualToString:@"5 x 5"]) {
        size = 25;
    }
    
    else if ([self.puzzleSize isEqualToString:@"6 x 6"]) {
        size = 36;
    }
    
    else if ([self.puzzleSize isEqualToString:@"7 x 7"]) {
        size = 49;
    }
    
    if (!self.puzzleCreated) {
        [self createPuzzleWithGridSize:size];
    }
    
    else {
        [self deletePuzzle];
        [self createPuzzleWithGridSize:size];
    }
}

- (void)createPuzzleWithGridSize:(NSInteger)size {
    if (self.puzzleImage) { // if the image from the preview controller was assigned to this
        NSLog(@"Puzzle Image Width: %f     Puzzle Image Height: %f", self.puzzleImage.size.width, self.puzzleImage.size.height);
        self.puzzleCreated = true;
        self.pieceNum = size;
        // self.pieceNum = 64;
   
        NSInteger pieceNum = size;
        CGFloat sideLengthY = self.puzzleImage.size.height/sqrt(pieceNum); // sideLengthY is the length of each PieceView/TargetView. Formula: length of photo (or height) divided by # of pieces in Y-axis = sideLengthY (if we want not X by X we need two pieceNums?********** like 7x4. REMEMBER THIS.)
        CGFloat sideLengthX = self.puzzleImage.size.width/sqrt(pieceNum); // sideLengthX is the width of each PieceView/TargetView. Formula: width of photo (or height) divided by # of pieces in X-axis = sideLengthX
        NSLog(@"sideLengthY: %f     sideLengthX: %f", sideLengthY, sideLengthX);
        
        CGRect targetRect;
        CGRect pieceRect;
        
        // resize the photo
        if (self.puzzleImage.size.height > self.puzzleImage.size.width) { // portrait puzzle
            // this is the place of the very first target view.
            targetRect = CGRectMake(0, 0, 200, 200);

            // this is the place of the very first piece view.
            pieceRect = CGRectMake(0, 0, 200, 200);
        }
        
        else if (self.puzzleImage.size.width > self.puzzleImage.size.height) { // landscape puzzle
            targetRect = CGRectMake((self.view.frame.size.width - self.puzzleImage.size.width) / 2, (self.view.frame.size.height - self.puzzleImage.size.height) / 2, 200, 200);
            
            // this is the place of the very first piece view.
            pieceRect = CGRectMake((self.view.frame.size.width - self.puzzleImage.size.width) / 2, (self.view.frame.size.height - self.puzzleImage.size.height) / 2, 200, 200);
        }
        
        else if (self.puzzleImage.size.width == self.puzzleImage.size.height) { // square puzzle
            // this is the place of the very first target view.
            targetRect = CGRectMake((self.view.frame.size.width - self.puzzleImage.size.width) / 2, (self.view.frame.size.height - self.puzzleImage.size.height) / 2, 200, 200);
            
            // this is the place of the very first piece view.
            pieceRect = CGRectMake((self.view.frame.size.width - self.puzzleImage.size.width) / 2, (self.view.frame.size.height - self.puzzleImage.size.height) / 2, 200, 200);
        }
        
     
        // create all of the target views of the puzzle
        [self createTargetViewInRect:targetRect WithImage:nil num:pieceNum sideLenX:sideLengthX sideLenY:sideLengthY];
        
        // create all of the pieces of the puzzle
        [self createPieceViewInRect:pieceRect WithImage:self.puzzleImage num:pieceNum sideLenX:sideLengthX sideLenY:sideLengthY];
    }
    
    else {
        NSLog(@"No image selected.");
    }
}

// create a target view
-(void)createTargetViewInRect:(CGRect)targetRect WithImage:(UIImage *)image num:(NSInteger)pieceNum sideLenX:(CGFloat)sideLengthX sideLenY:(CGFloat)sideLengthY {
    int count = 0; // count the id
    CGFloat x = targetRect.origin.x;
    CGFloat y = targetRect.origin.y;
    NSInteger col = sqrt(pieceNum); // calculate the column number
    NSInteger row = sqrt(pieceNum); // calculate the row number
    for (int i = 0; i < row; i++) {
        x = targetRect.origin.x; // restart each new row (start leftmost)
        for (int j = 0; j < col; j++) {
            TargetView* target = [[TargetView alloc]initWithFrame:CGRectMake(x, y, sideLengthX, sideLengthY)];
            target.backgroundColor = [self colorWithHexString:@"71C7F0"]; /* blue */
            target.targetId = count;
            [self.view addSubview:target];
            [self.targets addObject:target];
            count++;
            x = x + sideLengthX;
            
            if (j == (col - 1) && i == 0) { // if the last column of the first row is being created, put a pause button there
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                 [button addTarget:self
                           action:@selector(pauseButtonDidPress:)
                 forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"Pause" forState:UIControlStateNormal];
                UIFont *myFont = [UIFont fontWithName: @"Avenir Next" size: 18.0 ];
                button.titleLabel.font = myFont;
                button.frame = CGRectMake(0, 0, 60.0, 21.0);
                button.center = target.center;
                button.adjustsImageWhenHighlighted = YES;
                [self.view addSubview:button];
            }
        }
        y = y + sideLengthY;
    }
}

// create a piece view
-(void)createPieceViewInRect:(CGRect)pieceRect WithImage:(UIImage *)image num:(NSInteger)pieceNum sideLenX:(CGFloat)sideLengthX sideLenY:(CGFloat)sideLengthY {
    int count = 0;
    // init a mutableArray with integer from 0 to pieceNum-1
    NSMutableArray* idArray = [[NSMutableArray alloc]initWithCapacity:pieceNum];
    for (int i = 0; i < pieceNum; i++) {
        NSNumber* iWrapped = [NSNumber numberWithInt:i];
        [idArray addObject:iWrapped];
    }
    NSMutableArray* images = [self splitImageWith:image andPieceNum:(int)pieceNum]; // create all of the pieces by slicing the image.
    CGFloat x = pieceRect.origin.x;
    CGFloat y = pieceRect.origin.y;
    NSInteger col = sqrt(pieceNum); // calculate the column number
    NSInteger row = sqrt(pieceNum); // calculate the row number
    for (int i = 0; i < row; i++) {
        x = pieceRect.origin.x; // restart each new row (start leftmost)
        for (int j = 0; j < col; j++) {
            PieceView* piece = [[PieceView alloc]initWithFrame:CGRectMake(x, y, sideLengthX, sideLengthY)];
            piece.dragDelegate = self;
            int randomIndex = arc4random()%([idArray count]); // create random index
            piece.pieceId = [idArray[randomIndex] intValue]; // assign random index to piece
            piece.image = images[piece.pieceId];
            [idArray removeObjectAtIndex:randomIndex]; // remove the object after using so the random index is not reused
            for (TargetView* currentTargetView in self.targets) { // self.targets is the array of TargetViews
                if (CGRectContainsPoint(currentTargetView.frame, piece.center)) {
                    piece.targetView = currentTargetView;
                    if (piece.pieceId == piece.targetView.targetId) { // check if piece is matched to its target
                        piece.isMatched = true; // if matched at beginning, set it to true
                    }
                    else if (piece.pieceId != piece.targetView.targetId) {
                        piece.isMatched = false; // if it's not matched at beginning, set it to false
                    }
                }
            }
            [self.view addSubview:piece];
            [self.pieces addObject:piece];
            x = x + sideLengthX;
        }
        y = y + sideLengthY;
    }
}

- (BOOL)gameOver {
    int count = 0;
    for (PieceView* pv in self.pieces){
        if (pv.isMatched) count++;
    }
    
    NSLog(@"amount of pieces matched: %i", count);
    
    // check if all the pieces are matched. count would be equal to the number of pieces in this case.
    if (count == self.pieceNum) {
        for(PieceView* pv in self.pieces) {
            pv.userInteractionEnabled = NO;
        }
        
        for(TargetView* tv in self.targets) {
            tv.hidden = YES;
        }
        
        NSLog(@"Solved!");
        return YES;
    }
    
    else {
        return NO;
    }
}

// set current user to reply
- (void)updateGame {
    NSLog(@"receiverName: %@    PFUSer username: %@", [self.createdGame objectForKey:@"receiverName"], [PFUser currentUser].username);
    if ([[self.createdGame objectForKey:@"receiverName"] isEqualToString:[PFUser currentUser].username]) { // 1: if user is the receiver and the receiver has already sent back.
        NSLog(@"why %@", self.createdGame);
        NSLog(@"booltest1");
        [self.createdGame setObject:[NSNumber numberWithBool:true] forKey:@"receiverPlayed"]; // receiver played, set true
        NSLog(@"why2 %@", self.createdGame);
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
                NSLog(@"test error");
            }
            else {
                NSLog(@"test");
                [NSThread sleepForTimeInterval:2.0f];
                self.replyButton.hidden = NO;
                self.replyLaterButton.hidden = NO;
                [self.view bringSubviewToFront:self.replyButton];
                [self.view bringSubviewToFront:self.replyLaterButton];
            }
        }];
    }
}

- (void)deletePuzzle {
    for (TargetView* tv in self.targets) {
        [tv removeFromSuperview];
    }
    
    for(PieceView* pv in self.pieces) {
        [pv removeFromSuperview];
    }
    
    self.targets = nil;
    self.pieces = nil;
}

// split the image into pieceNum pieces and return an array
- (NSMutableArray *)splitImageWith: (UIImage *)image andPieceNum: (NSInteger)pieceNum{
    NSMutableArray* images = [NSMutableArray arrayWithCapacity:pieceNum];
    NSInteger side = sqrt(pieceNum);
    CGFloat x = 0.0, y = 0.0;
    CGFloat sideLengthY = self.puzzleImage.size.height/side; // sideLengthY is the length of each PieceView/TargetView. Formula: length of photo (or height) divided by # of pieces in Y-axis = sideLengthY (if we want not X by X we need two pieceNums?********** like 7x4. REMEMBER THIS.)
    CGFloat sideLengthX = self.puzzleImage.size.width/side; // sideLengthX is the width of each PieceView/TargetView. Formula: width of photo (or height) divided by # of pieces in X-axis = sideLengthX
    NSLog(@"sideLengthY: %f     sideLengthX: %f", sideLengthY, sideLengthX);
    
    for (int row = 0; row < side ; row++) {
        x = 0.0;
        for (int col = 0; col < side; col++) {
            CGRect rect = CGRectMake(x, y, sideLengthX, sideLengthY);
            CGImageRef cImage = CGImageCreateWithImageInRect([image CGImage],  rect); // coregraphics method!
            UIImage* dImage = [[UIImage alloc]initWithCGImage:cImage];
            [images addObject:dImage];
            x = x + sideLengthX;
        }
        y = y + sideLengthY;
    }
    return images;
}

// if a piece is dragged, check if it can fit in a TargetView
-(void)pieceView:(PieceView*)currentPieceView didDragToPoint: (CGPoint)pt{
    PieceView* nonCurrentPieceView;
    for (TargetView* currentTargetView in self.targets) { // self.targets is the array of TargetViews
        if (CGRectContainsPoint(currentTargetView.frame, pt)) { // if the piece is dragged near a target
            
            // if it exists, get the (noncurrent) pieceview that's about to be swapped and place it on current pieceview's old targetview
            for (PieceView* aPieceView in self.pieces) {
                if (aPieceView.targetView == currentTargetView) {
                    nonCurrentPieceView = aPieceView; // piece view about to be swapped
                    
                    // place non current piece view on current pieceview's old targetview
                    if (nonCurrentPieceView) {
                        nonCurrentPieceView.targetView = currentPieceView.targetView;
                        nonCurrentPieceView.center = currentPieceView.targetView.center;
                    }
                    
                    break;
                }
            }
            
            // place the current piece view on the nearest target
            currentPieceView.targetView = currentTargetView;
            currentPieceView.center = currentPieceView.targetView.center;
            break;
        }
    }
    
    // check if current piece is matched to its target
    if (currentPieceView.pieceId == currentPieceView.targetView.targetId) {
        currentPieceView.isMatched = true; // if matched, set it to true
        currentPieceView.userInteractionEnabled = false;
    } else{
        currentPieceView.isMatched = false; // if it's not matched, set it to false
    }
    
    // check if non-current piece - the piece being swapped - is matched to its target
    if (nonCurrentPieceView.pieceId == nonCurrentPieceView.targetView.targetId) {
        nonCurrentPieceView.isMatched = true; // if matched, set it to true
        currentPieceView.userInteractionEnabled = false;
    } else{
        nonCurrentPieceView.isMatched = false; // if it's not matched, set it to false
    }
    
    if ([self gameOver]) {
        [self updateGame];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    }
}

- (IBAction)pauseButtonDidPress:(id)sender {
    [self performSegueWithIdentifier:@"pauseMenu" sender: self];
}


- (IBAction)replyLaterButtonDidPress:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)replyButtonDidPress:(id)sender { // delegate method
    // delegate allows us to transfer user's data back to previous view controller for creating puzzle game
    [self.delegate receiveReplyGameData2:self.createdGame andOpponent:self.opponent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - helper methods

// instantiation
-(NSMutableArray*)targets{
    if (!_targets) {
        _targets = [[NSMutableArray alloc] init];
    }
    return _targets;
}

-(NSMutableArray*)pieces{
    if (!_pieces) {
        _pieces = [[NSMutableArray alloc]init];
    }
    return _pieces;
}

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