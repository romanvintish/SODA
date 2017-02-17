  //
//  IntrosTableViewCell.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "IntrosTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>

@interface IntrosTableViewCell()

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *touchedUserPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *friendPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *touchedFriendPhoto;
@property (strong, nonatomic) IBOutlet UILabel *countMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTextLabel;

@end

@implementation IntrosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - Setting

- (void)setCellWithModel:(IntrosCellModel *)model {
    [self addAttributeToLabels];
    [self addGestureRecognizer];
    
    NSInteger likecount = [[model.products lastObject] LikedCount];
    self.countMessageLabel.text = [NSString stringWithFormat:@"%d", likecount] ;
    self.friendNameLabel.text = [[model.products lastObject] descriptions];
    self.messageTextLabel.text = model.SellersInfo.country;
    self.userNameLabel.text = model.SellersInfo.realName;
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString: model.shopPicture] placeholderImage:nil];
    [self.friendPhoto sd_setImageWithURL:[NSURL URLWithString: [[model.products lastObject] prodImage]] placeholderImage:nil];
    
    if (model.followed > 0) {
        [self.likeButton setImage:[UIImage imageNamed:@"FullLike.png"] forState:UIControlStateNormal];
    }
}

-(void)addAttributeToLabels{
    NSAttributedString *nameAttributedString = [[NSAttributedString alloc] initWithString:self.userNameLabel.text
                                                                               attributes:@{
                                                                                            NSKernAttributeName : @(2.0f)
                                                                                            }];
    self.userNameLabel.attributedText = nameAttributedString;
    
    NSAttributedString *askAttributedString = [[NSAttributedString alloc] initWithString:self.friendNameLabel.text
                                                                              attributes:@{
                                                                                           NSKernAttributeName : @(2.0f)
                                                                                           }];
    self.friendNameLabel.attributedText = askAttributedString;
}

-(void)addGestureRecognizer{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(userPhotoTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    //[tapRecognizer setDelegate:self];
    self.touchedUserPhoto.userInteractionEnabled = YES;
    [self.touchedUserPhoto addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(friendPhotoTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    //[tapRecognizer setDelegate:self];
    self.touchedFriendPhoto.userInteractionEnabled = YES;
    [self.touchedFriendPhoto addGestureRecognizer:tapRecognizer2];
    
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(userNameLabelTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    //[tapRecognizer setDelegate:self];
    self.userNameLabel.userInteractionEnabled = YES;
    [self.userNameLabel addGestureRecognizer:tapRecognizer3];
    
    UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(friendNameLabelTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    //[tapRecognizer setDelegate:self];
    self.friendNameLabel.userInteractionEnabled = YES;
    [self.friendNameLabel addGestureRecognizer:tapRecognizer4];
    
    UITapGestureRecognizer *tapRecognizer5 = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(messageTextLabelTouched:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    //[tapRecognizer setDelegate:self];
    self.messageTextLabel.userInteractionEnabled = YES;
    [self.messageTextLabel addGestureRecognizer:tapRecognizer5];
}

#pragma mark - Action

-(void)userPhotoTouched:(id) sender
{
    return;
}

-(void)friendPhotoTouched:(id) sender
{
    return;
}

-(void)userNameLabelTouched:(id) sender
{
    return;
}

-(void)friendNameLabelTouched:(id) sender
{
    return;
}

-(void)messageTextLabelTouched:(id) sender
{
    return;
}

- (IBAction)likeProfile:(id)sender {
    [self.likeButton setImage:[UIImage imageNamed:@"FullLike.png"] forState:UIControlStateNormal];
}

@end
