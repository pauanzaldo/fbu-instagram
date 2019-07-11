//
//  PostCell.h
//  fbu-instagram
//
//  Created by panzaldo on 7/10/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postCaption;

@end



NS_ASSUME_NONNULL_END
