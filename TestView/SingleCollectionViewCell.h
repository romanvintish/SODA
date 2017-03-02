//
//  SingleCollectionViewCell.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/14/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleCellModell.h"

@interface SingleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *rightBottomSeparator;
@property (weak, nonatomic) IBOutlet UIView *leftBottomSeparator;

- (void)setCellWithModel:(Products *)model;

@end
