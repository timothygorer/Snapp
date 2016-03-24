//
//  CreatePuzzleViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 7/20/15.
//  Copyright (c) 2015 Tim Gorer. All rights reserved.
//

#import "CreatePuzzleViewController.h"
#import "PreviewPuzzleViewController.h"
#import "GameViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface CreatePuzzleViewController ()

@end

@implementation CreatePuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentUser = [PFUser currentUser];
    NSLog(@"Opponent: %@", [self.opponent objectForKey:@"username"]);
    //self.usernameDisplay.text = [NSString stringWithFormat:@"      Opponent: %@", [self.opponent objectForKey:@"username"]]; // nothing happens, change
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];

    [self.takePhotoButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.choosePhotoButton addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchDown];
    self.backButton.adjustsImageWhenHighlighted = NO;
}

- (IBAction)takePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
     
     else {
         NSLog(@"No camera available.");
     }
}

- (IBAction)choosePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    
    else {
        NSLog(@"Photo library not available.");
    }
}

- (IBAction)backButtonDidPress:(id)sender {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.5f];
    self.backButton.transform = CGAffineTransformMakeScale(1.1,1.1);
    [UIView commitAnimations];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //This for loop iterates through all the view controllers in navigation stack.
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        
        //This if condition checks whether the viewController's class is a CreatePuzzleViewController
        // if true that means its the FriendsViewController (which has been pushed at some point)
        if ([viewController isKindOfClass:[CreatePuzzleViewController class]] ) {
            
            // Here viewController is a reference of UIViewController base class of CreatePuzzleViewController
            // but viewController holds CreatePuzzleViewController  object so we can type cast it here
            CreatePuzzleViewController *createPuzzleViewController = (CreatePuzzleViewController *)viewController;
            [self.navigationController popToViewController:createPuzzleViewController animated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {   // A photo was taken or selected

        UIImage* tempOriginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"tempOriginaImage: %@", tempOriginalImage);
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // save the image
            UIImageWriteToSavedPhotosAlbum(tempOriginalImage, nil, nil, nil);
        }
        
        // resize the photo
        if (tempOriginalImage.size.height > tempOriginalImage.size.width) { // portrait
            /* self.resizedImage = [self resizeImage:tempOriginalImage withMaxDimension:self.view.frame.size.height - 200]; */
            self.resizedImage = [self imageWithImage:tempOriginalImage scaledToFillSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
            NSLog(@".......");
        }
        
        else if (tempOriginalImage.size.width > tempOriginalImage.size.height) { // landscape or square
            self.resizedImage = [self resizeImage:tempOriginalImage withMaxDimension:self.view.frame.size.width - 20];
        }
        
        else if (tempOriginalImage.size.width == tempOriginalImage.size.height) { // square
            self.resizedImage = [self resizeImage:tempOriginalImage withMaxDimension:self.view.frame.size.width - 20];
        }
        
        // created a half compressed photo to upload so that it can be resized on the receiver's end. is this necessary? maybe... since there's the 5S photo to 6+ dilemma. this might actually be quite smart.
        self.originalImage = tempOriginalImage;
        NSLog(@"resized image: %@    original image: %@", self.resizedImage, self.originalImage);
        
        NSLog(@"Screen Width: %f    Screen Height: %f", self.view.frame.size.width, self.view.frame.size.height);

        [self dismissViewControllerAnimated:YES completion:nil]; // dismiss photo picker
        [self performSegueWithIdentifier:@"previewPuzzleSender" sender:self];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizeImage:(UIImage *)image withMaxDimension:(CGFloat)maxDimension {
    if (fmax(image.size.width, image.size.height) <= maxDimension) {
        return image;
    }
    
    CGFloat aspect = image.size.width / image.size.height;
    CGSize newSize;
    
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension / aspect);
    } else {
        newSize = CGSizeMake(maxDimension * aspect, maxDimension);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"previewPuzzleSender"]) {
        PreviewPuzzleViewController *previewPuzzleViewController = (PreviewPuzzleViewController *)segue.destinationViewController;
        if ([self.createdGame objectForKey:@"receiverPlayed"] == [NSNumber numberWithBool:true]) { // this is the condition if the game already exists but the receiver has yet to send back. he's already played
            previewPuzzleViewController.createdGame = self.createdGame;
        }
        previewPuzzleViewController.opponent = self.opponent;
        NSLog(@"createdGame: %@", self.createdGame);
        previewPuzzleViewController.image = self.resizedImage; // resized image
        previewPuzzleViewController.originalImage = self.originalImage;
    }
}



@end
