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

@property (nonatomic, strong, nonnull) NSString *latitude;
@property (nonatomic, strong, nonnull) NSString *longitude;
@property (nonatomic, strong, nonnull) NSString *username;
@property (nonatomic, strong, nonnull) NSString *image;
@property (nonatomic, strong, nonnull) UIImageView *imageView;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, weak , nullable) NSString *title;

@property (nonatomic, weak) id<ShopOnMapModellDelegate> delegate;

-(MKAnnotationView*)annotationView;

@end
