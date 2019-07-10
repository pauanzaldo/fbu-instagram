//
//  CaptionViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/10/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "CaptionViewController.h"

@interface CaptionViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;

@end

@implementation CaptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.captionTextView.delegate = self;
   
    //Placeholder text
    self.captionTextView.text = @"Insert caption here";
    self.captionTextView.textColor = [UIColor lightGrayColor];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
