//
//  SingleCellModell.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SingleCellModell.h"

@implementation SingleCellModell

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping hasMany:[Products class] forKeyPath:@"products"];
        [mapping hasOne:[ShopInfo class] forKeyPath:@"SellersInfo"];
    }];
}

@end


@implementation Products

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"description" : @"descriptions",
                                               @"image" : @"image",
                                               @"is_liked" : @"is_liked",
                                               }];
    }];
}

@end


@implementation ShopInfo

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"realName" : @"realName",
                                               }];
    }];
}

@end
