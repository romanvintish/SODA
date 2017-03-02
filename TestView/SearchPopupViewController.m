//
//  SearchPopupViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/24/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SearchPopupViewController.h"
#import "SADataManager.h"

NSString *const kMinId = @"0";
NSString *const kMaxId = @"30";

@interface SearchPopupViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSString *selectedCategory;

@end

@implementation SearchPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedCategory = @"0";
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.blurView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.blurView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.blurView addSubview:blurEffectView];
    }
    
    [[SADataManager sharedManager] getPassion:^(id obj, NSError *err) {
        if (!err) {
            self.categories = obj;
            [self.pickerView reloadAllComponents];
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    
    [self.blurView addGestureRecognizer:tap];
}

-(void)dismissView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.categories != nil) {
        return self.categories.count;
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.categories != nil) {
    return [[self.categories objectAtIndex:row] valueForKey:@"passionTitle"];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCategory = [[[self.categories objectAtIndex:row] valueForKey:@"sortParam"] stringValue] ;
}

- (IBAction)doneButtonTaped:(id)sender {
    [[SADataManager sharedManager] searchInTheCategory:self.selectedCategory
                                             withMinId:kMinId
                                              andMaxId:kMaxId
                                       complitionBlock:^(id searchedObj) {
                                           if ([self.delegate respondsToSelector:@selector(controllerReturnData:)]) {
                                               [self.delegate controllerReturnData:searchedObj];
                                           }
                                           if ([self.delegate respondsToSelector:@selector(controllerReturnCategory:)]) {
                                               [self.delegate controllerReturnCategory:self.selectedCategory];
                                           }
                                           [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                       }
                                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    [[SADataManager sharedManager] searchShopsInTheCategory:self.selectedCategory
                                             withMinId:kMinId
                                              andMaxId:kMaxId
                                       complitionBlock:^(id searchedObj) {
                                           if ([self.shopDelegate respondsToSelector:@selector(controllerReturnData:)]) {
                                               [self.shopDelegate controllerReturnData:searchedObj];
                                           }
                                           if ([self.shopDelegate respondsToSelector:@selector(controllerReturnCategory:)]) {
                                               [self.shopDelegate controllerReturnCategory:self.selectedCategory];
                                           }
                                       }
                                               failure:nil];
}

@end
