//
//  DetailsViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/11/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//
#import "DetailsViewController.h"
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"

@interface DetailsViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;

@property (weak, nonatomic) IBOutlet UIImageView *detailsImageProfile;
@property (weak, nonatomic) IBOutlet UITextView *detailsPostCaption;
@property (weak, nonatomic) IBOutlet UILabel *detailsPostUsername;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.detailsPostCaption.text = self.post[@"caption"];
    NSData *data = self.post.image.getData;
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    
    self.detailsImageProfile.image = [UIImage imageNamed:@"pau_profile.png"];
    self.detailsImageProfile.layer.cornerRadius = 20;
    self.detailsImageProfile.clipsToBounds = YES;
    
    
    self.detailsImageView.image = image;
    self.detailsPostUsername.text = self.post.author.username;
    
}

@end
