//
//  SearchPopupViewController.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/24/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>

- (void)controllerReturnData:(id)data;
- (void)controllerReturnCategory:(NSString *)category;

@end

@interface SearchPopupViewController : UIViewController

@property   (nonatomic, weak) id<SearchViewControllerDelegate> delegate;
@property   (nonatomic, weak) id<SearchViewControllerDelegate> shopDelegate;

@end
