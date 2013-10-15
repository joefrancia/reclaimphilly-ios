//
//  RPMainViewController.m
//  reclaimPhilly
//
//  Created by Joe Francia on 5/20/13.
//  Copyright (c) 2013 Reclaim Philly. All rights reserved.
//

#import "RPMainViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RPSettings.h"

@interface RPMainViewController ()

@end

@implementation RPMainViewController {
     GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
