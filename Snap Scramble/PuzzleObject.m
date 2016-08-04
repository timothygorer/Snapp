//
//  PuzzleObject.m
//  Snap Scramble
//
//  Created by Tim Gorer on 6/30/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "PuzzleObject.h"
#import "GameViewController.h"
#import "TargetView.h"
#import "PieceView.h"

@interface PuzzleObject ()

@end

@implementation PuzzleObject


-(id)initWithImage:(UIImage *)image andPuzzleSize:(NSString *)puzzleSizeString {
    self = [super init];
    if (self) {
        self.puzzleImage = image;
        self.puzzleSizeString = puzzleSizeString;
        self.targets = [[NSMutableArray alloc]init]; // initialize the TargetViews array which the view class updates
        self.pieces = [[NSMutableArray alloc]init]; // initialize the PieceViews array which the view class updates
    }
    
    NSLog(@"set puzzle size: %@", self.puzzleSizeString);
    
    // set the number of pieces property
    if ([self.puzzleSizeString isEqualToString:@"3 x 3"]) {
        self.numberofPieces = 9;
    }
    
    else if ([self.puzzleSizeString isEqualToString:@"4 x 4"]) {
        self.numberofPieces = 16;
    }
    
    else if ([self.puzzleSizeString isEqualToString:@"5 x 5"]) {
        self.numberofPieces = 25;
    }
    
    else if ([self.puzzleSizeString isEqualToString:@"6 x 6"]) {
        self.numberofPieces = 36;
    }
    
    else if ([self.puzzleSizeString isEqualToString:@"7 x 7"]) {
        self.numberofPieces = 49;
    }
    
    NSLog(@"number of pieces: %ld", (long)self.numberofPieces);
    
    return self;
}

-(NSInteger)getNumberOfPieces {
    return self.numberofPieces;
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

- (BOOL)puzzleSolved {
    int count = 0;
    for (PieceView* pv in self.pieces){
        if (pv.isMatched) count++;
    }
    
    // NSLog(@"amount of pieces matched: %i", count);
    
    // check if all the pieces are matched. count would be equal to the number of pieces in this case.
    if (count == self.numberofPieces) {
        for(PieceView* pv in self.pieces) {
            pv.userInteractionEnabled = NO;
            pv.layer.masksToBounds = NO;
        }
        
        for(TargetView* tv in self.targets) {
            tv.hidden = YES;
        }
        
        return YES;
    }
    
    else {
        return NO;
    }
}

@end
