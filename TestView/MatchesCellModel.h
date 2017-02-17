//
//  MatchesCellModel.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/15/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchesCellModel : NSObject

@property (strong, nonatomic) NSString *urlPhoto;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *massageText;
@property (strong, nonatomic) NSString *dateMassage;
@property (nonatomic) NSInteger countMassage;

@end
