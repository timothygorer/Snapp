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




-(id)initWithOpponent:(PFUser *)opponent andGame:(PFObject *)createdGame;
- (PFObject *)setGameKeyParameters:(NSData *)fileData fileType:(NSString *)fileType fileName:(NSString *)fileName;
- (void)saveFile:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)saveCurrentGame:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)sendNotificationToOpponent;

@end
