//
//  UserDetailViewController.h
//  APITest
//
//  Created by Nikolay Berlioz on 10.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface UserDetailViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) User *user;


@end
