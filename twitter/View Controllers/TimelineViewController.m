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
#import "InfiniteScrollActivityView.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, weak) User *loggedInUser;
@property (nonatomic, strong) NSString *profilePictureLink;
@end

@implementation TimelineViewController
BOOL isMoreDataLoading;
InfiniteScrollActivityView *loadingMoreView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getTimeline];
    [self getLoggedInUser];
        
//    Make a call to the API and create user object
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)getLoggedInUser {
    [[APIManager shared] getUSERID:^(User *user, NSError *error) {
        if (user) {
            NSLog(@"😎😎😎 Successfully got userid");
            
            self.loggedInUser = user;
            self.profilePictureLink = user.profilePicture;
            NSLog(@"userPP%@", self.loggedInUser.profilePicture);
            //
        } else {
            NSLog(@"😫😫😫 Error getting user: %@", error.localizedDescription);
        }
    }];
}

- (void)getTimeline {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            self.arrayOfTweets = (NSMutableArray*)tweets;
            [self.tableView reloadData];
            //
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
//    [[APIManager shared] getUSERID:^(User *user, NSError *error) {
//        if (user) {
//            NSLog(@"😎😎😎 Successfully got userid");
//
//            self.loggedInUser = user;
//
//            NSLog(@"userPP%@", self.loggedInUser.profilePicture);
//            //
//        } else {
//            NSLog(@"😫😫😫 Error getting user: %@", error.localizedDescription);
//        }
//    }];
    
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutApp:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    UIImage *originalImage = [UIImage imageWithData:urlData];
    cell.profileView.image = originalImage;
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width / 2;
    cell.profileView.clipsToBounds = true;
    
    cell.username.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    
    NSDate *dateString = tweet.wholeCreationString;
    
    cell.date.text = dateString.shortTimeAgoSinceNow;
    cell.tweetText.text = tweet.text;
    cell.name.text = tweet.user.name;
    
    NSString *favoriteCountNumber = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    [cell.likeNumber setTitle:favoriteCountNumber forState:UIControlStateNormal];
    
    NSString *retweetCountNumber = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    [cell.retweetNumber setTitle:retweetCountNumber forState:UIControlStateNormal];
    
    NSString *replyCountNumber = [NSString stringWithFormat:@"%d", tweet.replyCount];
    [cell.replyNumber setTitle:replyCountNumber forState:UIControlStateNormal];
    
    if (tweet.mediaLink[0][@"media_url_https"]){
        NSURL *imageURL = [NSURL URLWithString:cell.tweet.mediaLink[0][@"media_url_https"]];
        NSData *mediaData = [NSData dataWithContentsOfURL:imageURL];
        cell.mediaView.image = [UIImage imageWithData:mediaData];
    } else {
        cell.mediaView.image = nil;
    }
    
    return cell;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do some stuff when the row is selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(TweetCell *)cell
                                         forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Update the state of the like and retweet buttons to denote if the user has liked or retweeted it
    [cell.likeNumber setSelected:cell.tweet.favorited];
    [cell.retweetNumber setSelected:cell.tweet.retweeted];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"composeTweetSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        composeController.user = self.loggedInUser;
        composeController.userPP = self.profilePictureLink;
        
    } else if ([segue.identifier isEqual:@"showDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
        detailsViewController.indexPath = indexPath;
    }
}

@end
