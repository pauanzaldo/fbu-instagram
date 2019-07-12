//
//  HomeViewController.m
//  fbu-instagram
//
//  Created by panzaldo on 7/8/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailsViewController.h"
#import <Parse/Parse.h>
#import "NSDate+DateTools.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "Post.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *postsArray;
@property (weak, nonatomic) IBOutlet UIImageView *homePostImage;
@property (weak, nonatomic) IBOutlet UILabel *homePostCaption;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.tableView reloadData];

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor blackColor],
    NSFontAttributeName:[UIFont fontWithName:@"Billabong" size:21]}];

    //Temporary
    self.tableView.rowHeight = 310;
    
    [self fetchPosts];
    
    //Allocate the UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    
  //  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instagram-logo.png"]];
    
    //Bind the action to the refresh control
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    
    //Insert the refresh control into the list
    [self.tableView addSubview:self.refreshControl];
    
    
    

}
//Automatically refreshes data
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchPosts];
}

-(void)fetchPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query includeKey:@"createdAt"];
    
    //View the last 20 posts submitted to "Instagram"
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = [NSMutableArray arrayWithArray: posts];
            [self.tableView reloadData];

           // self.postss = posts;
            // do something with the array of object returned by the call
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


/*
 Action: didTapLogout
 Goal: User logs out of the app. After logout,
 user is taken to login screen. Clears the current user.
 */
- (IBAction)didTapLogout:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
    
    
    
}

// Returns an instance of the custom cell with that reuse identifier with its elements populated with data at the index asked for
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.postsArray[indexPath.row];
    
    UIImage *image = [[UIImage alloc] initWithData:post.image.getData];
    //Image is stored
    
    
    cell.postCaption.text = post[@"caption"];
    cell.postImage.image = image;
    cell.postProfileImage.image = [UIImage imageNamed:@"pau_profile.png"];
    
    cell.postUsername.text = post.author.username;
    
    //Relative date
    NSDate *timeAgoDate = [NSDate dateWithTimeInterval:0 sinceDate:post.createdAt];
    
    //Displays relative date
    cell.timeStampLabel.text =timeAgoDate.shortTimeAgoSinceNow;

    return cell;

    
}

// Returns the number of items returned from the API
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Post *post = self.postsArray[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.post = post;
}


@end
