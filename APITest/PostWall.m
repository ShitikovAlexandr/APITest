//
//  PostWall.m
//  APITest
//
//  Created by MacUser on 19.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "PostWall.h"

@implementation PostWall

- (id) initWhithServerResponce: (NSDictionary*) responceObject
{
    self = [super initWhithServerResponce:responceObject];
    if (self) {
        self.text = [responceObject objectForKey:@"text"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    }
    return self;
}

@end
