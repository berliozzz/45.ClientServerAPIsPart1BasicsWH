//
//  ServerManager.h
//  APITest
//
//  Created by Nikolay Berlioz on 09.04.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                     onSuccess:(void(^)(NSArray *friends))success
                    onFailure:(void(^)(NSError *error))failure;

@end
