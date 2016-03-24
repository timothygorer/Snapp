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
#import <MobileCoreServices/UTCoreTypes.h>


@interface GameViewController () 

@property (nonatomic) NSInteger pieceNum;
@property (strong,nonatomic) NSMutableArray* targets;
@property (strong,nonatomic) NSMutableArray* pieces;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [UIImageView new];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5.0f;
    
    self.imageView.image = self.puzzleImage; // preview image
    
    // create the image view frame and center it, then add to subview
    self.imageView.frame = CGRectMake(0, 0, self.puzzleImage.size.width, self.puzzleImage.size.height);
    [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    [self.view addSubview:self.imageView];
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
    
    // count label creation
    self.countLabel = [UILabel new];
    self.countLabel.frame = CGRectMake(80.0, 475, 160.0, 40.0);
    [self.view addSubview:self.countLabel];
    
    // preview button creation and preview view creation
    UIButton *showPreviewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showPreviewButton addTarget:self action:@selector(showPreview) forControlEvents:UIControlEventTouchUpInside];
    [showPreviewButton setTitle:@"Show Preview" forState:UIControlStateNormal];
    showPreviewButton.frame = CGRectMake(80.0, 470, 160.0, 40.0);
    // [self.view addSubview:showPreviewButton]; commented out
    self.previewView = [UIImageView new];
    self.previewView.frame = CGRectMake(50, 100, 250.0, 250.0);
    
    // back button stuff
    self.backButton.adjustsImageWhenHighlighted = NO;
    
    // timer creation and start
    self.timerLabel = [UILabel new];
    self.timerLabel.frame = CGRectMake(190, 20, 160.0, 40.0);
    [self.view addSubview:self.timerLabel];
    [self setTimer];
    
    // puzzle size control button creation
    NSArray *itemArray = [NSArray arrayWithObjects: @"3 x 3", @"4 x 4", @"5 x 5", @"6 x 6", @"7 x 7", nil];
    self.puzzleSizeControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    // self.puzzleSizeControl.frame = CGRectMake(35, 520, 250, 20); 5S
    
    // these two lines of code place the size control module so that it fits all screen sizes
    self.puzzleSizeControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, 20);
     [self.puzzleSizeControl setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 40)];
    
    [self.puzzleSizeControl addTarget:self action:@selector(setPuzzleSize) forControlEvents:UIControlEventValueChanged]; // this is what happens when the user chooses the puzzle size he/she wants
    [self.view addSubview:self.puzzleSizeControl];
}


- (void)setPuzzleSize {
    NSInteger size;
    if (self.puzzleSizeControl.selectedSegmentIndex == 0) {
        size = 9;
        if (!self.puzzleCreated) {
            [self createPuzzleWithGridSize:size];
        }
        else {
            [self deletePuzzle];
            [self createPuzzleWithGridSize:size];
            
        }
    }
    else if (self.puzzleSizeControl.selectedSegmentIndex == 1) {
        size = 16;
        if (!self.puzzleCreated) {
            [self createPuzzleWithGridSize:size];
        }
        else {
            [self deletePuzzle];
            [self createPuzzleWithGridSize:size];
        }
    }
    else if (self.puzzleSizeControl.selectedSegmentIndex == 2) {
        size = 25;
        if (!self.puzzleCreated) {
            [self createPuzzleWithGridSize:size];
        }
        else {
            [self deletePuzzle];
            [self createPuzzleWithGridSize:size];
        }
    }
    else if (self.puzzleSizeControl.selectedSegmentIndex == 3) {
        size = 36;
        if (!self.puzzleCreated) {
            [self createPuzzleWithGridSize:size];
        }
        else {
            [self deletePuzzle];
            [self createPuzzleWithGridSize:size];
        }
    }
    else if (self.puzzleSizeControl.selectedSegmentIndex == 4) {
        size = 49;
        if (!self.puzzleCreated) {
            [self createPuzzleWithGridSize:size];
        }
        else {
            [self deletePuzzle];
            [self createPuzzleWithGridSize:size];
        }
    }
    // self.puzzleSizeControl.userInteractionEnabled = false;
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
        
        CGRect targetRect; // *** does this really have to be a CGRect? fix?
        
        // this is the place of the very first target view.
        targetRect = CGRectMake((self.view.frame.size.width - self.puzzleImage.size.width) / 2, (self.view.frame.size.height - self.puzzleImage.size.height) / 2, 200, 200); // this code makes it so that the puzzle is actually set up centered on all screen sizes.
        // create the actual puzzle itself which is just many target views.
        [self createTargetViewInRect:targetRect WithImage:nil num:pieceNum sideLenX:sideLengthX sideLenY:sideLengthY];
        
        // this is the place of the very first piece view.
        CGRect pieceRect = CGRectMake((self.view.frame.size.width - self.puzzleImage.size.width) / 2, (self.view.frame.size.height - self.puzzleImage.size.height), 200, 200); // I don't think the 200 does anything. fix.
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
    // CGFloat space = 0;
    for (int i = 0; i < row; i++) {
        x = pieceRect.origin.x; // restart each new row (start leftmost)
        for (int j = 0; j < col; j++) {
            if (count < pieceNum) {
                // PieceView* piece = [[PieceView alloc]initWithFrame:CGRectMake(20, 475, sideLength+20, sideLength+20)];
                PieceView* piece = [[PieceView alloc]initWithFrame:CGRectMake(x, y, sideLengthX, sideLengthY)];
                piece.dragDelegate = self;
                int randomIndex = arc4random()%([idArray count]);
                piece.pieceId = [idArray[randomIndex] intValue];
                piece.image = images[piece.pieceId];
                [idArray removeObjectAtIndex:randomIndex]; // remove the index after using
                [self.view addSubview:piece];
                [self.pieces addObject:piece];
                count++;
                x = x + sideLengthX;
            }
        }
        y = y + sideLengthY;
    }
}

#pragma mark - Timer methods

- (void)setTimer {
    self.totalSeconds = 0;
    NSTimer *gameTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(gameOver:)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)gameOver:(NSTimer *)timer
{
    self.totalSeconds++;
    self.timerLabel.text = [NSString stringWithFormat:@"%i", self.totalSeconds];
    
    if (self.solvedPuzzle) {
        [timer invalidate];
        NSLog(@"receiverName: %@    PFUSer username: %@", [self.createdGame objectForKey:@"receiverName"], [PFUser currentUser].username);
        if ([[self.createdGame objectForKey:@"receiverName"] isEqualToString:[PFUser currentUser].username]) { // 1: if user is the receiver and the receiver has already sent back.
            NSLog(@"why %@", self.createdGame);
            NSLog(@"booltest1");
            [self.createdGame setObject:[NSString stringWithFormat:@"%i", self.totalSeconds] forKey:@"time"];
            [self.createdGame setObject:[NSNumber numberWithBool:true] forKey:@"receiverPlayed"]; // receiver played, set true
            NSLog(@"why2 %@", self.createdGame);
            [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alertView show];
                    NSLog(@"test error");
                }
                else {
                    NSLog(@"test");
                }
            }];
        }
        [self performSegueWithIdentifier:@"gameOver" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gameOver"]) {
        GameOverViewController *gameOverViewController = (GameOverViewController *)segue.destinationViewController;
        gameOverViewController.pieceNum = self.pieceNum;
        gameOverViewController.scoreString = self.countLabel.text;
    }
}

- (void)showPreview {
    if (self.puzzleImage) {
        self.previewView.image = self.puzzleImage;
        [self.view addSubview:self.previewView];
    }
    
    else {
        NSLog(@"No image selected.");
    }
}

- (void)hidePreview {
    self.previewView.image = nil;
}

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

- (IBAction)backButtonDidPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
            CGImageRef cImage = CGImageCreateWithImageInRect([image CGImage],  rect); // coregraphics method! review
            UIImage* dImage = [[UIImage alloc]initWithCGImage:cImage];
            [images addObject:dImage];
            x = x + sideLengthX;
        }
        y = y + sideLengthY;
    }
    return images;
}

// if a piece is dragged, check if it can fit in a TargetView
-(void)pieceView:(PieceView*)pieceView didDragToPoint: (CGPoint)pt{
    NSLog(@"pieceView x-coordinate: %f    pieceView y-coordinateeee: %f", pieceView.frame.origin.x, pieceView.frame.origin.y);
    TargetView* targetView = nil;
    int targetCount = 0;
    // go through the array and find out if any of the TargetViews have the PieceView on them. If yes, save that TargetView.
    for (TargetView* currentTargetView in self.targets) { // self.targets is the array of TargetViews
        if (CGRectContainsPoint(currentTargetView.frame, pt)) { // if the piece is dragged near a target (if the TargetView has the PieceView's current point in it)
            if (pieceView.targetView != nil) { // if piece has an OLD target already and is dragged to a new target, we empty out that old target and reset the .targetView variable (B)
                pieceView.targetView.filled = false;
                NSLog(@"part1");
            }
            
            if (currentTargetView.filled == false) { // now we check if the NEW target is empty or not to find out if we can place the piece there. this works for either the very first step (pieceView.targetView == nil, we don't do any resets), or if we're moving the piece from an old to new target (pieceView.targetView != nil). (A,B)
                pieceView.targetView = currentTargetView;
                pieceView.targetView.filled = true;
                pieceView.center = pieceView.targetView.center;
                NSLog(@"part2");
                break;
            }
            
            else if (currentTargetView.filled == true) { // if the NEW target isn't empty, we do nothing (C)
                NSLog(@"part3");
                break;
            }
        }
        
        else {
            targetCount++;
            NSLog(@"count: %@", [NSNumber numberWithInt:targetCount]);
        }
    }
    
    NSLog(@"part4: targetCount: %d", targetCount);
    if (targetCount == self.pieceNum) { // we do this to find out if the piece hasn't been dragged to a new target (targetCount will be equal to the amount of pieces because for loop cycles through entirely). if the piece isn't being dragged near a new target, we empty out its old target (and don't assign it to a new one, which is the point) (D)
        NSLog(@"part5");
        pieceView.targetView.filled = false;
    }
    
    NSLog(@"%ld", (long)targetView.targetId);
    if (pieceView.pieceId == pieceView.targetView.targetId) { // check if piece is matched to its target
        pieceView.isMatched = true; // if matched, set it to true
    } else{
        pieceView.isMatched = false; // if it's not matched, set it to false
    }

    int count = 0;
    for (PieceView* pv in self.pieces){
        if (pv.isMatched) count++;
    }
    
    NSLog(@"%i", count);
    NSString *countString = [[NSString alloc] initWithFormat:@"%d", count];
    self.countLabel.text = countString;

    // check if all the pieces are matched. count would be equal to the number of pieces in this case.
    if (count == self.pieceNum) {
        for(PieceView* pv in self.pieces) pv.userInteractionEnabled = NO;
        for(TargetView* tv in self.targets) tv.hidden = YES;
        self.solvedPuzzle = true;
        NSLog(@"Solved!");
    }
}

// animation: place piece at target
-(void)placePiece:(PieceView*)pieceView atTarget:(TargetView*)targetView{
    [UIView animateWithDuration:1.00 delay:0.00 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         pieceView.center = targetView.center;
                         pieceView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)GameOverViewControllerDidPressDone:(GameOverViewController *)controller
{
    UINavigationController *nav = (UINavigationController *)self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        
        //This for loop iterates through all the view controllers in navigation stack.
        for (UIViewController* viewController in nav.viewControllers) {
            NSLog(@"why");
            //This if condition checks whether the viewController's class is a CreatePuzzleViewController
            // if true that means its the FriendsViewController (which has been pushed at some point)
            if ([viewController isKindOfClass:[ChallengeViewController class]] ) {
                
                // Here viewController is a reference of UIViewController base class of CreatePuzzleViewController
                // but viewController holds CreatePuzzleViewController  object so we can type cast it here
                ChallengeViewController *challengeViewController = (ChallengeViewController *)viewController;
                [nav popToViewController:challengeViewController animated:YES];
                [challengeViewController.currentGamesTable setContentOffset:CGPointZero animated:YES];
                break;
            }
        }
    }];
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