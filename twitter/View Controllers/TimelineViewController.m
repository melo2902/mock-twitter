//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "DateTools.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getTimeline];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)getTimeline {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
            
            self.arrayOfTweets = (NSMutableArray*)tweets;
            [self.tableView reloadData];
//
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
//    Investigate later if this works
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];

//    Work on the profile picture later
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];

    NSLog(@"%@", urlData);
    
    cell.profileView.image = [UIImage imageWithData:urlData];
    
    cell.username.text = tweet.user.screenName;
//    cell.username.text = [NSString stringWithFormat:@"%@": tweet.user.screenName];

    NSString *dateString = tweet.createdAtString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/dd/yy"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    cell.date.text = dateFromString.shortTimeAgoSinceNow;
    cell.tweetText.text = tweet.text;
    cell.name.text = tweet.user.name;
    
    NSString *favoriteCountNumber = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    [cell.likeNumber setTitle:favoriteCountNumber forState:UIControlStateNormal];
    
    NSString *retweetCountNumber = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    [cell.retweetNumber setTitle:retweetCountNumber forState:UIControlStateNormal];
    
    NSString *replyCountNumber = [NSString stringWithFormat:@"%d", tweet.replyCount];
    [cell.replyNumber setTitle:replyCountNumber forState:UIControlStateNormal];
    
    return cell;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"composeTweetSegue"]) {
//        UITableViewCell *tappedCell = sender;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
//        Tweet *tweet = self.arrayOfTweets[indexPath.row];
//
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqual:@"showDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
}

@end
