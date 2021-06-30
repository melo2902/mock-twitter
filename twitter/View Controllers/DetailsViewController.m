//
//  DetailsViewController.m
//  twitter
//
//  Created by mwen on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetNumber;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@end

@implementation DetailsViewController

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
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
