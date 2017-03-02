//
//  PeoplesViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/10/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "PeoplesViewController.h"

#import "SinglesCollectionViewController.h"
#import "IntrosTableViewController.h"
#import "MatchesTableViewController.h"
#import "SearchPopupViewController.h"

#define X_FOR_SCROLL(button,scrolitem) button.frame.origin.x + (button.frame.size.width - scrolitem.frame.size.width)/2

NSString *const kSinglesCollectionViewIdentifier = @"SinglesCollectionViewController";

NSString *const kIntrosTableViewIdentifier = @"IntrosTableViewController";
NSString *const kMatchesTableViewIdentifier = @"MatchesTableViewController";
NSString *const kPageViewControllerIdentifier = @"PageViewController";
NSString *const kSearchControllerIdentifier = @"SearchController";

@interface PeoplesViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIView *scrollItem;
@property (weak, nonatomic) IBOutlet UIButton *singleButton;
@property (weak, nonatomic) IBOutlet UIButton *introsButton;
@property (weak, nonatomic) IBOutlet UIButton *matchesButton;
@property (strong, nonatomic) NSMutableArray *myViewControllers;
@property NSInteger curentPageIndex;

@end

@implementation PeoplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SinglesCollectionViewController *singles = [self.storyboard instantiateViewControllerWithIdentifier:kSinglesCollectionViewIdentifier];
    IntrosTableViewController *intros = [self.storyboard instantiateViewControllerWithIdentifier:kIntrosTableViewIdentifier];
    MatchesTableViewController  *matches = [self.storyboard instantiateViewControllerWithIdentifier:kMatchesTableViewIdentifier];
    
    self.myViewControllers = [@[singles,intros,matches]mutableCopy];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:kPageViewControllerIdentifier];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.curentPageIndex = 0;
    SinglesCollectionViewController *startingViewController = [self.myViewControllers objectAtIndex:0];
    [self.pageViewController setViewControllers:@[startingViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.pageView.frame.size.width, self.pageView.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.pageView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startSearching)
                                                 name:kPushNotificationTapedNotificationName
                                               object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)logoButtonTaped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoButtonTapedNotificationName object:self];
}

- (IBAction)singlesTaped:(id)sender {
    NSInteger index = 0;
    [self animateScrollingItem:index];
    SinglesCollectionViewController *contentViewController = [self.myViewControllers objectAtIndex:index];
    
    UIPageViewControllerNavigationDirection direction;
    
    if (self.curentPageIndex > 0) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else{
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    self.curentPageIndex = index;
    [self.pageViewController setViewControllers:@[contentViewController]
                                      direction:direction
                                       animated:YES
                                     completion:nil];
}

- (IBAction)searchButtonTaped:(id)sender {
    [self startSearching];
}

- (void)startSearching {
    static BOOL isFirstTap = YES;
    SearchPopupViewController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:kSearchControllerIdentifier];
    searchController.delegate = [self.myViewControllers objectAtIndex:0];
    searchController.shopDelegate = [self.myViewControllers objectAtIndex:1];
    searchController.providesPresentationContextTransitionStyle = YES;
    searchController.definesPresentationContext = YES;
    [searchController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [searchController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    if (!isFirstTap) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSearchButtonSecondTapedNotificationName object:self];
    }
    if (isFirstTap) {
        isFirstTap =NO;
    }
    [self.navigationController presentViewController:searchController animated:YES completion:nil];
}

- (IBAction)introsTaped:(id)sender {
    NSInteger index = 1;
    [self animateScrollingItem:index];
    IntrosTableViewController *contentViewController = [self.myViewControllers objectAtIndex:index];

    UIPageViewControllerNavigationDirection direction;
    
    if (self.curentPageIndex > 1) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else{
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    self.curentPageIndex = index;
    [self.pageViewController setViewControllers:@[contentViewController]
                                      direction:direction
                                       animated:YES
                                     completion:nil];
}

- (IBAction)matchesTaped:(id)sender {
    NSInteger index = 2;
    [self animateScrollingItem:index];
    MatchesTableViewController *contentViewController = [self.myViewControllers objectAtIndex:index];

    UIPageViewControllerNavigationDirection direction;
    
    if (self.curentPageIndex > 2) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else{
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    self.curentPageIndex = index;
    [self.pageViewController setViewControllers:@[contentViewController]
                                      direction:direction
                                       animated:YES
                                     completion:nil];
}

-(void)animateScrollingItem:(NSInteger)index {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    
    switch (index) {
        case 0:{
            [self.scrollItem setFrame:CGRectMake(X_FOR_SCROLL(self.singleButton,self.scrollItem),
                                                 self.scrollItem.frame.origin.y,
                                                 self.scrollItem.frame.size.width,
                                                 self.scrollItem.frame.size.height)];
            break;
        }
            
        case 1:{
            [self.scrollItem setFrame:CGRectMake(X_FOR_SCROLL(self.introsButton,self.scrollItem),
                                                 self.scrollItem.frame.origin.y,
                                                 self.scrollItem.frame.size.width,
                                                 self.scrollItem.frame.size.height)];
            break;
        }
            
        case 2:{
            [self.scrollItem setFrame:CGRectMake(X_FOR_SCROLL(self.matchesButton,self.scrollItem),
                                                 self.scrollItem.frame.origin.y,
                                                 self.scrollItem.frame.size.width,
                                                 self.scrollItem.frame.size.height)];
            break;
        }
            
        default:
            break;
    }
    
    [UIView commitAnimations];
}


#pragma mark - Page View Controller Data Source


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ((self.curentPageIndex == 0) || (self.curentPageIndex == NSNotFound)) {
        return nil;
    }
    
    return [self.myViewControllers objectAtIndex:self.curentPageIndex -1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (self.curentPageIndex == NSNotFound) {
        return nil;
    }
    
    if (self.curentPageIndex + 1 == [self.myViewControllers count]) {
        return nil;
    }
    
    return [self.myViewControllers objectAtIndex:self.curentPageIndex + 1];
}


#pragma mark - Page View Controller Delegate


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.curentPageIndex = [self.myViewControllers indexOfObject:[pageViewController.viewControllers lastObject]];
    [self animateScrollingItem: self.curentPageIndex];
}

@end
