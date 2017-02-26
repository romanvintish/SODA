//
//  SearchPassion.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/24/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SearchPassion.h"

@implementation SearchPassion 

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"passionTitle" : @"passionTitle",
                                               @"sortParam" : @"sortParam"
                                               }];
    }];
}

@end
