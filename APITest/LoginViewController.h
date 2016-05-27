//
//  LoginViewController.h
//  APITest
//
//  Created by MacUser on 17.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccessToken;

typedef void(^LoginCompletionBlock)(AccessToken* token);

@interface LoginViewController : UIViewController

- (id) initWhithCompletioBlock: (LoginCompletionBlock) completionBlock;

@end
