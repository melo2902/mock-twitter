//
//  DetailsViewController.m
//  twitter
//
//  Created by mwen on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "DetailsViewController.h"
#import "Tweet.h"
#import "TimelineViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetNumber;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end

@implementation DetailsViewController

//Need to set it at the beginning
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.nameLabel.text = self.tweet.user.name;
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    self.retweetNumber.text = [NSString stringWithFormat:@"%d Retweets", self.tweet.retweetCount];
    self.likeNumber.text = [NSString stringWithFormat:@"%d Likes", self.tweet.favoriteCount];
    self.timeLabel.text = self.tweet.createdAtTimeString;
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    UIImage *originalImage = [UIImage imageWithData:urlData];
    self.profileView.image = originalImage;
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
    self.profileView.clipsToBounds = true;
    
    [self.likeButton setSelected:self.tweet.favorited];
    [self.retweetButton setSelected:self.tweet.retweeted];
}

- (IBAction)onTapFavorite:(id)sender {
    if (!self.tweet.favorited) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        self.likeButton.selected = YES;
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
                //                unset if fails
                //                Set an alert
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
            }
        }];
    } else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        self.likeButton.selected = NO;
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavorting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorting the following Tweet: %@", self.tweet.text);
            }
        }];
    }
    
    self.likeNumber.text = [NSString stringWithFormat:@"%d Likes", self.tweet.favoriteCount];
}

- (IBAction)onTapRetweet:(id)sender {
    if (!self.tweet.retweeted) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        self.retweetButton.selected = YES;
        
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
        self.retweetButton.selected = NO;
        
        [[APIManager shared] untweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error untweeting tweet: %@", error.localizedDescription);
            }
            else{
                
                NSLog(@"Successfully untweeting the following Tweet: %@", self.tweet.text);
            }
        }];
    }
    self.retweetNumber.text = [NSString stringWithFormat:@"%d Retweets", self.tweet.retweetCount];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
