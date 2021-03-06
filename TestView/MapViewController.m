//
//  MapViewController.m
//  TestView
//
//  Created by VINTISH ROMAN on 2/23/17.
//  Copyright © 2017 Roman Vintish. All rights reserved.
//

#import "MapViewController.h"
#import "SADataManager.h"
#import "ShopOnMapModell.h"
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

CGFloat const kRadius = 20;
NSString *const kShopOnMapModellIdentifier = @"ShopOnMapModell";
CGFloat const kTrackOffset = 8000;
CGFloat const kFirstLocationRegion = 6000;

@interface MapViewController () <CLLocationManagerDelegate, ShopOnMapModellDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) MKPolylineRenderer *wayLine;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self map] setShowsUserLocation:YES];
    self.locationManager = [[CLLocationManager alloc] init];
    [[self locationManager] setDelegate:self];
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    [[self locationManager] startUpdatingLocation];
}

- (IBAction)burgerButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoButtonTapedNotificationName object:self];
}

-(void)setTrackWithEndPoint:(CLLocationCoordinate2D)endPointCoordinate {
    MKPlacemark *splace = [[MKPlacemark alloc] initWithCoordinate:self.map.userLocation.coordinate];
    MKMapItem *sitem =[[MKMapItem alloc] initWithPlacemark:splace];
    
    MKPlacemark *dplace = [[MKPlacemark alloc] initWithCoordinate:endPointCoordinate];
    MKMapItem *ditem =[[MKMapItem alloc] initWithPlacemark:dplace];
    
    MKDirectionsRequest *directionRequest = [[MKDirectionsRequest alloc] init];
    directionRequest.source = sitem;
    directionRequest.destination = ditem;
    directionRequest.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *direction = [[MKDirections alloc] initWithRequest:directionRequest];
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (response != nil) {
            [self.map addOverlay:[response.routes[0] polyline] level:MKOverlayLevelAboveRoads];
            MKMapRect rect = [[response.routes[0] polyline] boundingMapRect];
            MKMapRect regionRect = MKMapRectMake(rect.origin.x-kTrackOffset/2, rect.origin.y-kTrackOffset/2, rect.size.width+kTrackOffset, rect.size.height+kTrackOffset);
            [self.map setRegion:MKCoordinateRegionForMapRect(regionRect) animated:YES];
        }
    }];
}

- (MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    [mapView removeOverlay:self.wayLine.overlay];
    self.wayLine = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    self.wayLine.strokeColor = [UIColor blueColor];
    self.wayLine.lineWidth = 4;
    return self.wayLine;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[ShopOnMapModell class]]) {
        ShopOnMapModell *myLocation = (ShopOnMapModell*)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kShopOnMapModellIdentifier];
        
        if (annotationView == nil)
            annotationView = myLocation.annotationView;
        else
            annotationView.annotation = annotation;
        return annotationView;
    }
    else return nil;
}

#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CLLocationCoordinate2D coord = self.map.userLocation.location.coordinate;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, kFirstLocationRegion, kFirstLocationRegion);
        [self.map setRegion:region];
    });

    [[SADataManager sharedManager] fetchNearlyShopsWithCordinate:userLocation.coordinate andRadius:kRadius  withCompletion:^(id obj, NSError *err) {
        for (ShopOnMapModell *shop in obj) {
            shop.delegate = self;
            [self.map addAnnotation:shop];
        }
    }];
    
}

@end
