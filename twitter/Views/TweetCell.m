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
    
    BOOL flag = self.tweet.favorited;
    NSLog(flag ? @"Yes" : @"No");
    
//    NSLog(@"%@", self.tweet.favorited);
    if (self.tweet.favorited) {
        [self.likeNumber setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
    } {
        [self.likeNumber setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateSelected];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapeFavorite:(id)sender {
//    BOOL currentState = self.tweet.favorited;
    BOOL flag = self.tweet.favorited;
    NSLog(flag ? @"HereYes" : @"HereNo");
    
    if (!self.tweet.favorited) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        self.likeNumber.selected = YES;

        [sender setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];

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
    } else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        self.likeNumber.selected = NO;

        [sender setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];

    //    have to check post request... need to change the url
        // TODO: Send a POST request to the POST favorites/create endpoint
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
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    self.replyNumber.selected = YES;
    
    [sender setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateSelected];
    
    NSString* retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetNumber setTitle:retweetCount forState:UIControlStateNormal];
    
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error retweeting cell tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", self.tweet.text);
        }
    }];
}

@end
