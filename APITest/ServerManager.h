//
//  ServerManager.h
//  APITest
//
//  Created by MacUser on 14.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VKUser;

@interface ServerManager : NSObject

@property (strong, nonatomic, readonly) VKUser* currentUser;


+ (ServerManager*) sharedManager;

- (void) authorizeUser: (void(^)(VKUser* user)) completion;

- (void) getFriendsWhithOffset: (NSInteger) offset
                         count: (NSInteger) count
                     onSuccess:(void(^)(NSArray* friends)) success
                        onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getUser: (NSString*) userID
       onSuccess:(void(^)(VKUser* user)) success
         onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getGroupWall:(NSString*) groupID
          whithOffset: (NSInteger) offset
                count: (NSInteger) count
            onSuccess:(void(^)(NSArray* posts)) success
               onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) postText: (NSString*) text
      onGroupWall: (NSString*) groupID
         nSuccess:(void(^)(id result)) success
           onFail:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
