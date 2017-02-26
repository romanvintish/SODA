//
//  ShopOnMapModell.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/23/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "ShopOnMapModell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ShopOnMapModell

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"lat" : @"latitude",
                                               @"long" : @"longitude",
                                               @"username" : @"username",
                                               @"image" : @"image"
                                               }];
    }];
}

-(MKAnnotationView*)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc ] initWithAnnotation:self reuseIdentifier:@"ShopOnMapModell"];
    annotationView.enabled =YES;
    annotationView.canShowCallout = YES;
    
    self.imageView = [[UIImageView alloc] init];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.image] placeholderImage:[UIImage imageNamed:@"vertical-shop.png"]];

    annotationView.image = [UIImage imageNamed:@"vertical-shop.png"];
    [annotationView setFrame:CGRectMake(0, 0, 30, 30)];

    annotationView.rightCalloutAccessoryView = self.imageView;
    annotationView.rightCalloutAccessoryView.frame = CGRectMake(0, 0, 40, 40);

    
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    [goButton addTarget:self
                   action:@selector(infoButtonTaped:)
         forControlEvents:UIControlEventTouchUpInside];
    [goButton setFrame:CGRectMake(0, 0, 40, 40)];
    annotationView.leftCalloutAccessoryView = goButton ;

    return annotationView;
}

- (IBAction)infoButtonTaped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(setTrackWithEndPoint:)]) {
        [self.delegate setTrackWithEndPoint:self.coordinate];
    }
}

@end

