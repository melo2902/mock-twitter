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
    // TODO: Update the local tweet model
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;

    // TODO: Update cell UI
//    refreshData()

    // TODO: Send a POST request to the POST favorites/create endpoint
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    
}

- (IBAction)didTapRetweet:(id)sender {
//    self.tweet.retweetCount = YES;
//    self.tweet.retweeted += 1;
}

@end
