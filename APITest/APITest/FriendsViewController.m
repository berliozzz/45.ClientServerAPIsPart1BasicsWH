//
//  ViewController.m
//  APITest
//
//  Created by Nikolay Berlioz on 06.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "FriendsViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface FriendsViewController ()

@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (assign, nonatomic) BOOL loadingData;

@end

@implementation FriendsViewController

static NSInteger friensInRequest = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [NSMutableArray array];
    self.loadingData = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                            [UIColor whiteColor], NSForegroundColorAttributeName,
                            [UIFont fontWithName:@"Avenir Next" size:23.0], NSFontAttributeName, nil]];
    
    self.navigationItem.title = @"Friends";
    
    [self getFriendsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -API

- (void) getFriendsFromServer
{
    [[ServerManager sharedManager] getFriendsWithOffset:[self.friendsArray count]
      count:friensInRequest
  onSuccess:^(NSArray *friends) {
      
      [self.friendsArray addObjectsFromArray:friends];
      
      //add animation and reload table
      NSMutableArray *newPaths = [NSMutableArray array];
      
      for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++)
      {
          [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
      }
      
      [self.tableView beginUpdates];
      [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
      [self.tableView endUpdates];
      
      self.loadingData = NO;
      
  } onFailure:^(NSError *error) {
      NSLog(@"error = %@", [error localizedDescription]);
  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    User *friend = [self.friendsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    
    if (friend.isOnline)
    {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.frame),
                                                               CGRectGetMidY(cell.frame),
                                                               5, 5)];
        
        dot.backgroundColor = [UIColor colorWithRed:(float)0/255 green:(float)105/255 blue:(float)210/255 alpha:0.8f];
        
        dot.layer.cornerRadius = dot.frame.size.width/2;
        dot.layer.masksToBounds = YES;
        [cell addSubview:dot];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:friend.image100Url];
    
    __weak UITableViewCell* weakCell = cell; // __weak - because BLOCK
    
    cell.imageView.image = nil;
    
    
    
    [cell.imageView setImageWithURLRequest:request //method from "UIImageView+AFNetworking.h"
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
    if (indexPath.row == [self.friendsArray count])
    {
        [self getFriendsFromServer];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getFriendsFromServer];
        }
        [self getFriendsFromServer];
    }
}






@end
