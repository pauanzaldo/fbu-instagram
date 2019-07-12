//
//  LoginViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/8/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)onLoginTap:(UIButton *)sender {
   [self loginUser];
    NSLog(@"I tapped login");
}

//Handles User Login
- (void)loginUser {
    NSLog(@"I am checking data");
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
   //Makes an asynchronous request to log in a user with credentials. Returns an instance of the successfully logged in PFUser
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // display Home View Controller
        }
    }];
}

@end
