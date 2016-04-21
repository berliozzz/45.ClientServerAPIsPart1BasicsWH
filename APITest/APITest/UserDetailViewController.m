//
//  UserDetailViewController.m
//  APITest
//
//  Created by Nikolay Berlioz on 10.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "UserDetailViewController.h"
#import "User.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "MainUserPhotoCell.h"
#import "FollowersCell.h"
#import "FollowersViewController.h"
#import "SubscriptionsViewController.h"
#import "WallImageCell.h"
#import "Wall.h"

@interface UserDetailViewController ()

@property (strong, nonatomic) NSMutableArray *wallPostsArray;

@end

@implementation UserDetailViewController

static NSInteger countWallPostInRequest = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wallPostsArray = [NSMutableArray array];
    
    if (!self.user.userId)
    {
        self.user.userId = self.user.shortUserId;
    }
    
    [self getUserInfoWithUserId:self.user.userId];
    [self getWall];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Avenir Next" size:23.0], NSFontAttributeName, nil]];
    self.navigationItem.title = self.user.firstName;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void) actionFollowers:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FollowersViewController *vc = (FollowersViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"FollowersViewController"];
    vc.userId = self.user.shortUserId;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) actionsubscription:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SubscriptionsViewController *vc = (SubscriptionsViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"SubscriptionsViewController"];
    vc.userId = self.user.shortUserId;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - API

- (void) getWall
{
    [[ServerManager sharedManager]
     getWallWithId:self.user.userId
            offset:[self.wallPostsArray count]
            count:countWallPostInRequest
        onSuccess:^(NSArray *wallItems)
    {
        [self.wallPostsArray addObjectsFromArray:wallItems];
        
        [self.tableView reloadData];
    }
        onFailure:^(NSError *error)
    {
        NSLog(@"error = %@", [error localizedDescription]);
    }];
}

- (void) getUserInfoWithUserId:(NSInteger)userId
{
    [[ServerManager sharedManager] getUserInfoWithId:userId onSuccess:^(User *user) {

        self.user = user;
        
        [self.tableView reloadData];
        
    } onFailure:^(NSError *error) {
        NSLog(@"error = %@", [error localizedDescription]);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + [self.wallPostsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoCellIdentifier = @"firstCell";
    static NSString *followerCellIdentifier = @"followersCell";
    static NSString *wallImageCellIdentifier = @"WallImageCell";
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            MainUserPhotoCell* cell = (MainUserPhotoCell*)[tableView dequeueReusableCellWithIdentifier:photoCellIdentifier];
            
            [cell.mainPhotoImageView setImageWithURL:self.user.image200Url placeholderImage:[UIImage imageNamed:@"preview.gif"]];
            cell.mainPhotoImageView.layer.cornerRadius = cell.mainPhotoImageView.frame.size.width / 2;
            cell.mainPhotoImageView.layer.masksToBounds = YES;
            
            cell.firstNameLabel.text = self.user.firstName;
            cell.lastNameLabel.text = self.user.lastName;
            
            if (self.user.isOnline)
            {
                cell.onlineLabel.text = @"online";
                cell.onlineLabel.textColor = [UIColor grayColor];
            }
            else
            {
                cell.onlineLabel.text = @"offline";
                cell.onlineLabel.textColor = [UIColor grayColor];
            }
            
            cell.cityLabel.text = self.user.city;

            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            FollowersCell *cell = [tableView dequeueReusableCellWithIdentifier:followerCellIdentifier];
            
            cell.followerButton.layer.cornerRadius = 6.f;
            cell.followerButton.layer.masksToBounds = YES;
            
            cell.subscriptionButton.layer.cornerRadius = 6.f;
            cell.subscriptionButton.layer.masksToBounds = YES;
            
            [cell.followerButton addTarget:self action:@selector(actionFollowers:) forControlEvents:UIControlEventTouchUpInside];
            [cell.subscriptionButton addTarget:self action:@selector(actionsubscription:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        else if (indexPath.row > 1)
        {
            Wall *wall = [self.wallPostsArray objectAtIndex:indexPath.row - 2];
            
            WallImageCell *cell = [tableView dequeueReusableCellWithIdentifier:wallImageCellIdentifier];
            
            cell.postLabel.text = wall.postText;
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 160.f;
    }
    else if (indexPath.row == 1)
    {
        return 44.f;
    }
    else if (indexPath.row > 1)
    {
        return 200.f;
    }
    
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end












