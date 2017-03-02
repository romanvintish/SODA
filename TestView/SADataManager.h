//
//  SADataManager.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleCellModell.h"
#import "MapKit/MapKit.h"
#import "IntrosCellModel.h"

@interface SADataManager : NSObject

+ (SADataManager *)sharedManager; 

- (void)downloadShopCollectionsWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block;
- (void)downloadShopCollectionsForIntrosWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block;
- (void)fetchNearlyShopsWithCordinate:(CLLocationCoordinate2D)coordinate
                            andRadius:(CGFloat)radius
                       withCompletion:(void (^)(id obj, NSError *err))block;
- (void)getPassion:(void (^)(id obj, NSError *err))complitionBlock;
- (void)searchInTheCategory:(NSString *)category
                  withMinId:(NSString *)minId
                   andMaxId:(NSString *)maxId
            complitionBlock:(void (^)(id searchedObj))complitionBlock
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)searchShopsInTheCategory:(NSString *)category
                  withMinId:(NSString *)minId
                   andMaxId:(NSString *)maxId
            complitionBlock:(void (^)(id searchedObj))complitionBlock
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)fetchCachedShopsWithWithCompletion:(void (^)(id obj, NSError *err))block;
- (void)placeShop:(SingleCellModell *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block;
- (void)fetchCachedIntrosShopsWithWithCompletion:(void (^)(id obj, NSError *err))block;
- (void)placeIntrosShop:(IntrosCellModel *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block;

@end
