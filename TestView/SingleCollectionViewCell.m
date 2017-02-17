//
//  SingleCollectionViewCell.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "SingleCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>

@interface SingleCollectionViewCell()

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *touchedPhotoImage;
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) IBOutlet UILabel *askLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *picFrameView;

@end

@implementation SingleCollectionViewCell

#pragma mark - Setting

- (void)setCellWithModel:(Products *)model {
    [self addAttributeToLabels];
    [self addGestureRecognizer];
    self.nameLabel.text = model.realName;
    self.askLabel.text = model.descriptions;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.image]
                 placeholderImage:nil];
    if (model.is_liked) {
        [self.likeButton setImage:[UIImage imageNamed:@"FullLike.png"] forState:UIControlStateNormal];
    }
}

-(void)addAttributeToLabels{
    NSAttributedString *nameAttributedString = [[NSAttributedString alloc] initWithString:self.nameLabel.text
                                                                               attributes:@{
                                                                                            NSKernAttributeName : @(2.0f)
                                                                                            }];
    self.nameLabel.attributedText = nameAttributedString;
    
    NSAttributedString *askAttributedString = [[NSAttributedString alloc] initWithString:self.askLabel.text
                                                                              attributes:@{
                                                                                           NSKernAttributeName : @(1.2f)
                                                                                           }];
    self.askLabel.attributedText = askAttributedString;
}

-(void)addGestureRecognizer{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(photoImageTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.touchedPhotoImage.userInteractionEnabled = YES;
    [self.touchedPhotoImage addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(nameLabelTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tapRecognizer2];
    
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(askLabelTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    self.askLabel.userInteractionEnabled = YES;
    [self.askLabel addGestureRecognizer:tapRecognizer3];
}

#pragma mark - Action

- (IBAction)likeProfile:(id)sender {
    [self.likeButton setImage:[UIImage imageNamed:@"FullLike.png"] forState:UIControlStateNormal];
}

-(void)photoImageTouched:(id) sender
{
    return;
}

-(void)nameLabelTouched:(id) sender
{
    return;
}

-(void)askLabelTouched:(id) sender
{
    return;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
