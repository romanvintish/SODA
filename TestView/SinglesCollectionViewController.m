//
//  SinglesCollectionViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/13/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SinglesCollectionViewController.h"
#import "SingleCollectionViewCell.h"
#import "SADataManager.h"
#import "SingleCollectionReusableView.h"
#import "UILabel+UILabel___Height.h"
#import "SearchPopupViewController.h"

NSInteger const kSAStartingOffset = 0;
NSInteger const kSAStepOffset = 20;

@interface SinglesCollectionViewController ()<SearchViewControllerDelegate>

@property   (nonatomic, strong) NSMutableArray *shops;
@property   (nonatomic) NSInteger curentOffset;

@property   (nonatomic, strong) NSMutableArray *searchedProducts;
@property   (nonatomic, strong) NSString *searchedCategory;
@property   (nonatomic) NSInteger curentOffsetForSearch;

@end

@implementation SinglesCollectionViewController

- (void)controllerReturnData:(id)data{
    NSLog(@"%@",data);
    self.searchedProducts = [[NSMutableArray alloc] init];
    for (int i = 0; i< [data count] ; i++) {
        Products *prod = [[Products alloc] init];
        if ([[data objectAtIndex:i] descriptions] != nil) {
            [prod setDescriptions:[[data objectAtIndex:i] descriptions]];
        } else {
            [prod setDescriptions:@""];
        }
        if ([[data objectAtIndex:i] image] != nil) {
            [prod setImage:[[data objectAtIndex:i] image]];
        } else {
            [prod setImage:@""];
        }
        if ([[data objectAtIndex:i] is_liked] != nil) {
            [prod setIs_liked:[[data objectAtIndex:i] is_liked]];
        } else {
            [prod setIs_liked:NO];
        }
        [prod setRealName:@""];
        [self.searchedProducts addObject:prod];
    }
    self.curentOffsetForSearch = self.searchedProducts.count;
    [self.collectionView reloadData];
}

- (void)controllerReturnCategory:(NSString *)category{
    self.searchedCategory = category;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchSecondTaped)
                                                 name:@"searchButtonSecondTaped"
                                               object:nil];
    
    self.shops = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[SADataManager sharedManager] downloadShopCollectionsWithStart:kSAStartingOffset withEnd:kSAStepOffset WithCompletion:^(id obj, NSError *err) {
        for (id item in obj) {
            SingleCellModell *model = item;
            [self.shops addObject:model];
        }
        
        [self.collectionView reloadData];
        self.curentOffset += kSAStepOffset;
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)searchSecondTaped{
    self.searchedProducts = nil;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.searchedProducts) {
        return 1;
    }
    return self.shops.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.searchedProducts) {
        return self.searchedProducts.count;
    }
    return [[[self.shops objectAtIndex:section] products] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     SingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SinglesCollectionViewCell" forIndexPath:indexPath];
    
    if(fmodf(indexPath.row, 2) != 0){
        [cell.rightBottomSeparator removeFromSuperview];
    }
    else{
        [cell.leftBottomSeparator removeFromSuperview];
    }

    if (self.searchedProducts) {
        [cell setCellWithModel: [self.searchedProducts objectAtIndex:indexPath.row ]];
    } else {
        [cell setCellWithModel: [[[self.shops objectAtIndex:indexPath.section] products] objectAtIndex:indexPath.row ] ];}
    
    if (self.searchedProducts) {
        if (indexPath.row >= self.searchedProducts.count - 1) {
            [[SADataManager sharedManager] searchInTheCategory:self.searchedCategory
                                                     withMinId:[NSString stringWithFormat:@"%d",self.curentOffsetForSearch]
                                                      andMaxId:[NSString stringWithFormat:@"%d",self.curentOffsetForSearch+kSAStepOffset]
                                               complitionBlock:^(id data) {
                                                   for (int i = 0; i< [data count] ; i++) {
                                                       Products *prod = [[Products alloc] init];
                                                       if ([[data objectAtIndex:i] descriptions] != nil) {
                                                           [prod setDescriptions:[[data objectAtIndex:i] descriptions]];
                                                       } else {
                                                           [prod setDescriptions:@""];
                                                       }
                                                       if ([[data objectAtIndex:i] image] != nil) {
                                                           [prod setImage:[[data objectAtIndex:i] image]];
                                                       } else {
                                                           [prod setImage:@""];
                                                       }
                                                       if ([[data objectAtIndex:i] is_liked] != nil) {
                                                           [prod setIs_liked:[[data objectAtIndex:i] is_liked]];
                                                       } else {
                                                           [prod setIs_liked:NO];
                                                       }
                                                       [prod setRealName:@""];
                                                       [self.searchedProducts addObject:prod];
                                                   }
                                                   [self.collectionView reloadData];
                                                   self.curentOffsetForSearch += kSAStepOffset;
                                               } failure:nil];
        }
    } else{
     if (indexPath.section >= self.shops.count - 1) {
         [[SADataManager sharedManager] downloadShopCollectionsWithStart:self.curentOffset withEnd:self.curentOffset + kSAStepOffset WithCompletion:^(id obj, NSError *err) {
             for (id item in obj) {
                 SingleCellModell *model = item;
                 [self.shops addObject:model];
             }
             
             [self.collectionView reloadData];
             self.curentOffset += kSAStepOffset;
     }];
     }
    }
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *text1;
    if (self.searchedProducts) {
        text1 = [[self.searchedProducts objectAtIndex:indexPath.row] realName];
    } else {
        text1 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] realName];
    }
    
    CGFloat height1 = [UILabel heightForText:text1 withViewWidth:self.view.frame.size.width/2 textFont:[UIFont fontWithName:@"Avenir Heavy" size:12]];
    
    NSString *text2;
    if (self.searchedProducts) {
        text2 = [[self.searchedProducts objectAtIndex:indexPath.row] descriptions];
    } else {
        text2 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] descriptions];
    }

    CGFloat height2 = [UILabel heightForText:text2 withViewWidth:self.view.frame.size.width/2 textFont:[UIFont fontWithName:@"Avenir Medium" size:13]];
    
    CGFloat height = self.view.frame.size.width/2 + height1 + height2 ;

    return CGSizeMake(self.view.frame.size.width/2, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        SingleCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.shopNameLabel.text = [[[self.shops objectAtIndex:indexPath.section] SellersInfo] realName];
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableview = footerview;
    }
    
    return reusableview;
}

@end

