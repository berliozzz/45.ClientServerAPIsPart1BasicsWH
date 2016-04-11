//
//  User.h
//  APITest
//
//  Created by Nikolay Berlioz on 09.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *image100Url;
@property (strong, nonatomic) NSURL *image200Url;
@property (assign, nonatomic) BOOL isOnline;

- (id) initWithServerResponse:(NSDictionary*)responseObject;

@end
