//
//  UILabel+UILabel___Height.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/17/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "UILabel+UILabel___Height.h"

@implementation UILabel (UILabel___Height)

+ (CGFloat)heightForText:(NSString*)text withViewWidth:(CGFloat)viewWidth textFont:(UIFont *)textFont
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:textFont , NSFontAttributeName, paragraph,
                                NSParagraphStyleAttributeName, @(2.0f), NSKernAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(viewWidth , CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return CGRectGetHeight(rect);
}

@end
