//
//  VKUser.m
//  APITest
//
//  Created by MacUser on 16.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "VKUser.h"

@implementation VKUser

- (id) initWhithServerResponce: (NSDictionary*) responceObject
{
   self = [super initWhithServerResponce:responceObject];
    if (self) {
        
        self.firstName = [responceObject objectForKey:@"first_name"];
        self.lastName = [responceObject objectForKey:@"last_name"];
        
        NSString *urlString = [responceObject objectForKey:@"photo_50"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    return self;
}


 


@end
