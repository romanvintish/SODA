//
//  SearchPassion.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/24/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyMapping.h>

@interface SearchPassion : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSString *passionTitle;
@property (nonatomic) NSInteger sortParam;

@end
