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

NSInteger const kSAStartingOffset = 0;
NSInteger const kSAStepOffset = 20;

@interface SinglesCollectionViewController ()

@property   (nonatomic, strong) NSMutableArray *shops;
@property   (nonatomic) NSInteger curentOffset;

@end

@implementation SinglesCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.shops.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
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

    [cell setCellWithModel: [[[self.shops objectAtIndex:indexPath.section] products] objectAtIndex:indexPath.row ] ];
    
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
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *text1 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] realName];
    CGFloat height1 = [UILabel heightForText:text1 withViewWidth:self.view.frame.size.width/2 textFont:[UIFont fontWithName:@"Avenir Heavy" size:12]];
    
    NSString *text2 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] descriptions];
    CGFloat height2 = [UILabel heightForText:text2 withViewWidth:self.view.frame.size.width/2 textFont:[UIFont fontWithName:@"Avenir Medium" size:13]];
    
    CGFloat height = self.view.frame.size.width/2 + height1*2 + height2*1.2 ;

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

