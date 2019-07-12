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
#import "NSDate+DateTools.h"


@interface DetailsViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;

@property (weak, nonatomic) IBOutlet UIImageView *detailsImageProfile;
@property (weak, nonatomic) IBOutlet UILabel *detailsPostCaption;
@property (weak, nonatomic) IBOutlet UILabel *detailsPostUsername;
@property (weak, nonatomic) IBOutlet UILabel *detailsTimeStamp;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailsPostCaption.text = self.post[@"caption"];
    NSData *data = self.post.image.getData;
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    PFFileObject *imageFile = PFUser.currentUser[@"profilePic"];
    
    //Synchronously gets the data from cache if available or fetches its contents from the network.
    UIImage *userImage = [[UIImage alloc] initWithData:imageFile.getData];
    
    self.detailsImageProfile.image = userImage;
    
    self.detailsImageProfile.layer.cornerRadius = 20;
    self.detailsImageProfile.clipsToBounds = YES;
    
    
    self.detailsImageView.image = image;
    self.detailsPostUsername.text = self.post.author.username;
    
    //Relative date
    NSDate *timeAgoDate = [NSDate dateWithTimeInterval:0 sinceDate:self.post.createdAt];
    
    //Displays relative date
    self.detailsTimeStamp.text =timeAgoDate.shortTimeAgoSinceNow;
   
}

@end
