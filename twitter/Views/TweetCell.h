//
//  TweetCell.h
//  twitter
//
//  Created by mwen on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *replyNumber;
@property (weak, nonatomic) IBOutlet UIButton *retweetNumber;
@property (weak, nonatomic) IBOutlet UIButton *likeNumber;
@property (weak, nonatomic) IBOutlet UIImageView *mediaView;
@property (strong, nonatomic) Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
