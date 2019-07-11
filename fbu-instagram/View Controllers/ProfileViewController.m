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
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *postsArray;

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    //fixed number of cells per line
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width -  layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont fontWithName:@"Billabong" size:21]}];
    

    self.collectionView.backgroundColor = [UIColor whiteColor];
    

    self.userProfileImage.layer.cornerRadius = 40;
    self.userProfileImage.clipsToBounds = YES;
    
    
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
            
            // self.postss = posts;
            // do something with the array of object returned by the call
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

}






- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
}



@end
