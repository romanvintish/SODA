//
//  SADataManager.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SANetworkManager.h"
#import "SADataSource.h"

@interface SADataManager : NSObject

+ (SADataManager *)sharedManager; // SADataManager.sharedManager

- (BOOL)internetWasDetected;

- (void)downloadShopCollectionsWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block;
- (void)downloadShopCollectionsForIntrosWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block;

@end
