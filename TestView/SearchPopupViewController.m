//
//  SearchPopupViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/24/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SearchPopupViewController.h"
#import "SADataManager.h"

@interface SearchPopupViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation SearchPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SADataManager sharedManager] getPassion:^(id obj, NSError *err) {
        if (!err) {
            self.categories = obj;
            [self.pickerView reloadAllComponents];
        }
    } failure:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.categories != nil) {
        return self.categories.count;
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.categories != nil) {
    return [[self.categories objectAtIndex:row] valueForKey:@"passionTitle"];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

- (IBAction)doneButtonTaped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        UIView *lastView = self.presentingViewController.view.subviews[self.presentingViewController.view.subviews.count-1];
        lastView.removeFromSuperview;
    }];
}

@end
