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

NSString *const kSABaseURL = @"http://2fair.jellyworkz.com/public/";

@interface SANetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation SANetworkManager

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

#pragma mark - GET

- (void)fetchShopsWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block {
    NSString *urlSearchWithName = [NSString stringWithFormat:@"%@/user/%@/data/activityFeed&minId=%ld&maxId=%ld",kSABaseURL,userId, (long)start ,(long)end];
    [self.manager.requestSerializer setTimeoutInterval:3.0];
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

- (void)fetchShopsForIntrosWithID:(NSString*)userId withStart:(NSInteger)start withEnd:(NSInteger)end withCompletion:(void (^)(id obj, NSError *err))block {
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

- (void)fetchNearlyShopsWithCordinate:(CLLocationCoordinate2D)coordinate andRadius:(CGFloat)radius withCompletion:(void (^)(id obj, NSError *err))block {
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

- (void)getPassion:(void (^)(id obj, NSError *err))complitionBlock {
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

@end
