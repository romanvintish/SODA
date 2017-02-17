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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shops = [[NSMutableArray alloc] init];
    [[SADataManager sharedManager] downloadShopCollectionsForIntrosWithStart:kSAStartingOffsetIntros withEnd:kSAStepOffsetIntros WithCompletion:^(id obj, NSError *err) {
            self.shops = obj;
        [self.tableView reloadData];
        self.curentOffset += kSAStepOffsetIntros;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

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

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSString *text1 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] realName];
    CGFloat height1 = [UILabel heightForText:text1 withViewWidth:self.view.frame.size.width/2 textFont:[UIFont fontWithName:@"Avenir Heavy" size:12]];
    
    NSString *text2 = [[[[self.shops objectAtIndex:indexPath.section]products] objectAtIndex:indexPath.row] descriptions];
    CGFloat height2 = [UILabel heightForText:text2 withViewWidth:self.view.frame.size.width/2 textFont:[UIFont fontWithName:@"Avenir Medium" size:13]];
    
    CGFloat height = self.view.frame.size.width/2 + height1*2 + height2*1.2 ;
    
    return CGSizeMake(self.view.frame.size.width/2, height);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
