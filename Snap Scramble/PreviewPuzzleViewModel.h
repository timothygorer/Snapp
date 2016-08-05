//
//  PreviewPuzzleViewModel.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/23/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PreviewPuzzleViewModel : NSObject

@property (nonatomic, strong) NSString *puzzleSize;
@property (nonatomic, strong) PFUser* opponent;
@property (nonatomic, strong) PFFile* file;
@property (nonatomic, strong) PFObject* createdGame;
@property (nonatomic, strong) PFObject* roundObject;
@property (nonatomic, strong) NSNumber *roundNumber;




-(id)init;
- (PFObject *)setGameKeyParameters:(NSData *)fileData fileType:(NSString *)fileType fileName:(NSString *)fileName;
- (NSNumber*)getRoundNumber;
- (void)incrementRoundNumber;
- (PFObject *)getRoundObject;
- (void)saveFile:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)saveCurrentGame:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)sendNotificationToOpponent;

@end
