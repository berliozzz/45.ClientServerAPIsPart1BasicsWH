//
//  FollowersViewController.h
//  APITest
//
//  Created by Nikolay Berlioz on 20.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowersViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger userId;

@end
