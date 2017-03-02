//
//  SlideMenuViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/23/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SlideMenuViewController.h"

NSString *const kFirstSegueName = @"firstRow";
NSString *const kSecondSegueName = @"secondRow";
NSString *const kThirdSegueName = @"thirdRow";

@interface SlideMenuViewController ()

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openLeftMenu)
                                                 name:kLogoButtonTapedNotificationName
                                               object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Burger menu

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    NSString *identifier ;
    switch (indexPath.row) {
        case 0:
            identifier = kFirstSegueName;
            break;
        case 1:
            identifier = kSecondSegueName;
            break;
        case 2:
            identifier = kThirdSegueName;
            break;
    }
    
    return identifier;
}

- (UIViewAnimationOptions) openAnimationCurve {
    return UIViewAnimationOptionCurveEaseInOut;
}

- (UIViewAnimationOptions) closeAnimationCurve {
    return UIViewAnimationOptionCurveEaseInOut;
}

- (BOOL)deepnessForLeftMenu
{
    return YES;
}

@end
