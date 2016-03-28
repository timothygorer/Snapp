//
//  SnapScrambleTableViewCell.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/22/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface SnapScrambleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *opponentIcon;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;



@end
