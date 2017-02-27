//
//  IntrosCellModel.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyMapping.h>

@interface ShopInfoIntros : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString* realName;
@property (nonatomic, copy) NSString* country;

@end

@interface ProductsIntros : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString* descriptions;
@property (nonatomic, copy) NSString* prodImage;
@property (nonatomic) BOOL is_liked;
@property (nonatomic, strong) NSString* realName;
@property (nonatomic) NSInteger LikedCount;

@end

@interface IntrosCellModel : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString* shopPicture;
@property (nonatomic, strong) ShopInfoIntros* SellersInfo;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic) NSInteger followed;

@end

