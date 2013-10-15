//
//  RPMainViewController.m
//  reclaimPhilly
//
//  Created by Joe Francia on 3/24/13.
//  Copyright (c) 2013 Reclaim Philly. All rights reserved.
//

#import "RPReportingViewController.h"
#import "STKSpinnerView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RPDetailViewController.h"
#import "RPProperty.h"

#define METERS_PER_MILE 1609.344

BOOL firstLocationUpdate;

@interface RPReportingViewController ()
@end

@implementation RPReportingViewController {
    GMSMapView *gmapView;
    CLLocationManager *locationManager;
    BOOL lockToCurrentLocation;
    GMSGeocoder *geoCoder;
    GMSMarker *reportedPropertyMarker;
    UIView *reportedPropertyView;
    CLGeocoder *geoCoderApple;

}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMapView];

    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];

    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;

    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingHeading];
    });

    self.selectedIndex = 0;
    geoCoderApple = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)setupMapView {

    lockToCurrentLocation = NO;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.95248280
                                                            longitude:-75.16262110
                                                                 zoom:10];
    gmapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    gmapView.delegate = self;
    self.view = gmapView;
    gmapView.myLocationEnabled = YES;

//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = gmapView;
    if (!geoCoder) {
        geoCoder = [[GMSGeocoder alloc] init];
    }

    [geoCoder reverseGeocodeCoordinate:locationManager.location.coordinate
                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                         DDLogDebug(@"%@", response.results);
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
        [gmapView animateToCameraPosition:pos];
    });

    if (lockToCurrentLocation) {
        GMSCameraUpdate *u = [GMSCameraUpdate setTarget:newLocation.coordinate];
        [gmapView animateWithCameraUpdate:u];
    }

//    [geoCoder reverseGeocodeCoordinate:locationManager.location.coordinate
//                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
//                         DDLogDebug(@"%@", response.results);
//                     }];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    if (lockToCurrentLocation) {
        [gmapView animateToBearing:newHeading.magneticHeading];
    }
}

-(IBAction)reportLocation:(id)sender {
    NSDictionary *reportData = @{
                                 @"latitude": @(locationManager.location.coordinate.latitude),
                                 @"longitude": @(locationManager.location.coordinate.longitude),
                                 @"magnetic_heading": @(locationManager.heading.magneticHeading),
                                 @"true_heading": @(locationManager.heading.trueHeading),
                                 @"heading_accuracy": @(locationManager.heading.headingAccuracy),
                                 @"lot_type": @"bldg"};

    [[RPHTTPClient sharedInstance] postPath:kSaveLocationPath
                                 parameters:reportData
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        DDLogInfo(@"Successfully posted location");
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        DDLogError(@"Failed to POST location: %@", [error localizedDescription]);
                                    }];
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
    if (reportedPropertyMarker) {
        reportedPropertyMarker.map = nil;
    }

    reportedPropertyMarker = [GMSMarker markerWithPosition:coordinate];
    reportedPropertyMarker.tappable = YES;
    reportedPropertyMarker.animated = YES;
    reportedPropertyMarker.title = @"Please wait...";

#pragma mark TODO Compare the Apple and Google addresses, give a choice if they differ (stripe leading zeros from numbered streets
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geoCoderApple reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        DDLogInfo(@"%@", placemarks);
    }];

    [geoCoder reverseGeocodeCoordinate:coordinate
                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {

                         RPProperty *property;

                         if (error) {
                             reportedPropertyMarker.title = @"No address found";
                             reportedPropertyMarker.snippet = @"Tap here to enter address and report";
                             property = [[RPProperty alloc] init];

                         } else {
                             property = [[RPProperty alloc]
                                                     initWithAddress:[[response firstResult] addressLine1]
                                                     andAddress:[[response firstResult] addressLine2]];

                         }

                         property.latitude = coordinate.latitude;
                         property.longitude = coordinate.longitude;

                         DDLogDebug(@"**************  %@", response.results);

                         reportedPropertyMarker.title = [[response firstResult] addressLine1];
                         reportedPropertyMarker.snippet = @"Tap here to report";
                         mapView.selectedMarker = reportedPropertyMarker;
                         reportedPropertyMarker.userData = property;
                         [mapView animateToLocation:coordinate];
                     }];

    reportedPropertyMarker.map = mapView;


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

    dispatch_async(dispatch_get_main_queue(), ^{
        RPDetailViewController *detailView = [[RPDetailViewController alloc] initWithNibName:@"RPDetailView" bundle:nil];
        [self presentViewController:detailView animated:YES completion:^{
            if (![reportedPropertyMarker.title isEqualToString:@"Error retrieving address"]) {
                detailView.addressField.text = reportedPropertyMarker.title;
                detailView.property = reportedPropertyMarker.userData;
            }
        }];
    });
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
