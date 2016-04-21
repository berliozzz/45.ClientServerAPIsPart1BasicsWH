//
//  Wall.h
//  APITest
//
//  Created by Nikolay Berlioz on 21.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wall : NSObject

@property (strong, nonatomic) NSString *postText;


- (id) initWithServerResponse:(NSDictionary*)responseObject;

@end
