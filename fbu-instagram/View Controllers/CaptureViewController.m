//
//  CaptureViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/9/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "CaptureViewController.h"

#import <UIKit/UIKit.h>
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
        //Placeholder text
        self.captionTextView.text = @"Insert caption here";
        self.captionTextView.textColor = [UIColor lightGrayColor];
    }];
    
    
   
   
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    // Get the image captured by the UIImagePickerController
  //  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the image
    self.chosenImageView.image = editedImage;
    self.chosenImage = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    // manually segue to Caption Controller Controller
    
  //tlcfihhlufrfdjdcbhhkbvbnejjvghkn  [self performSegueWithIdentifier:@"CaptionSegue" sender:nil];

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





// #pragma mark - Navigation
//
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     if([segue.identifier isEqualToString:@"CaptionSegue"]){
//         CaptionViewController *captionViewController = [segue destinationViewController];
//         captionViewController.image = self.chosenImage;
//
//
//       //  profileController.user = sender;
//
//         //send chosen image to Capture View Controller
//     }
// }





@end
