//
//  RCCFirstViewController.h
//  ReclaimPhilly
//
//  Created by Joe Francia on 2014-04-12.
//  Copyright (c) 2014 ReclaimCities. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
//#import <MapKit/MapKit.h>

@interface RCCMapViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate>

@end
