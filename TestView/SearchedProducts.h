//
//  SearchedProducts.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/27/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyMapping.h>

@interface SearchedProducts : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSString* descriptions;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) BOOL is_liked;

@end
