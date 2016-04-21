//
//  User.m
//  APITest
//
//  Created by Nikolay Berlioz on 09.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithServerResponse:(NSDictionary*)responseObject
{
    self = [super init];
    if (self)
    {
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.name = [responseObject objectForKey:@"name"];
        
        NSString *online = [responseObject objectForKey:@"online"];
        
        if (online)
        {
            self.isOnline = online.boolValue;
        }
        
        NSString *url100 = [responseObject objectForKey:@"photo_100"];
        
        if (url100)
        {
            self.image100Url = [NSURL URLWithString:url100];
        }
        
        NSString *url200 = [responseObject objectForKey:@"photo_200"];
        
        if (url200)
        {
            self.image200Url = [NSURL URLWithString:url200];
        }
        
        NSString *userId = [responseObject objectForKey:@"user_id"];
        
        if (userId)
        {
            self.userId = userId.integerValue;
        }
        
        NSString *shortUserId = [responseObject objectForKey:@"id"];
        
        if (shortUserId)
        {
            self.shortUserId = shortUserId.integerValue;
        }
        
        NSDictionary *city = [responseObject objectForKey:@"city"];
        
        if (city)
        {
            self.city = [city objectForKey:@"title"];
        }
        
        
    }
    return self;
}





@end


