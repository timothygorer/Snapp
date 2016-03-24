//
//  TargetView.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetView : UIImageView

@property (strong,nonatomic) UIImage* image;
@property (nonatomic)NSInteger targetId;
@property (nonatomic)BOOL filled;

@end
