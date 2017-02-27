//
//  SearchedShops.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/27/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyMapping.h>

@interface SearchedShops : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString* descriptions;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* username;

@end
