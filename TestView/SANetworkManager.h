//
//  SANetworkManager.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SAInternetErrorType)
{
    SAInternetErrorTypeNotError = 0,
    SAInternetErrorTypeLostConnection = 1,
    SAInternetErrorTypeServerError,
    SAInternetErrorTypeEmptyData
};

typedef NS_OPTIONS(NSUInteger, SAInternetConnectionStatus)
{
    SAInternetConnectionStatusNotConnection = 1,
    SAInternetConnectionStatusConnectionWifi,
    SAInternetConnectionStatusConnectionWWAN,
    SAInternetConnectionStatusConnectionUnkown
};


@protocol SAInternetChangeStatusDelegate <NSObject>

- (void)internetHasBeenConnected;
- (void)internetWasInterrupted;

@end


@interface SANetworkManager : NSObject

@property (nonatomic, assign) SAInternetConnectionStatus connectionStatus;

- (instancetype)initWithDelegate:(id<SAInternetChangeStatusDelegate>)delegate;
- (BOOL)networkConnected;
- (void)serverHasErrorWithType:(SAInternetErrorType)type;

#pragma mark - DELETE data

#pragma mark - GET data

- (void)fetchShopsWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block;
- (void)fetchShopsForIntrosWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block;

#pragma mark - POST requests

@end
