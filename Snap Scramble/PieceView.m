//
//  PieceView.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "PieceView.h"

@implementation PieceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.isMatched = false;
        // [self.layer setCornerRadius:3.0];
        // self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.superview bringSubviewToFront:self];
    self.initialX = self.frame.origin.x;
    self.initialY = self.frame.origin.y;
    CGPoint pt = [[touches anyObject]locationInView:self.superview];
    self.xOffset = pt.x - self.center.x;
    self.yOffset = pt.y - self.center.y;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject]locationInView:self.superview];
    // (pt.x - self.xOffset, pt.y - self.yOffset) is the new point being dragged to.
    if (pt.x - self.xOffset < self.superview.frame.size.width - 5 && pt.x - self.xOffset > 5) { // (left right bounds check) if the point is within the boundary, we can place it there. Otherwise, we can't.
        if (pt.y - self.yOffset < self.superview.frame.size.height - 5 && pt.y - self.yOffset > 5) { // (top and bottom bounds check) if the point is within the boundary, we can place it there. Otherwise, we can't.
            self.center = CGPointMake(pt.x - self.xOffset, pt.y - self.yOffset);
        }
    }
    
    NSLog(@"pieceView x-coordinate: %f    pieceView y-coordinateeee: %f", self.frame.origin.x, self.frame.origin.y);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.dragDelegate) {
        [self.dragDelegate pieceView:self didDragToPoint:self.center]; // self.center is the pt
    }
}

@end
