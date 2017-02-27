//
//  SearchedProducts.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/27/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SearchedProducts.h"

@implementation SearchedProducts

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"description" : @"descriptions",
                                               @"image" : @"image",
                                               @"is_liked" : @"is_liked",
                                               @"name" : @"id"
                                               }];
    }];
}

@end
