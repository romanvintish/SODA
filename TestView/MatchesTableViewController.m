//
//  MatchesTableViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/13/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "MatchesTableViewController.h"
#import "MatchesTableViewCell.h"

@interface MatchesTableViewController ()

@end

@implementation MatchesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchesCell2" forIndexPath:indexPath];
    [cell setCellWithModel:nil];
    return cell;
}

@end
