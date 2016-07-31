//
//  PieceView.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetView.h"

@class PieceView;

@protocol PieceDragDelegateProtocol <NSObject>
-(void)pieceView:(PieceView*)pieceView didDragToPoint: (CGPoint)pt;
@end

@interface PieceView : UIImageView

// piece image and its id
@property (strong,nonatomic) UIImage* pieceImg;
@property (nonatomic)NSInteger pieceId;

@property (nonatomic)BOOL isMatched;

// user touches the piece
@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat yOffset;

@property (nonatomic) CGFloat initialX;
@property (nonatomic) CGFloat initialY;

@property (strong,nonatomic) TargetView* targetView;


// protocol
@property (weak,nonatomic) id<PieceDragDelegateProtocol> dragDelegate;



@end
