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
#import "Wall.h"

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

// ======================  Get Wall  =======================================

- (void) getWallWithId:(NSInteger)ownerId
                         offset:(NSInteger)offset
                          count:(NSInteger)count
                      onSuccess:(void(^)(NSArray *wallItems))success
                      onFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(ownerId), @"owner_id",
                            @(count), @"count",
                            @(offset), @"offset",
                            @(5.5f), @"v", nil];
    [self.sessionManager
     GET:@"wall.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSMutableArray *objectsArray = [NSMutableArray array];
        
        NSDictionary *dict = [responseObject objectForKey:@"response"];
        
        NSArray *itemsArray = [dict objectForKey:@"items"];
        
        for (NSDictionary *dic in itemsArray)
        {
            Wall *wall = [[Wall alloc] initWithServerResponse:dic];
            
            [objectsArray addObject:wall];
        }
        
        if (success)
        {
            success(objectsArray);
        }
        
        
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


// ======================  Get Subscriptions  ==============================

- (void) getSubscriptionsWithId:(NSInteger)userId
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(void(^)(NSArray *subscriptions))success
                  onFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userId), @"user_id",
                            @(count), @"count",
                            @(offset), @"offset",
                            @(1), @"extended",
                            @"photo_100", @"fields",
                            @(5.5f), @"v", nil];
    [self.sessionManager
     GET:@"users.getSubscriptions"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSMutableArray *objectsArray = [NSMutableArray array];
         
         NSDictionary *dict = [responseObject objectForKey:@"response"];
         
         NSArray *itemsArray = [dict objectForKey:@"items"];
         
         for (NSDictionary *dic in itemsArray)
         {
             User *user = [[User alloc] initWithServerResponse:dic];
             [objectsArray addObject:user];
         }
         
         
         if (success)
         {
             success(objectsArray);
         }
         
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

// ======================  Get Followers  ==================================

- (void) getFollowersWithId:(NSInteger)userId
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                 onSuccess:(void(^)(NSArray *followers))success
                 onFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userId), @"user_id",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"photo_100, photo_200, city, online", @"fields",
                            @(5.8f), @"v", nil];
    [self.sessionManager
     GET:@"users.getFollowers"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSMutableArray *objectsArray = [NSMutableArray array];
        
        NSDictionary *dict = [responseObject objectForKey:@"response"];
        
        NSArray *itemsArray = [dict objectForKey:@"items"];
        
        for (NSDictionary *dic in itemsArray)
        {
            User *user = [[User alloc] initWithServerResponse:dic];
            [objectsArray addObject:user];
        }
        
        
        if (success)
        {
            success(objectsArray);
        }
        
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

// ======================  Get User Info  ==================================

- (void) getUserInfoWithId:(NSInteger)userId
                onSuccess:(void(^)(User *user))success
                 onFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userId), @"user_ids",
                            @"photo_200, online, city", @"fields",
                            @"nom", @"name_case",
                            @(5.8f), @"v", nil];
    [self.sessionManager
     GET:@"users.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSLog(@"USER INFO: %@", responseObject);
         
         NSArray* friendsArray = [responseObject objectForKey:@"response"];
         User* user = nil;
         
         for (NSDictionary* dict in friendsArray) {
             user = [[User alloc] initWithServerResponse:dict];
         }
         
         
         if (success) {
             success(user);
         }
         
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

// ======================  Get Friends  ==================================

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
                            @"nom", @"name_case", nil];
    
    
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






