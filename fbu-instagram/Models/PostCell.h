//
//  PostCell.h
//  fbu-instagram
//
//  Created by panzaldo on 7/10/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN


@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@property (weak, nonatomic) IBOutlet UILabel *postCaption;

@property (weak, nonatomic) IBOutlet UIImageView *postProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *postUsername;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@property (strong, nonatomic) Post *post;

@end



NS_ASSUME_NONNULL_END
