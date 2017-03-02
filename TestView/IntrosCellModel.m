//
//  IntrosCellModel.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "IntrosCellModel.h"

@implementation IntrosCellModel

+(EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"shopPicture" : @"shopPicture",
                                               @"followed" : @"followed",
                                               }];
        
        [mapping hasMany:[ProductsIntros class] forKeyPath:@"products"];
        [mapping hasOne:[ShopInfoIntros class] forKeyPath:@"SellersInfo"];
    }];
}

@end


@implementation ProductsIntros

+(EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"description" : @"descriptions",
                                               @"image" : @"prodImage",
                                               @"is_liked" : @"is_liked",
                                               @"realName" : @"realName",
                                               @"LikedCount" : @"LikedCount",
                                               }];
    }];
}

@end


@implementation ShopInfoIntros

+(EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"realName" : @"realName",
                                               @"country" : @"country"
                                               }];
    }];
}

@end
