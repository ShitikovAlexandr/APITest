//
//  ServerManager.m
//  APITest
//
//  Created by MacUser on 14.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "AccessToken.h"

#import "VKUser.h"
#import "PostWall.h"

@interface ServerManager()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager; //this is from AFN 3.0
@property (strong, nonatomic) AccessToken* accessToken;

@end

@implementation ServerManager

+ (ServerManager*) sharedManager {
    
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

#pragma mark - API Methods

- (void) authorizeUser: (void(^)(VKUser* user)) completion {
    
    LoginViewController* vc = [[LoginViewController alloc] initWhithCompletioBlock:^(AccessToken *token) {
        self.accessToken = token;
        
        if (token) {
            [self getUser:self.accessToken.userID
                 onSuccess:^(VKUser *user) {
                     if (completion) {
                         completion(user);
                     }
                 }
                   onFail:^(NSError *error, NSInteger statusCode) {
                       if (completion) {
                           completion(nil);
                       }
                   }];
        }
        
        else if (completion) {
            completion(nil);
        }
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController ];
    
    [mainVC presentViewController:nav animated:YES completion: nil];
}

-(void) getUser: (NSString*) userID onSuccess:(void(^)(VKUser* user)) success
         onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID,       @"user_ids",
                            @"photo_50",  @"fields",
                            @"nom",       @"name_case", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         
                         NSLog(@"JSON: %@", responseObject);
                         
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         if ([dictsArray count]> 0) {
                             VKUser *user = [[VKUser alloc] initWhithServerResponce:[dictsArray firstObject]];
                             if (success) {
                                 success(user);
                             }
                         } else {
                             if (failure) {
                                 //failure(nil, operation.response.accessibilityElementCount);
                             }
                         }
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             
                             VKUser *user = [[VKUser alloc] initWhithServerResponce:dict];
                             [objectsArray addObject:user];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(error, operation.response.accessibilityElementCount);
                         }
                         
                     }];

    
}

- (void) getFriendsWhithOffset: (NSInteger) offset
                         count: (NSInteger) count
                     onSuccess:(void(^)(NSArray* friends)) success
                        onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"24723019", @"user_id",
                            @"name",      @"order",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"photo_50",  @"fields",
                            @"nom",       @"name_case", nil];
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                  progress:nil
                  success:^(NSURLSessionTask *task, id responseObject) {
                      
        NSLog(@"JSON: %@", responseObject);
                      
                      NSArray* dictsArray = [responseObject objectForKey:@"response"];
                      
                      NSMutableArray *objectsArray = [NSMutableArray array];
                      
                      for (NSDictionary* dict in dictsArray) {
                          
                          VKUser *user = [[VKUser alloc] initWhithServerResponce:dict];
                          [objectsArray addObject:user];
                      }
                       
                      if (success) {
                          success(objectsArray);
                      }
                      
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (failure) {
            failure(error, operation.response.accessibilityElementCount);
        }
        
    }];
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>

- (void) getGroupWall:(NSString*) groupID
          whithOffset: (NSInteger) offset
                count: (NSInteger) count
            onSuccess:(void(^)(NSArray* posts)) success
               onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            groupID,      @"owner_id",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"all",       @"filter", nil];
    
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         
                         NSLog(@"JSON: %@", responseObject);
                         
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         if ([dictsArray count] > 1) {
                             dictsArray = [dictsArray subarrayWithRange:NSMakeRange(1, (int)[dictsArray count] - 1)];
                         } else {
                             dictsArray = nil;
                         }
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             
                             PostWall *user = [[PostWall alloc] initWhithServerResponce:dict];
                             [objectsArray addObject:user];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(error, operation.response.accessibilityElementCount);
                         }
                         
                     }];

    
}

- (void) postText: (NSString*) text
      onGroupWall: (NSString*) groupID
         nSuccess:(void(^)(id result)) success
           onFail:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            groupID,                @"owner_id",
                            text,                   @"message",
                            self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager POST:@"wall.post"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         
                         NSLog(@"JSON: %@", responseObject);
                         
                         if (success) {
                             success(responseObject);
                         }
                         
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(error, operation.response.accessibilityElementCount);
                         }
                         
                     }];
    
}

@end
