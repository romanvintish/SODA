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

@interface PeoplesViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIView *pageView;
@property (strong, nonatomic) IBOutlet UIView *scrollItem;
@property (strong, nonatomic) IBOutlet UIButton *singleButton;
@property (strong, nonatomic) IBOutlet UIButton *introsButton;
@property (strong, nonatomic) IBOutlet UIButton *matchesButton;
@property (strong, nonatomic) NSMutableArray *myViewControllers;
@property NSInteger curentPageIndex;

@end

@implementation PeoplesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SinglesCollectionViewController *singles = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglesCollectionViewController"];
    IntrosTableViewController *intros = [self.storyboard instantiateViewControllerWithIdentifier:@"IntrosTableViewController"];
    MatchesTableViewController  *matches = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchesTableViewController"];
    
    self.myViewControllers = @[singles,intros,matches];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)singlesTaped:(id)sender
{
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

- (IBAction)introsTaped:(id)sender
{
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

- (IBAction)matchesTaped:(id)sender
{
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

-(void)animateScrollingItem:(NSInteger)index
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    
    switch (index) {
        case 0:{
            [self.scrollItem setFrame:CGRectMake(self.singleButton.frame.origin.x + (self.singleButton.frame.size.width - self.scrollItem.frame.size.width)/2,
                                                 self.scrollItem.frame.origin.y,
                                                 self.scrollItem.frame.size.width,
                                                 self.scrollItem.frame.size.height)];
            break;
        }
            
        case 1:{
            [self.scrollItem setFrame:CGRectMake(self.introsButton.frame.origin.x + (self.introsButton.frame.size.width - self.scrollItem.frame.size.width)/2,
                                                 self.scrollItem.frame.origin.y,
                                                 self.scrollItem.frame.size.width,
                                                 self.scrollItem.frame.size.height)];
            break;
        }
            
        case 2:{
            [self.scrollItem setFrame:CGRectMake(self.matchesButton.frame.origin.x + (self.matchesButton.frame.size.width - self.scrollItem.frame.size.width)/2,
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ((self.curentPageIndex == 0) || (self.curentPageIndex == NSNotFound)) {
        return nil;
    }
    
    return [self.myViewControllers objectAtIndex:self.curentPageIndex -1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.curentPageIndex == NSNotFound) {
        return nil;
    }
    
    if (self.curentPageIndex + 1 == [self.myViewControllers count]) {
        return nil;
    }
    
    return [self.myViewControllers objectAtIndex:self.curentPageIndex + 1];
}

#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.curentPageIndex = [self.myViewControllers indexOfObject:[pageViewController.viewControllers lastObject]];
    [self animateScrollingItem: self.curentPageIndex];
}

@end
