//
//  PostCell.m
//  fbu-instagram
//
//  Created by panzaldo on 7/10/19.
//  Copyright © 2019 panzaldo. All rights reserved.
//

#import "Post.h"
#import "PostCell.h"


@implementation PostCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.postProfileImage.layer.cornerRadius = 20;
    self.postProfileImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
