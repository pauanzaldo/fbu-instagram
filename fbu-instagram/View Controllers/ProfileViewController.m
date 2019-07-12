//
//  ProfileViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/11/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCell.h"
#import "PostCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *postsArray;
@property (weak, nonatomic) IBOutlet UILabel *userProfileLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
 
    //Sets Custom Font to Instagram Font
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont fontWithName:@"Billabong" size:21]}];
    
    //Setup for Collection Layour
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    //fixed number of cells per line
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width -  layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    

    [self fetchProfileImage];
    [self fetchImages];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post = self.postsArray[indexPath.item];
    NSData *data = post.image.getData;
    UIImage *image = [[UIImage alloc] initWithData:data];
    collectionCell.postCellImage.image = image;
    
    return collectionCell;
    
}


-(void)fetchProfileImage{
    //Set profile image
    PFFileObject *imageFile = PFUser.currentUser[@"profilePic"];
    
    //Synchronously gets the data from cache if available or fetches its contents from the network.
    UIImage *image = [[UIImage alloc] initWithData:imageFile.getData];
    self.userProfileImage.image = image;
    
    self.userProfileImage.layer.cornerRadius = 40;
    self.userProfileImage.clipsToBounds = YES;
    
    self.profileButton.layer.borderWidth = 1.0f;
    self.profileButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.profileButton.layer.cornerRadius = 5;
    
    self.userProfileLabel.text = PFUser.currentUser[@"username"];
}

/*
 Method: fetchImages
 Purpose: Construct query to retrieve Post data stored in Parse.
 */

-(void)fetchImages{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    
    [query includeKey:@"author"];

    [query whereKey:@"author" equalTo:PFUser.currentUser];

    [query includeKey:@"createdAt"];
    
    //View the last 20 posts submitted to "Instagram"
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = [NSMutableArray arrayWithArray: posts];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
}


@end
