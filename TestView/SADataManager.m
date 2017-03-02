//
//  SADataManager.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SADataManager.h"
#import "SANetworkManager.h"
#import "SADataSource.h"

NSString *const kSAUserID = @"2233855952";

@interface SADataManager ()

@property (nonatomic, strong, readwrite) SADataSource *dataSource;
@property (nonatomic, strong, readwrite) SANetworkManager *requestManager;
@property (nonatomic, strong) NSString *token;

@end

@implementation SADataManager

+ (SADataManager *)sharedManager {
    static SADataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataManager == nil) {
            dataManager = [[self alloc] init];
        }
    });
    return dataManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.dataSource = [[SADataSource alloc] init];
        self.requestManager = [[SANetworkManager alloc] init];
    }
    return self;
}

- (void)downloadShopCollectionsWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block {
        [self.requestManager fetchShopsWithID:kSAUserID withStart:start withEnd:end withCompletion:^(id obj, NSError *err) {
            block(obj,err);}];
}

#pragma mark - NetworkManager

- (void)downloadShopCollectionsForIntrosWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))bloc {
        [self.requestManager fetchShopsForIntrosWithID:kSAUserID withStart:start withEnd:end withCompletion:^(id obj, NSError *err) {
            if (!err) {
                if (bloc) {
                    bloc(obj,nil);
                }
            } else {
                if (bloc) {
                    bloc(nil,err);
                }
            }
        }];
}

- (void)fetchNearlyShopsWithCordinate:(CLLocationCoordinate2D)coordinate andRadius:(CGFloat)radius withCompletion:(void (^)(id obj, NSError *err))block {
        [self.requestManager fetchNearlyShopsWithCordinate:coordinate andRadius:radius withCompletion:^(id obj, NSError *err) {
            if (!err) {
                if (block) {
                    block(obj,nil);
                }
            } else {
                if (block) {
                    block(nil,err);
                }
            }
        }];
}

- (void)getPassion:(void (^)(id obj, NSError *err))complitionBlock {
        [self.requestManager getPassion:^(id obj, NSError *err) {
            if (!err) {
                if (complitionBlock) {
                    complitionBlock(obj,nil);
                }
            } else {
                if (complitionBlock) {
                complitionBlock(nil,err);
                }
            }
        }];
}

- (void)searchInTheCategory:(NSString *)category
                  withMinId:(NSString *)minId
                   andMaxId:(NSString *)maxId
            complitionBlock:(void (^)(id searchedObj))complitionBlock
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"category"    :   [category isEqualToString:@""]      ? @""      : category == nil    ? @"" : category,
                                 @"where"       :   @"products",
                                 @"minId"       :   [minId isEqualToString:@""]         ? @"0"     : minId == nil       ? @"0" : minId,
                                 @"maxId"       :   [maxId isEqualToString:@""]         ? @"20"    : maxId == nil       ? @"0" : maxId,
                                 @"what"        :   @"",
                                 @"city"        :   @"",
                                 @"countryName" :   @"",
                                 @"zipCode"     :   @"",
                                 @"address"     :   @"",
                                 };

    [self.requestManager searchForUser:kSAUserID withParams:parameters complitionBlock:complitionBlock failure:failure];
}

- (void)searchShopsInTheCategory:(NSString *)category
                  withMinId:(NSString *)minId
                   andMaxId:(NSString *)maxId
            complitionBlock:(void (^)(id searchedObj))complitionBlock
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"category"    :   [category isEqualToString:@""]      ? @""      : category == nil    ? @"" : category,
                                 @"where"       :   @"shops",
                                 @"minId"       :   [minId isEqualToString:@""]         ? @"0"     : minId == nil       ? @"0" : minId,
                                 @"maxId"       :   [maxId isEqualToString:@""]         ? @"20"    : maxId == nil       ? @"0" : maxId,
                                 @"what"        :   @"",
                                 @"city"        :   @"",
                                 @"countryName" :   @"",
                                 @"zipCode"     :   @"",
                                 @"address"     :   @"",
                                 };

        [self.requestManager searchShopsForUser:kSAUserID withParams:parameters complitionBlock:complitionBlock failure:failure];
}

#pragma mark - DataSource

- (void)fetchCachedShopsWithWithCompletion:(void (^)(id obj, NSError *err))block {
    [self.dataSource fetchCachedShopsWithWithCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];
}

- (void)placeShop:(SingleCellModell *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block {
    [self.dataSource placeShop:shop toCacheWithWithCompletion:^(NSError *err) {
        block(err);
    }];
}

- (void)fetchCachedIntrosShopsWithWithCompletion:(void (^)(id obj, NSError *err))block {
    [self.dataSource fetchCachedIntrosShopsWithWithCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];
}

- (void)placeIntrosShop:(IntrosCellModel *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block {
    [self.dataSource placeIntrosShop:shop toCacheWithWithCompletion:^(NSError *err) {
        block(err);
    }];
}

@end

