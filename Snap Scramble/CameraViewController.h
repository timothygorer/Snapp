//
//  CameraViewController.h
//  Snap Scramble
//
//  Created by Tim Gorer on 7/23/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"
#import "Parse/Parse.h"

@interface CameraViewController : UIViewController

@property (nonatomic, strong) UIImage* image; // preview image
@property (nonatomic, strong) UIImage* originalImage;
@property (nonatomic, strong) PFObject* createdGame;
@property (nonatomic, strong) PFUser* opponent;



@end
