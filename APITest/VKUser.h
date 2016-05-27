//
//  VKUser.h
//  APITest
//
//  Created by MacUser on 16.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "ServerObject.h"
@interface VKUser : ServerObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *imageURL;

@end
