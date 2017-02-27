//
//  IntrosTableViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/13/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "IntrosTableViewController.h"
#import "IntrosTableViewCell.h"
#import "IntrosCellModel.h"
#import "SADataManager.h"
#import "UILabel+UILabel___Height.h"
#import "SearchPopupViewController.h"
#import "SearchedShops.h"

NSInteger const kSAStartingOffsetIntros = 0;
NSInteger const kSAStepOffsetIntros = 20;

@interface IntrosTableViewController ()<SearchViewControllerDelegate>

@property   (nonatomic, strong) NSMutableArray *shops;
@property   (nonatomic) NSInteger curentOffset;

@property   (nonatomic, strong) NSMutableArray *searchedProducts;
@property   (nonatomic, strong) NSString *searchedCategory;
@property   (nonatomic) NSInteger curentOffsetForSearch;
@end

@implementation IntrosTableViewController

- (void)controllerReturnData:(id)data{
    NSLog(@"%@",data);
    self.searchedProducts = [[NSMutableArray alloc] init];
    for (int i = 0; i< [data count] ; i++) {
        id item = [data objectAtIndex:i];
        [self.searchedProducts addObject:item];
    }
    self.curentOffsetForSearch = self.searchedProducts.count;
    [self.tableView reloadData];
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
    
    [[SADataManager sharedManager] downloadShopCollectionsForIntrosWithStart:kSAStartingOffsetIntros withEnd:kSAStepOffsetIntros WithCompletion:^(id obj, NSError *err) {
            self.shops = obj;
            [self.tableView reloadData];
            self.curentOffset += kSAStepOffsetIntros;
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)searchSecondTaped{
    self.searchedProducts = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchedProducts) {
        return self.searchedProducts.count;
    }
    return self.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntrosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introsCell" forIndexPath:indexPath];

    if (self.searchedProducts) {
        IntrosCellModel* model = [[IntrosCellModel alloc] init];
        SearchedShops *product = [self.searchedProducts objectAtIndex:indexPath.section];
        model.shopPicture = [product image];
        model.SellersInfo = [[ShopInfoIntros alloc] init];
        model.SellersInfo.realName = [product username];
        model.products = [[NSMutableArray alloc] init];
        ProductsIntros *intros = [[ProductsIntros alloc]init];
        intros.descriptions = product.descriptions;
        [model.products addObject:intros];
        [cell setCellWithModel:model];
    } else {
    [cell setCellWithModel: [self.shops objectAtIndex:indexPath.section]];
    }
    
    if (self.searchedProducts) {
        if (indexPath.section >= self.curentOffsetForSearch - 1) {
            [[SADataManager sharedManager] searchShopsInTheCategory:self.searchedCategory
                                                     withMinId:[NSString stringWithFormat:@"%d",self.curentOffsetForSearch]
                                                      andMaxId:[NSString stringWithFormat:@"%d",self.curentOffsetForSearch+kSAStepOffsetIntros]
                                               complitionBlock:^(id data) {
                                                   if ([data count]>0) {
                                                       for (int i = 0; i< [data count] ; i++) {
                                                           id item = [data objectAtIndex:i];
                                                           [self.searchedProducts addObject:item];
                                                       }
                                                       [self.tableView reloadData];
                                                       self.curentOffsetForSearch += kSAStepOffsetIntros;
                                                   }
                                               } failure:nil];
        }
    } else{
    if (indexPath.section >= self.shops.count - 1) {
        [[SADataManager sharedManager] downloadShopCollectionsForIntrosWithStart:self.curentOffset withEnd:self.curentOffset + kSAStepOffsetIntros WithCompletion:^(id obj, NSError *err) {
            for (id item in obj) {
                [self.shops addObject:item];
            }
            [self.tableView reloadData];
            self.curentOffset += kSAStepOffsetIntros;
        }];
     }
    }
    return cell;
}


#pragma mark <Table View delegate>


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat labelsWidth = self.view.frame.size.width*0.5294;
    
    NSString *text2;
    if (self.searchedProducts) {
        text2 = [[self.searchedProducts objectAtIndex:indexPath.row] descriptions];
    } else {
        text2 = [[[[self.shops objectAtIndex:indexPath.section] products] objectAtIndex:indexPath.row] descriptions];
    }
    
    CGFloat height2 = [UILabel heightForText:text2 withViewWidth:labelsWidth textFont:[UIFont fontWithName:@"Avenir Heavy" size:12]];

    CGFloat height = self.view.frame.size.width/25 + 5 + 20 + 5 + height2 + 5 + 20 + self.view.frame.size.width/25;
    
    return height;
}

@end
