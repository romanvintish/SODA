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
    CGFloat labelsWidth = self.view.frame.size.width*0.5294;
    
    NSString *text2 = [[[[self.shops objectAtIndex:indexPath.section] products] objectAtIndex:indexPath.row] descriptions];
    CGFloat height2 = [UILabel heightForText:text2 withViewWidth:labelsWidth textFont:[UIFont fontWithName:@"Avenir Heavy" size:12]];

    
    CGFloat height = self.view.frame.size.width/25 + 5 + 20 + 5 + height2 + 5 + 20 + self.view.frame.size.width/25;
    
    return height;
}

@end
