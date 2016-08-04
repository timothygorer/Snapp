//
//  PreviewPuzzleViewModel.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/23/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "PreviewPuzzleViewModel.h"

@implementation PreviewPuzzleViewModel

-(id)initWithOpponent:(PFUser *)opponent andGame:(PFObject *)createdGame {
    self = [super init];
    if (self) {
        self.opponent = opponent;
        self.createdGame = createdGame;
        // puzzleSize property gets set later
    }
    
    return self;
}


- (PFObject *)setGameKeyParameters:(NSData *)fileData fileType:(NSString *)fileType fileName:(NSString *)fileName {
    PFFile* file; // file
    
    // set all parameters we need for the cloud game object. this is for either a new game or an existing game when the current user has to reply.
    if ([self.createdGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true] &&   [[self.createdGame objectForKey:@"receiverName"]  isEqualToString:[PFUser currentUser].username]) { // if the receiver has played but the receiver has yet to send back, let him. this is code for the receiver.
        file = [PFFile fileWithName:fileName data:fileData];
        [self.createdGame setObject:self.puzzleSize forKey:@"puzzleSize"];
        [self.createdGame setObject:file forKey:@"file"];
        [self.createdGame setObject:fileType forKey:@"fileType"];
        [self.createdGame setObject:self.opponent forKey:@"receiver"];
        [self.createdGame setObject:[PFUser currentUser] forKey:@"sender"]; // is this necessary?
        [self.createdGame setObject:[PFUser currentUser].username forKey:@"senderName"]; // receiver becomes sender here
        [self.createdGame setObject:[[PFUser currentUser] objectId] forKey:@"senderID"];
        [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"]; // set that the receiver has not played
        
        // set later so that a glitch doesn't happen
        [self.createdGame setObject:@"" forKey:@"receiverID"];
        [self.createdGame setObject:@"" forKey:@"receiverName"];
    }
    
    else if (self.createdGame == nil) { // if the game is a NEWLY created game
        self.createdGame = [PFObject objectWithClassName:@"Messages"];
        [self.createdGame setObject:self.puzzleSize forKey:@"puzzleSize"];
        [self.createdGame setObject:[[PFUser currentUser] objectId] forKey:@"senderID"];
        [self.createdGame setObject:[[PFUser currentUser] username] forKey:@"senderName"];
        [self.createdGame setObject:self.opponent forKey:@"receiver"];
        [self.createdGame setObject:[PFUser currentUser] forKey:@"sender"];
        file = [PFFile fileWithName:fileName data:fileData];
        [self.createdGame setObject:file forKey:@"file"];
        [self.createdGame setObject:fileType forKey:@"fileType"];
        [self.createdGame setObject:[NSNumber numberWithBool:false] forKey:@"receiverPlayed"]; // set that the receiver has not played

        
        // set later so that a glitch doesn't happen
        [self.createdGame setObject:@"" forKey:@"receiverID"];
        [self.createdGame setObject:@"" forKey:@"receiverName"];
    }
    
    self.file = file; // set the file property
    return self.createdGame;
}

// save the file (photo) before saving the game cloud object
- (void)saveFile:(void (^)(BOOL succeeded, NSError *error))completion {
    [self.file saveInBackgroundWithBlock:completion];
}

// save the game cloud object
- (void)saveCurrentGame:(void (^)(BOOL succeeded, NSError *error))completion {
    [self.createdGame saveInBackgroundWithBlock:completion];
}

- (void)sendNotificationToOpponent {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *innerQuery = [PFUser query];
    
    NSLog(@"You sent a notification to: objectID: %@", self.opponent.objectId);
    [innerQuery whereKey:@"objectId" equalTo:self.opponent.objectId];
    
    // Build the actual push notification target query
    PFQuery *query = [PFInstallation query];
    
    // only return Installations that belong to a User that
    // matches the innerQuery
    [query whereKey:@"User" matchesQuery:innerQuery];
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    
    NSString *message = [NSString stringWithFormat:@"%@ has sent you a puzzle!", currentUser.username];
    [push setMessage:message];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          @"cheering.caf", @"sound",
                          nil];
    [push setData:data];
    [push sendPushInBackground];
}


@end
