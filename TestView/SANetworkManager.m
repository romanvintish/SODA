//
//  SANetworkManager.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SANetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "SingleCellModell.h"
#import "IntrosCellModel.h"
#import "ShopOnMapModell.h"
#import "SearchPassion.h"
#import "SearchedProducts.h"
#import "SearchedShops.h"

NSString *const kSABaseURL = @"http://2fair.jellyworkz.com/public/";
NSString *const kSARequestObserverKeyConnectionStatus = @"connectionStatus";
NSString *const kSARequestObserverKeyErrorStatus = @"serverError";
NSString *const kSARequestObserverParamKeyOld = @"old";
NSString *const kSARequestObserverParamKeyNew = @"new";

typedef enum NSString
{
    kSARequestTypePost,
    kSARequestTypeGET,
    kSARequestTypeDELETE
} kSARequestType;

NSString * const kSARequestTypeToString[] =
{
    [kSARequestTypePost] = @"POST",
    [kSARequestTypeGET] = @"GET",
    [kSARequestTypeDELETE] = @"DELETE",
};


@interface SANetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, weak) id<SAInternetChangeStatusDelegate>delegate;
@property (nonatomic, assign) SAInternetErrorType serverError;

@end


@implementation SANetworkManager

- (void)dealloc
{
    [self removeObserver:self forKeyPath:kSARequestObserverKeyConnectionStatus];
    [self removeObserver:self forKeyPath:kSARequestObserverKeyErrorStatus];
}

- (instancetype)initWithDelegate:(id<SAInternetChangeStatusDelegate>)delegate
{
    if (self = [self init]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.serverError = SAInternetErrorTypeNotError;
        self.connectionStatus = SAInternetConnectionStatusConnectionUnkown;
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        [self setObservers];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    [self checkConnected];
    return self;
}

- (void)setObservers
{
    [self addObserver:self forKeyPath:kSARequestObserverKeyConnectionStatus options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:kSARequestObserverKeyErrorStatus options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)checkConnected
{
    self.connectionStatus = [self connectionStatus];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"No Internet Connection");
                self.connectionStatus = SAInternetConnectionStatusNotConnection;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                self.connectionStatus = SAInternetConnectionStatusConnectionWifi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                self.connectionStatus = SAInternetConnectionStatusConnectionWWAN;
                break;
            default:
                NSLog(@"Unkown network status");
                self.connectionStatus = SAInternetConnectionStatusConnectionUnkown;
                break;
        }
    }];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:kSARequestObserverKeyConnectionStatus]) {
        if ([[change objectForKey:kSARequestObserverParamKeyOld] integerValue] == SAInternetConnectionStatusNotConnection ||
            [[change objectForKey:kSARequestObserverParamKeyOld] integerValue] == SAInternetConnectionStatusConnectionUnkown) {
            if ([[change objectForKey:kSARequestObserverParamKeyNew] integerValue] == SAInternetConnectionStatusConnectionWifi ||
                [[change objectForKey:kSARequestObserverParamKeyNew] integerValue] == SAInternetConnectionStatusConnectionWWAN) {
                if ([self.delegate respondsToSelector:@selector(internetHasBeenConnected)]) {
                    [self.delegate performSelector:@selector(internetHasBeenConnected)];
                }
            }
        } else if ([[change objectForKey:kSARequestObserverParamKeyNew] integerValue] == SAInternetConnectionStatusNotConnection) {
            if ([self.delegate respondsToSelector:@selector(internetWasInterrupted)]) {
                [self.delegate performSelector:@selector(internetWasInterrupted)];
            }
        }
    } else if ([keyPath isEqualToString:kSARequestObserverKeyErrorStatus]) {
        if ([[change objectForKey:kSARequestObserverParamKeyOld] integerValue] == SAInternetErrorTypeNotError) {
            if ([[change objectForKey:kSARequestObserverParamKeyNew] integerValue] == SAInternetErrorTypeLostConnection | [[change objectForKey:kSARequestObserverParamKeyNew] integerValue] == SAInternetErrorTypeServerError | [[change objectForKey:kSARequestObserverParamKeyNew] integerValue] ==  SAInternetErrorTypeEmptyData) {
                [self serverHasErrorWithType:self.serverError];
            }
        }
    }
}

- (void)serverHasErrorWithType:(SAInternetErrorType)type
{
    NSString *title = @"Error";
    NSString *message;
    
    if (type == SAInternetErrorTypeLostConnection) {
        message = @"Check the Internet connection";
    } else if (type == SAInternetErrorTypeServerError) {
        message = @"Server error";
    }
    
    [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    self.serverError = SAInternetErrorTypeNotError;
}

- (BOOL)networkConnected
{
    [self checkConnected];
    if (self.connectionStatus == SAInternetConnectionStatusConnectionWifi ||
        self.connectionStatus == SAInternetConnectionStatusConnectionWWAN) {
        return YES;
    }
    return NO;
}

#pragma mark - DELETE
#pragma mark - GET

- (void)fetchShopsWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block
{
    NSString *urlSearchWithName = [NSString stringWithFormat:@"%@/user/%@/data/activityFeed&minId=%ld&maxId=%ld",kSABaseURL,userId, (long)start ,(long)end];

    [self.manager GET:urlSearchWithName
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSMutableArray *items = [[NSMutableArray alloc] init];
                 for (id obj in [[responseObject valueForKey:@"activity"] valueForKey:@"shop"]) {
                         SingleCellModell *curentItem = [EKMapper objectFromExternalRepresentation:obj
                                                                                 withMapping:[SingleCellModell objectMapping]];
                     for (NSInteger i =0 ; i < curentItem.products.count; i++) {
                         Products *product = [curentItem.products objectAtIndex:i];
                         product.realName = curentItem.SellersInfo.realName;
                     }
                         [items addObject:curentItem];
                     }
             if (block) {
             block(items,nil);
             }
                 }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             if (block) {
                 block(nil,error);
             }
    }];
}

- (void)fetchShopsForIntrosWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block
{
    NSString *urlSearchWithName = [NSString stringWithFormat:@"%@/user/%@/data/activityFeed&minId=%ld&maxId=%ld",kSABaseURL,userId, (long)start ,(long)end];
    
    [self.manager GET:urlSearchWithName
           parameters:nil
             progress:nil
              success:^(NSURLSessionTask *task, id responseObject) {
                  NSMutableArray *items = [[NSMutableArray alloc] init];
                  for (id obj in [[responseObject valueForKey:@"activity"] valueForKey:@"shop"]) {
                      IntrosCellModel *curentItem = [EKMapper objectFromExternalRepresentation:obj
                                                                                    withMapping:[IntrosCellModel objectMapping]];
                      [items addObject:curentItem];
                  }
                  if (block) {
                  block(items,nil);
                  }
              }
              failure:^(NSURLSessionTask *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  if (block) {
                      block(nil,error);
                  }
              }];
}

- (void)fetchNearlyShopsWithCordinate:(CLLocationCoordinate2D)coordinate andRadius:(CGFloat)radius withCompletion:(void (^)(id obj, NSError *err))block
{
    NSDictionary *parameters = @{
                                                                     @"long"    :   [NSNumber numberWithDouble:coordinate.longitude],
                                                                     @"lat"     :   [NSNumber numberWithDouble:coordinate.latitude],
                                                                     @"radius"  :   [NSNumber numberWithDouble:radius]
                                                                     };
    NSString *urlSearchWithName = [NSString stringWithFormat:@"%@/user/data/search/location",kSABaseURL];
    
    [self.manager GET:urlSearchWithName
           parameters:parameters
             progress:nil
              success:^(NSURLSessionTask *task, id responseObject) {
                  NSMutableArray *items = [[NSMutableArray alloc] init];
                  for (id obj in [responseObject valueForKey:@"shops"]) {
                      ShopOnMapModell *curentItem = [EKMapper objectFromExternalRepresentation:obj
                                                                                   withMapping:[ShopOnMapModell objectMapping]];
                      CLLocationCoordinate2D coordinate;
                      coordinate.latitude = [curentItem.latitude doubleValue];
                      coordinate.longitude = [curentItem.longitude doubleValue];
                      
                      curentItem.coordinate = coordinate;
                      
                      curentItem.title = curentItem.username;

                      [items addObject:curentItem];
                  }
                  if (block) {
                  block(items,nil);
                  }
                  }
              failure:^(NSURLSessionTask *operation, NSError *error) {
                  if (block) {
                      block(nil,error);
                  }
              }];
}

- (void)getPassion:(void (^)(id obj, NSError *err))complitionBlock{
    NSString *urlSearchWithName = [NSString stringWithFormat:@"%@/user/data/outhData",kSABaseURL];
    
    [self.manager GET:urlSearchWithName parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask* _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (id obj in [responseObject valueForKey:@"passionsArr"]) {
            SearchPassion *curentItem = [EKMapper objectFromExternalRepresentation:obj
                                                                         withMapping:[SearchPassion objectMapping]];
            [items addObject:curentItem];
        }
        
        if (complitionBlock) {
            complitionBlock(items,nil);
        }
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        if (complitionBlock){
            NSError *err = [[NSError alloc] init];
            complitionBlock(nil,err);
        }
    }];

}

- (void)searchForUser:(NSString *)userId
           withParams:(NSDictionary *)params
      complitionBlock:(void (^)(id searchedObj))complitionBlock
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSString *urlSearchWithName = [NSString stringWithFormat:@"%@user/%@/data/search",kSABaseURL,userId];

    //self.manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [self.manager GET:urlSearchWithName
           parameters:params
             progress:nil
              success:^(NSURLSessionDataTask* _Nonnull task, id  _Nullable responseObject) {
                  NSMutableArray *items = [[NSMutableArray alloc] init];
                  for (id obj in [responseObject valueForKey:@"products"]) {
                       SearchedProducts *curentItem = [EKMapper objectFromExternalRepresentation:obj
                                                                                 withMapping:[SearchedProducts objectMapping]];
                      [items addObject:curentItem];
                  }
                  
                  if (complitionBlock) {
                      complitionBlock(items);
        }
    }
              failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

- (void)searchShopsForUser:(NSString *)userId
           withParams:(NSDictionary *)params
      complitionBlock:(void (^)(id searchedObj))complitionBlock
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSString *urlSearchWithName = [NSString stringWithFormat:@"%@user/%@/data/search",kSABaseURL,userId];
    
    [self.manager GET:urlSearchWithName
           parameters:params
             progress:nil
              success:^(NSURLSessionDataTask* _Nonnull task, id  _Nullable responseObject) {
                  NSLog(@"%@",responseObject);
                  NSMutableArray *items = [[NSMutableArray alloc] init];
                  for (id obj in [responseObject valueForKey:@"shops"]) {
                      SearchedShops *curentItem = [EKMapper objectFromExternalRepresentation:obj
                                                                                    withMapping:[SearchedShops objectMapping]];
                      [items addObject:curentItem];
                  }
                  
                  if (complitionBlock) {
                      complitionBlock(items);
                  }
              }
              failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                  if (failure) {
                      failure(task,error);
                  }
              }];
}

#pragma mark - POST

@end
