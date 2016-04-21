//
//  MainUserPhotoCell.h
//  APITest
//
//  Created by Nikolay Berlioz on 19.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainUserPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

@end
