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
    
    [self.likeNumber setSelected:self.tweet.favorited];
    [self.retweetNumber setSelected:self.tweet.retweeted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)didTapeFavorite:(id)sender {
    if (!self.tweet.favorited) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        self.likeNumber.selected = YES;
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
            }
        }];
    } else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        self.likeNumber.selected = NO;
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavorting tweet: %@", error.localizedDescription);
                
            }
            else{
                NSLog(@"Successfully unfavorting the following Tweet: %@", self.tweet.text);
            }
        }];
    }
    
    NSString* likeCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeNumber setTitle:likeCount forState:UIControlStateNormal];
    
}

- (IBAction)didTapRetweet:(id)sender {
    if (!self.tweet.retweeted) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        self.retweetNumber.selected = YES;

        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error tweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully tweeted the following Tweet: %@", self.tweet.text);
            }
        }];
    } else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        self.retweetNumber.selected = NO;

        [[APIManager shared] untweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error untweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully untweeting the following Tweet: %@", self.tweet.text);
            }
        }];
    }
    
    NSString* retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetNumber setTitle:retweetCount forState:UIControlStateNormal];
}

@end
