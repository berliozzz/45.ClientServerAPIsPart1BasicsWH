//
//  ServerManager.m
//  APITest
//
//  Created by Nikolay Berlioz on 09.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "User.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation ServerManager

+ (ServerManager*) sharedManager
{
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) getUserInfoWithId:(NSInteger)userId
                                        onSuccess:(void(^)(User *user))success
                                        onFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userId), @"user_ids",
                            @"photo_200, online", @"fields",
                            @"nom", @"name_case",  nil];
    [self.sessionManager
     GET:@"users.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"Error: %@", error);
         
         if (failure)
         {
             failure(error);
         }
     }];
    
    
    
    
}

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray *friends))success
                    onFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"25187841", @"user_id",
                            @"name", @"order",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"photo_100, online", @"fields",
                            @"nom", @"name_case",  nil];
    
    
    [self.sessionManager
                    GET:@"friends.get"
                    parameters:params
                    progress:nil
    
    success:^(NSURLSessionTask *task, id responseObject)
    {
         NSLog(@"JSON: %@", responseObject);
         
         NSArray *dictsArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray *objectsArray = [NSMutableArray array];
         
         for (NSDictionary *dict in dictsArray)
         {
             User *user = [[User alloc] initWithServerResponse:dict];
             
             [objectsArray addObject:user];
         }
         
         if (success)
         {
             success(objectsArray);
         }
    }
    failure:^(NSURLSessionTask *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
        
        if (failure)
        {
            failure(error);
        }
        
    }];
}

@end






