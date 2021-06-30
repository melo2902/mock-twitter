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

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController
BOOL isMoreDataLoading;
InfiniteScrollActivityView *loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getTimeline];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
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
    
    return cell;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
}

//-(void)loadMoreData{
//
//      // ... Create the NSURLRequest (myRequest) ...
//
//    // Configure session so that completion handler is executed on main UI thread
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//    NSURLSession *session  = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *requestError) {
//        if (requestError != nil) {
//
//        }
//        else
//        {
//            // Update flag
//            isMoreDataLoading = false;
//
//            // Stop the loading indicator
//            [loadingMoreView stopAnimating];
//
//            // ... Use the new data to update the data source ...
//
//            // Reload the tableView now that there is new data
//            [self.tableView reloadData];
//        }
//    }];
//    [task resume];
//}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row + 1 == [self.arrayOfTweets count]){
//        [self loadMoreData:[self.arrayOfTweets count] + 20];
//    }
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(!isMoreDataLoading){
//        // Calculate the position of one screen length before the bottom of the results
//        int scrollViewContentHeight = self.tableView.contentSize.height;
//        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
//
//        // When the user has scrolled past the threshold, start requesting
//        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
//            isMoreDataLoading = true;
//
//            // Update position of loadingMoreView, and start loading indicator
//            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
//            loadingMoreView.frame = frame;
//            [loadingMoreView startAnimating];
//
//            // Code to load more results
//            [self loadMoreData];
//        }
//    }
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"composeTweetSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
//        composeController.user = self.
        
    } else if ([segue.identifier isEqual:@"showDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
}

@end
