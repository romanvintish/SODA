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
@property (nonatomic, strong) NSOperationQueue *myQueue;
@property (nonatomic, assign) BOOL taskWasComplete;
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
        self.myQueue = [[NSOperationQueue alloc] init];
        self.taskWasComplete = YES;
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
    //[self loginCompletionBloc:nil failBlock:nil];
    //[self fetchAvailableProducts];
    self.connectionDetected = YES;
}

- (void)internetWasInterrupted
{
    self.connectionDetected = YES;
    [self.requestManager serverHasErrorWithType:SAInternetErrorTypeLostConnection];
}

- (void)downloadShopCollectionsWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block
{
        [self.requestManager fetchShopsWithID:kSAUserID withStart:start withEnd:end withCompletion:^(id obj, NSError *err) {
            block(obj,err);
            }];
}

- (void)downloadShopCollectionsForIntrosWithStart:(NSInteger)start withEnd:(NSInteger)end WithCompletion:(void (^)(id obj, NSError *err))block
{
    [self.requestManager fetchShopsForIntrosWithID:kSAUserID withStart:start withEnd:end withCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];
}

@end

