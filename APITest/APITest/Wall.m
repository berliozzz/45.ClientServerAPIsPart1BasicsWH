//
//  Wall.m
//  APITest
//
//  Created by Nikolay Berlioz on 21.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "Wall.h"

@implementation Wall


- (id) initWithServerResponse:(NSDictionary*)responseObject
{
    self = [super init];
    if (self)
    {
        self.postText = [responseObject objectForKey:@"text"];
    }
    return self;
}

@end
