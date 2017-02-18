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

NSInteger const kSAStartingOffsetIntros = 0;
NSInteger const kSAStepOffsetIntros = 20;

@interface IntrosTableViewController ()

@property   (nonatomic, strong) NSMutableArray *shops;
@property   (nonatomic) NSInteger curentOffset;

@end

@implementation IntrosTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shops = [[NSMutableArray alloc] init];
    
    [[SADataManager sharedManager] downloadShopCollectionsForIntrosWithStart:kSAStartingOffsetIntros withEnd:kSAStepOffsetIntros WithCompletion:^(id obj, NSError *err) {
            self.shops = obj;
            [self.tableView reloadData];
            self.curentOffset += kSAStepOffsetIntros;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntrosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introsCell" forIndexPath:indexPath];

    [cell setCellWithModel: [self.shops objectAtIndex:indexPath.section]];
    
    if (indexPath.section >= self.shops.count - 1) {
        [[SADataManager sharedManager] downloadShopCollectionsForIntrosWithStart:self.curentOffset withEnd:self.curentOffset + kSAStepOffsetIntros WithCompletion:^(id obj, NSError *err) {
            for (id item in obj) {
                [self.shops addObject:item];
            }
            [self.tableView reloadData];
            self.curentOffset += kSAStepOffsetIntros;
        }];
    }
    return cell;
}


#pragma mark <Table View delegate>


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text1 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] realName];
    CGFloat height1 = [UILabel heightForText:text1 withViewWidth:self.view.frame.size.width textFont:[UIFont fontWithName:@"Avenir Heavy" size:12]];
    
    NSString *text2 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] descriptions];
    CGFloat height2 = [UILabel heightForText:text2 withViewWidth:self.view.frame.size.width textFont:[UIFont fontWithName:@"Avenir Heavy" size:13]];
    
    NSString *text3 = [[[self.shops objectAtIndex:indexPath.section] SellersInfo] country];
    CGFloat height3 = [UILabel heightForText:text3 withViewWidth:self.view.frame.size.width textFont:[UIFont fontWithName:@"Avenir Heavy" size:13]];
    
    CGFloat height = self.view.frame.size.width/25 + height1*2 + 5 + height3*2 + 5 +height2*1.2 + self.view.frame.size.width/25;
    
    return height;
}

@end
