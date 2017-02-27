//
//  SADataManager.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SADataManager.h"

NSString *const kSAUserID = @"2233855952";

@interface SADataManager () <SAInternetChangeStatusDelegate>

@property (nonatomic, strong, readwrite) SADataSource *dataSource;
@property (nonatomic, strong, readwrite) SANetworkManager *requestManager;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) BOOL connectionDetected;

@end

@implementation SADataManager

+ (SADataManager *)sharedManager
{
    static SADataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataManager == nil) {
            dataManager = [[self alloc] init];
        }
    });
    return dataManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dataSource = [[SADataSource alloc] init];
        self.requestManager = [[SANetworkManager alloc] initWithDelegate:self];
        self.connectionDetected = NO;
    }
    return self;
}

- (BOOL)internetWasDetected
{
    return self.connectionDetected;
}


#pragma mark - <SAInternetChangeStatusDelegate>


- (void)internetHasBeenConnected
{
    self.connectionDetected = YES;
}

- (void)internetWasInterrupted
{
    self.connectionDetected = YES;
    [self.requestManager serverHasErrorWithType:SAInternetErrorTypeLostConnection];
}

- (void)downloadShopCollectionsWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block{
        [self.requestManager fetchShopsWithID:kSAUserID withStart:start withEnd:end withCompletion:^(id obj, NSError *err) {
            block(obj,err);}];
}

- (void)downloadShopCollectionsForIntrosWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block{
    if (self.connectionDetected) {
        [self.requestManager fetchShopsForIntrosWithID:kSAUserID withStart:start withEnd:end withCompletion:^(id obj, NSError *err) {
            block(obj,err);}];
    } else {
        if (block) {
            NSError *err = [[NSError alloc] init];
            block(nil,err);
        }
    }
}

- (void)fetchNearlyShopsWithCordinate:(CLLocationCoordinate2D)coordinate andRadius:(CGFloat)radius withCompletion:(void (^)(id obj, NSError *err))block{
    if (self.connectionDetected) {
        [self.requestManager fetchNearlyShopsWithCordinate:coordinate andRadius:radius withCompletion:^(id obj, NSError *err) {
            block(obj,err);}];
    } else {
        if (block) {
            NSError *err = [[NSError alloc] init];
            block(nil,err);
        }
    }
}

- (void)getPassion:(void (^)(id obj, NSError *err))complitionBlock{
    if (self.connectionDetected) {
        [self.requestManager getPassion:^(id obj, NSError *err) {
            complitionBlock(obj,err);
             }];
    } else {
        if (complitionBlock) {
            NSError *err = [[NSError alloc] init];
            complitionBlock(nil,err);
        }
    }
    

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

    if (self.connectionDetected) {
        [self.requestManager searchForUser:kSAUserID withParams:parameters complitionBlock:complitionBlock failure:failure];
    } else {
        if (failure) {
            failure(nil,nil);
        }
    }
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
    
    if (self.connectionDetected) {
        [self.requestManager searchShopsForUser:kSAUserID withParams:parameters complitionBlock:complitionBlock failure:failure];
    } else {
        if (failure) {
            failure(nil,nil);
        }
    }
}

@end

