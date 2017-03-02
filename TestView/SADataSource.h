//
//  SADataSource.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleCellModell.h"
#import "IntrosCellModel.h"

@interface SADataSource : NSObject

- (void)fetchCachedShopsWithWithCompletion:(void (^)(id obj, NSError *err))block;
- (void)placeShop:(SingleCellModell *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block;
- (void)fetchCachedIntrosShopsWithWithCompletion:(void (^)(id obj, NSError *err))block;
- (void)placeIntrosShop:(IntrosCellModel *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block;

@end
