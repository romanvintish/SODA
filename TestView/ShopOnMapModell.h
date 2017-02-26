//
//  ShopOnMapModell.h
//  TestView
//
//  Created by VINTISH ROMAN on 2/23/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyMapping.h>
#import <MapKit/MapKit.h>

@protocol ShopOnMapModellDelegate <NSObject>

-(void)setTrackWithEndPoint:(CLLocationCoordinate2D)endPointCoordinate;

@end

@interface ShopOnMapModell : NSObject <EKMappingProtocol, MKAnnotation>

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, weak) id<ShopOnMapModellDelegate> delegate;

-(MKAnnotationView*)annotationView;

@end
