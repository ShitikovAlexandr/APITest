//
//  PostCell.m
//  APITest
//
//  Created by MacUser on 19.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForText: (NSString*) text {
    
    CGFloat offset = 5.0;
    
    UIFont* font = [UIFont systemFontOfSize: 17.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                paragraph, NSParagraphStyleAttributeName,
                                shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
        
    return  CGRectGetHeight(rect) + 2 * offset;
    
}


@end
