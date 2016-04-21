//
//  ServerManager.h
//  APITest
//
//  Created by Nikolay Berlioz on 09.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                     onSuccess:(void(^)(NSArray *friends))success
                    onFailure:(void(^)(NSError *error))failure;

- (void) getUserInfoWithId:(NSInteger)userId
                 onSuccess:(void(^)(User *user))success
                 onFailure:(void(^)(NSError *error))failure;

- (void) getFollowersWithId:(NSInteger)userId
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(void(^)(NSArray *followers))success
                  onFailure:(void(^)(NSError *error))failure;

- (void) getSubscriptionsWithId:(NSInteger)userId
                         offset:(NSInteger)offset
                          count:(NSInteger)count
                      onSuccess:(void(^)(NSArray *subscriptions))success
                      onFailure:(void(^)(NSError *error))failure;

- (void) getWallWithId:(NSInteger)ownerId
                offset:(NSInteger)offset
                 count:(NSInteger)count
             onSuccess:(void(^)(NSArray *subscriptions))success
             onFailure:(void(^)(NSError *error))failure;

@end
