//
//  FollowersViewController.m
//  APITest
//
//  Created by Nikolay Berlioz on 20.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "FollowersViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UserDetailViewController.h"

@interface FollowersViewController ()

@property (strong, nonatomic) NSMutableArray *followersArray;
@property (assign, nonatomic) BOOL loadingData;

@end

@implementation FollowersViewController

static NSInteger followersInRequest = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.followersArray = [NSMutableArray array];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Avenir Next" size:23.0], NSFontAttributeName, nil]];
    self.navigationItem.title = @"Подписчики";
    
    NSLog(@"%lu", self.userId);
    
    [self getFollowers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) getFollowers
{
    [[ServerManager sharedManager] getFollowersWithId:self.userId
                                               offset:[self.followersArray count]
                                                count:followersInRequest
    onSuccess:^(NSArray *followers)
    {
        [self.followersArray addObjectsFromArray:followers];
        
        [self.tableView reloadData];
        
        self.loadingData = NO;
    }
    onFailure:^(NSError *error)
    {
        NSLog(@"error = %@", [error localizedDescription]);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.followersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    User *user = [self.followersArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:user.image100Url];
    
    __weak UITableViewCell* weakCell = cell;
    
    cell.imageView.image = nil;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"preview.gif"]
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       
                                       weakCell.imageView.image = image;
                                       weakCell.imageView.layer.cornerRadius = weakCell.imageView.frame.size.width/2;
                                       weakCell.imageView.layer.masksToBounds = YES;
                                       [weakCell layoutSubviews];
                                       
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       NSLog(@"ERROOORR FAILURE IMAGE");
                                   }];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    User *friend = [self.followersArray objectAtIndex:indexPath.row];
    
    UserDetailViewController *vc = (UserDetailViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"UserDetailViewController"];
    
    vc.user = friend;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getFollowers];
        }
    }
}

@end
