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
//    combine thiis into one for unfavorite
    // TODO: Update the local tweet model
//    self.tweet.favorited = YES;
//    self.tweet.favoriteCount += 1;

    // TODO: Update cell UI
    if ([sender isSelected]) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;

        [sender setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
//        [sender setSelected:NO];
        NSLog(@"do we hit here");
    } else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;

        [sender setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
//        [sender setSelected:YES];
    }
    
//    refreshData()

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
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
//        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
        NSLog(@"do we hit here");
//        [sender setSelected:YES];
    }
    
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
