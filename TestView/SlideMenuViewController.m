//
//  SlideMenuViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/23/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SlideMenuViewController.h"

@interface SlideMenuViewController ()

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openLeftMenu)
                                                 name:@"logoButtonTaped"
                                               object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Burger menu

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier ;
    switch (indexPath.row) {
        case 0:
            identifier = @"firstRow";
            break;
        case 1:
            identifier = @"secondRow";
            break;
        case 2:
            identifier = @"thirdRow";
            break;
    }
    
    return identifier;
}

- (UIViewAnimationOptions) openAnimationCurve {
    return UIViewAnimationOptionCurveEaseOut;
}

- (UIViewAnimationOptions) closeAnimationCurve {
    return UIViewAnimationOptionCurveEaseOut;
}

@end
