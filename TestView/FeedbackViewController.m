//
//  FeedbackViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/9/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "FeedbackViewController.h"

float const kDurationAnimation = .3f;

@interface FeedbackViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIView *lastSpace;
@property (nonatomic) CGPoint contentOffset;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moveUp:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.textField resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    [self.scrollView setContentOffset:self.contentOffset];
    [UIView commitAnimations];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.textField becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (IBAction)touchTextField:(id)sender {
}

- (IBAction)add:(id)sender {
}

- (IBAction)send:(id)sender {
}

- (void)moveUp:(NSNotification*)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDurationAnimation];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat topOfKeyboard = keyboardFrame.size.height;
    CGFloat bottomOfLastSpace = (self.view.frame.size.height - self.lastSpace.frame.origin.y) - self.lastSpace.frame.size.height;
    self.contentOffset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.origin.x, topOfKeyboard-bottomOfLastSpace) animated:YES];

    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
