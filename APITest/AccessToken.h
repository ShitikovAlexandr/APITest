//
//  AccessToken.h
//  APITest
//
//  Created by MacUser on 17.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* userID;

@end
