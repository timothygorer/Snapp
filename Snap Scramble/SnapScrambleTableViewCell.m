//
//  SnapScrambleTableViewCell.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/22/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "SnapScrambleTableViewCell.h"

@implementation SnapScrambleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.statusLabel = [[UILabel alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
