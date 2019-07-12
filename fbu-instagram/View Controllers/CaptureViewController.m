//
//  CaptureViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/9/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "CaptureViewController.h"
#import "HomeViewController.h"
#import <UIKit/UIKit.h>

#import "Post.h"

@interface CaptureViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITabBarControllerDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIImage *chosenImage;
@property (weak, nonatomic) IBOutlet UIImageView *chosenImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;


@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    
    self.captionTextView.delegate = self;
    
    // Instantiate a UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    //imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // If camera is available, choose camera. Else, choose camera roll
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:^{
        //Placeholder text
        self.captionTextView.text = @"Insert caption here";
        self.captionTextView.textColor = [UIColor lightGrayColor];
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Resize the image
    self.chosenImageView.image = editedImage;
    self.chosenImage = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    
    // Dismiss UIImagePickerController to go back to Home View controller
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


//Placeholder in UITextView method #1
- (void)textViewDidBeginEditing:(UITextView *)captionTextView
{
    if ([self.captionTextView.text isEqualToString:@"Insert caption here"]) {
        self.captionTextView.text  = @"";
        self.captionTextView.textColor = [UIColor blackColor];
    }
    [self.captionTextView becomeFirstResponder];
}

//Placeholder in UITextView method #2
- (void)textViewDidEndEditing:(UITextView *)captionTextView
{
    if ([self.captionTextView.text isEqualToString:@""]) {
        self.captionTextView.text = @"Insert caption here";
        self.captionTextView.textColor = [UIColor lightGrayColor];
    }
    [self.captionTextView resignFirstResponder];
}


- (IBAction)didShare:(UIBarButtonItem *)sender {
    [Post postUserImage:self.chosenImageView.image withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(succeeded){
            NSLog(@"Posted!");
            //ParentViewController is tab bar controller
            [self.parentViewController.tabBarController setSelectedIndex:0];
        } else{
             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            
        }
    
    }];
}



@end
