//
//  IntrosTableViewCell.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntrosCellModel.h"

@interface IntrosTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTextLabel;

- (void)setCellWithModel:(IntrosCellModel *)model;

@end
