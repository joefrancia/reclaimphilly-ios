//
//  RPMainViewController.h
//  reclaimPhilly
//
//  Created by Joe Francia on 3/24/13.
//  Copyright (c) 2013 Reclaim Philly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@interface RPReportingViewController : UITabBarController <CLLocationManagerDelegate, GMSMapViewDelegate>

-(IBAction)reportLocation:(id)sender;
@end
