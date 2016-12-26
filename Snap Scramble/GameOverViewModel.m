//
//  GameOverViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 8/4/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "GameOverViewModel.h"

@implementation GameOverViewModel

- (void)updateGame {
    if ([[self.createdGame objectForKey:@"receiverName"] isEqualToString:[PFUser currentUser].username]) { // if current user is the receiver (we want the receiver to send back a puzzle). This code is executed when the user plays a game someone else sent him.
        [self.createdGame setObject:[NSNumber numberWithBool:true] forKey:@"receiverPlayed"]; // receiver played, set true
        [self.roundObject setObject:self.currentUserTotalSeconds forKey:@"receiverTime"]; // set the time
        NSLog(@"current user is the receiver. let him see stats, and then reply or end game. RECEIVER HAS PLAYED");
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else {
                
                NSLog(@"game updated successfully: %@", self.createdGame);
            }
        }];
    }
    
    else if ([[self.createdGame objectForKey:@"senderName"] isEqualToString:[PFUser currentUser].username]) { // if current user is the sender. This code is executed when the user starts sending his own game to someone else.
        [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"]; // set that the receiver has not played. i did this already in PreviewPuzzleVC, but I'm doing it again here to stop any confusion.
        [self.roundObject setObject:self.currentUserTotalSeconds forKey:@"senderTime"]; // set the time
        NSLog(@"current user is not the receiver, he's the sender. let him see stats, switch turns / send a push notification and then go to main menu to wait. RECEIVER HAS NOT PLAYED.");
        [self.createdGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred." message:@"Please quit the app and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else {
                NSLog(@"game updated successfully. %@", self.createdGame);
            }
        }];
    }
}





@end
