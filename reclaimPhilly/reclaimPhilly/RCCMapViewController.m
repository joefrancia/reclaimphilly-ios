//
//  RCCFirstViewController.m
//  ReclaimPhilly
//
//  Created by Joe Francia on 2014-04-12.
//  Copyright (c) 2014 ReclaimCities. All rights reserved.
//

#import "RCCMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RCCProperty.h"

@interface RCCMapViewController ()
@property (nonatomic, strong) GMSMapView *gmapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) GMSGeocoder *geoCoder;
@property (nonatomic, assign) BOOL lockToCurrentLocation;
@property (nonatomic, strong) GMSMarker *reportedPropertyMarker;
@property (nonatomic, strong) UIView *reportedPropertyView;
@property (nonatomic, strong) CLGeocoder *geoCoderApple;
@end

@implementation RCCMapViewController

- (void)viewDidLoad
{
    // [super viewDidLoad];

    [self setupMapView];

    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    });

    self.geoCoderApple = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupMapView {

    self.lockToCurrentLocation = NO;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.95248280
                                                            longitude:-75.16262110
                                                                 zoom:10];
    self.gmapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.gmapView.delegate = self;
    self.view = self.gmapView;
    self.gmapView.myLocationEnabled = YES;

    //    // Creates a marker in the center of the map.
    //    GMSMarker *marker = [[GMSMarker alloc] init];
    //
    //    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    //    marker.title = @"Sydney";
    //    marker.snippet = @"Australia";
    //    marker.map = gmapView;
    if (!self.geoCoder) {
        self.geoCoder = [[GMSGeocoder alloc] init];
    }

    [self.geoCoder reverseGeocodeCoordinate:self.locationManager.location.coordinate
                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                         //TODO: DDLogDebug(@"%@", response.results);
                     }];
    
}

#pragma mark -
#pragma mark CLLocation delegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GMSCameraPosition *pos = [GMSCameraPosition cameraWithTarget:newLocation.coordinate zoom:19];
        GMSCameraUpdate *u = [GMSCameraUpdate setTarget:newLocation.coordinate];
        [self.gmapView animateToCameraPosition:pos];
    });

    if (self.lockToCurrentLocation) {
        GMSCameraUpdate *u = [GMSCameraUpdate setTarget:newLocation.coordinate];
        [self.gmapView animateWithCameraUpdate:u];
    }

    //    [geoCoder reverseGeocodeCoordinate:locationManager.location.coordinate
    //                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
    //                         DDLogDebug(@"%@", response.results);
    //                     }];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    if (self.lockToCurrentLocation) {
        [self.gmapView animateToBearing:newHeading.magneticHeading];
    }
}



#pragma mark -
#pragma mark GMSMapView delegates

/**
 * Called after the camera position has changed. During an animation, this
 * delegate might not be notified of intermediate camera positions. However, it
 * will always be called eventually with the final position of an the animation.
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {

}

/**
 * Called after a tap gesture at a particular coordinate, but only if a marker
 * was not tapped.  This is called before deselecting any currently selected
 * marker (the implicit action for tapping on the map).
 */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {

}

/**
 * Called after a long-press gesture at a particular coordinate.
 *
 * @param mapView The map view that was pressed.
 * @param coordinate The location that was pressed.
 */
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.reportedPropertyMarker) {
        self.reportedPropertyMarker.map = nil;
    }

    self.reportedPropertyMarker = [GMSMarker markerWithPosition:coordinate];
    self.reportedPropertyMarker.tappable = YES;
    //reportedPropertyMarker.animated = YES;
    self.reportedPropertyMarker.title = @"Please wait...";

#pragma mark TODO Compare the Apple and Google addresses, give a choice if they differ (stripe leading zeros from numbered streets
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.geoCoderApple reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        //TODO: DDLogInfo(@"%@", placemarks);
    }];

    [self.geoCoder reverseGeocodeCoordinate:coordinate
                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {

                         RCCProperty *property;

                         if (error) {
                             self.reportedPropertyMarker.title = @"No address found";
                             self.reportedPropertyMarker.snippet = @"Tap here to enter address and report";
                             property = [[RCCProperty alloc] init];

                         } else {
                             property = [[RCCProperty alloc]
                                         initWithAddress:[[response firstResult] addressLine1]
                                         andAddress:[[response firstResult] addressLine2]];

                         }

                         property.latitude = coordinate.latitude;
                         property.longitude = coordinate.longitude;

                         //TODO: DDLogDebug(@"**************  %@", response.results);

                         //TODO: This is deprecated
                         self.reportedPropertyMarker.title = [[response firstResult] addressLine1];
                         self.reportedPropertyMarker.snippet = @"Tap here to report";
                         mapView.selectedMarker = self.reportedPropertyMarker;
                         self.reportedPropertyMarker.userData = property;
                         [mapView animateToLocation:coordinate];
                     }];

    self.reportedPropertyMarker.map = mapView;


}

/**
 * Called after a marker has been tapped.
 *
 * @param mapView The map view that was pressed.
 * @param marker The marker that was pressed.
 * @return YES if this delegate handled the tap event, which prevents the map
 *         from performing its default selection behavior, and NO if the map
 *         should continue with its default selection behavior.
 */
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    return NO;
}

/**
 * Called after a marker's info window has been tapped.
 */
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {

    //TODO: Must fix
//    dispatch_async(dispatch_get_main_queue(), ^{
//        RPDetailViewController *detailView = [[RPDetailViewController alloc] initWithNibName:@"RPDetailView" bundle:nil];
//        [self presentViewController:detailView animated:YES completion:^{
//            if (![reportedPropertyMarker.title isEqualToString:@"Error retrieving address"]) {
//                detailView.addressField.text = reportedPropertyMarker.title;
//                detailView.property = reportedPropertyMarker.userData;
//            }
//        }];
//    });
}

/**
 * Called after an overlay has been tapped.
 * This method is not called for taps on markers.
 *
 * @param mapView The map view that was pressed.
 * @param overlay The overlay that was pressed.
 */
-(void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay {

}

/**
 * Called when a marker is about to become selected, and provides an optional
 * custom info window to use for that marker if this method returns a UIView.
 * If you change this view after this method is called, those changes will not
 * necessarily be reflected in the rendered version.
 *
 * The returned UIView must not have bounds greater than 500 points on either
 * dimension.  As there is only one info window shown at any time, the returned
 * view may be reused between other info windows.
 *
 * @return The custom info window for the specified marker, or nil for default
 */
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    return nil; //reportedProertyView;
}



@end
