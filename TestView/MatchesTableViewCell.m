//
//  MatchesTableViewCell.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "MatchesTableViewCell.h"

@interface MatchesTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *touchUserPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *cancelButton;
@property (strong, nonatomic) IBOutlet UIImageView *checkButton;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *matchRequestLabel;
@property (strong, nonatomic) IBOutlet UILabel *massageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *countMessageLabel;

@end

@implementation MatchesTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - Setting


- (void)setCellWithModel:(MatchesCellModel *)model
{
    [self addAttributeToLabels];
    [self addGestureRecognizer];
}

-(void)addAttributeToLabels
{
    NSAttributedString *nameAttributedString = [[NSAttributedString alloc] initWithString:self.userNameLabel.text
                                                                               attributes:@{
                                                                                            NSKernAttributeName : @(2.0f)
                                                                                            }];
    self.userNameLabel.attributedText = nameAttributedString;
}

-(void)addGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(userPhotoTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.touchUserPhoto.userInteractionEnabled = YES;
    [self.touchUserPhoto addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(cancelButtonTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.cancelButton.userInteractionEnabled = YES;
    [self.cancelButton addGestureRecognizer:tapRecognizer2];
    
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(checkButtonTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.checkButton.userInteractionEnabled = YES;
    [self.checkButton addGestureRecognizer:tapRecognizer3];
    
    UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(userNameLabelTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.userNameLabel.userInteractionEnabled = YES;
    [self.userNameLabel addGestureRecognizer:tapRecognizer4];
    
    UITapGestureRecognizer *tapRecognizer5 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(messageLabelTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.massageLabel.userInteractionEnabled = YES;
    [self.massageLabel addGestureRecognizer:tapRecognizer5];
}


#pragma mark - Action


-(void)userPhotoTouched:(id) sender
{
    return;
}

-(void)cancelButtonTouched:(id) sender
{
    return;
}

-(void)checkButtonTouched:(id) sender
{
    return;
}

-(void)userNameLabelTouched:(id) sender
{
    return;
}

-(void)messageLabelTouched:(id) sender
{
    return;
}

@end
