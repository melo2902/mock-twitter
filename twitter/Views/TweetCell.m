//
//  TweetCell.m
//  twitter
//
//  Created by mwen on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "TimelineViewController.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapeFavorite:(id)sender {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    self.likeNumber.selected = YES;

    [sender setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
    
    NSString* likeCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeNumber setTitle:likeCount forState:UIControlStateNormal];

//    have to check post request... need to change the url
    // TODO: Send a POST request to the POST favorites/create endpoint
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
        }
    }];
    
}

- (IBAction)didTapRetweet:(id)sender {
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    self.replyNumber.selected = YES;
    
    [sender setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateSelected];
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
        }
    }];
}

@end
