//
//  ChangeProfilePicViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/11/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "ChangeProfilePicViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostCell.h"
#import <Parse/Parse.h>

@interface ChangeProfilePicViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *chosenProfilePic;
@property (strong, nonatomic) UIImage *chosenPic;

@end

@implementation ChangeProfilePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapChange:(id)sender {
    // Instantiate a UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // If camera is available, choose camera. Else, choose camera roll
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:^{
   
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do resize the image
    
    self.chosenProfilePic.image = editedImage;
    self.chosenPic = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//Resize the UIImage (Parse has a limit of 10MB for uploading photos)
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)didSave:(UIBarButtonItem *)sender {
    PFUser *currentUser = PFUser.currentUser;
    
    PFFileObject *image = currentUser[@"profilePic"];
    image  = [Post getPFFileFromImage:self.chosenProfilePic.image];
    [currentUser setObject:image forKey:@"profilePic"];
    
    [currentUser saveInBackground];
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
     [self.parentViewController.tabBarController setSelectedIndex:2];
    
}


@end
