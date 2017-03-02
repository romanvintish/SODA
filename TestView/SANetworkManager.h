//
//  SANetworkManager.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface SANetworkManager : NSObject

#pragma mark - GET data

- (void)fetchShopsWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block;
- (void)fetchShopsForIntrosWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block;
- (void)fetchNearlyShopsWithCordinate:(CLLocationCoordinate2D)coordinates andRadius:(CGFloat)radius withCompletion:(void (^)(id obj, NSError *err))block;
- (void)getPassion:(void (^)(id obj, NSError *err))complitionBlock;
- (void)searchForUser:(NSString *)userId
           withParams:(NSDictionary *)params
      complitionBlock:(void (^)(id searchedObj))complitionBlock
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)searchShopsForUser:(NSString *)userId
           withParams:(NSDictionary *)params
      complitionBlock:(void (^)(id searchedObj))complitionBlock
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
