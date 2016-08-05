//
//  GameViewModel.h
//  Snap Scramble
//
//  Created by Tim Gorer on 8/2/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GameViewModel : NSObject

@property (nonatomic, strong) PFUser* opponent;
@property (nonatomic, strong) PFObject* createdGame;

-(id)initWithOpponent:(PFUser *)opponent andGame:(PFObject *)createdGame;
- (void)switchTurns;
- (void)saveCurrentGame:(void (^)(BOOL succeeded, NSError *error))completion;



@end
