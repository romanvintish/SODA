//
//  SADataSource.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SADataSource.h"
#import "CDShop+CoreDataClass.h"
#import "CDShopInfo+CoreDataClass.h"
#import "CDProducts+CoreDataClass.h"

@interface SADataSource()

@end

@implementation SADataSource

- (void)fetchCachedShopsWithWithCompletion:(void (^)(id obj, NSError *err))block {
    NSArray *shops = [[CDShop MR_findAll] mutableCopy];
    NSMutableArray *models = [[NSMutableArray alloc]init];
    
    if (shops == nil) {
        if (block) {
            NSError *err = [[NSError alloc]init];
            block(nil,err);
        }
    } else {
        for (CDShop *item in shops) {
            SingleCellModell *model = [[SingleCellModell alloc]init];
            model.SellersInfo = [[ShopInfo alloc]init];
            model.SellersInfo.realName = item.shopInfo.realName;
            NSSet *setproducts= item.products;
            
            model.products = [[NSMutableArray alloc]init];
            for (CDProducts *prod in setproducts) {
                Products *insProd = [[Products alloc]init];
                insProd.descriptions = prod.descriptions;
                insProd.image = prod.image;
                insProd.is_liked = prod.is_liked;
                [model.products addObject:insProd];
            }
            [models addObject:model];
        }
        if (block) {
            block(models,nil);
        }
    }
}

- (void)placeShop:(SingleCellModell *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block {
    CDShop *insertingShop = [CDShop MR_createEntity];
    
    NSMutableSet *insertingProducts = [[NSMutableSet alloc]init];
    for(Products *prod in shop.products){
        CDProducts *newProd = [CDProducts MR_createEntity];
        newProd.descriptions = prod.descriptions;
        newProd.image = prod.image;
        newProd.is_liked = prod.is_liked;
        newProd.likedCount = 0;
        [insertingProducts addObject:newProd];
    }
    
    insertingShop.products = [NSSet setWithSet:insertingProducts];
    
    insertingShop.shopInfo = [CDShopInfo MR_createEntity];
    insertingShop.shopInfo.realName = [shop.SellersInfo.realName copy];
    insertingShop.shopInfo.country = @"";
    
    [insertingShop.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(error);
            }
        }
    }];
}

- (void)fetchCachedIntrosShopsWithWithCompletion:(void (^)(id obj, NSError *err))block {
    NSArray *shops = [[CDShop MR_findAll] mutableCopy];
    NSMutableArray *models = [[NSMutableArray alloc]init];
    
    if (shops == nil) {
        if (block) {
            NSError *err = [[NSError alloc]init];
            block(nil,err);
        }
    } else {
        for (CDShop *item in shops) {
            IntrosCellModel *model = [[IntrosCellModel alloc]init];
            
            model.SellersInfo = [[ShopInfoIntros alloc]init];
            model.SellersInfo.realName = item.shopInfo.realName;
            model.SellersInfo.country = item.shopInfo.country;
            
            NSSet *setproducts= item.products;
            
            model.products = [[NSMutableArray alloc]init];
            for (CDProducts *prod in setproducts) {
                ProductsIntros *insProd = [[ProductsIntros alloc]init];
                insProd.descriptions = prod.descriptions;
                insProd.prodImage = prod.image;
                insProd.is_liked = prod.is_liked;
                insProd.LikedCount = prod.likedCount;
                [model.products addObject:insProd];
            }
            [models addObject:model];
        }
        if (block) {
            block(models,nil);
        }
    }
}

- (void)placeIntrosShop:(IntrosCellModel *)shop toCacheWithWithCompletion:(void (^)(NSError *err))block {
    CDShop *insertingShop = [CDShop MR_createEntity];
    
    NSMutableSet *insertingProducts = [[NSMutableSet alloc]init];
    for(ProductsIntros *prod in shop.products){
        CDProducts *newProd = [CDProducts MR_createEntity];
        newProd.descriptions = prod.descriptions;
        newProd.image = prod.prodImage;
        newProd.is_liked = prod.is_liked;
        newProd.likedCount = prod.LikedCount;
        [insertingProducts addObject:newProd];
    }
    
    insertingShop.products = [NSSet setWithSet:insertingProducts];
    
    insertingShop.shopInfo = [CDShopInfo MR_createEntity];
    insertingShop.shopInfo.realName = shop.SellersInfo.realName;
    insertingShop.shopInfo.country = shop.SellersInfo.country;
    
    [insertingShop.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(error);
            }
        }
    }];
}

@end
