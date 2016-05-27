//
//  PostCell.h
//  APITest
//
//  Created by MacUser on 19.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * postTextLable;

+ (CGFloat) heightForText: (NSString*) text;

@end
