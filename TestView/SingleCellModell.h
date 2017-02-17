//
//  SingleCellModell.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyMapping.h>



@interface Products : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString* descriptions;
@property (nonatomic, copy) NSString* image;
@property (nonatomic) BOOL is_liked;
@property (nonatomic, strong) NSString* realName;

@end


@interface ShopInfo : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString* realName;

@end


@interface SingleCellModell : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) ShopInfo* SellersInfo;

@end
