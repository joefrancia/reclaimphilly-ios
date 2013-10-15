//
//  RPAppDelegate.m
//  reclaimPhilly
//
//  Created by Joe Francia on 12/6/12.
//  Copyright (c) 2012 Reclaim Philly. All rights reserved.
//

#import "RPAppDelegate.h"
#import "RPHTTPClient.h"
#import "RPMainViewController.h"
#import "RPLog.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation RPAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //[Crittercism enableWithAppID:@"514c7aa646b7c2799100000c"];
    [GMSServices provideAPIKey:kGoogleMapsAPIKey];

    //Setup logging
    RPConsoleLogFormatter *consoleLogFormatter = [[RPConsoleLogFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:consoleLogFormatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    //[DDLog addLogger:[[RPDBLogger alloc] init]];

    DDLogInfo(@"Using host %@", [RPSettings currentSettings].host);
    DDLogInfo(@"API URL %@", [RPSettings currentSettings].baseURL);

    self.window.rootViewController = self.tabBarController;
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];


//    if (![RPSettings currentSettings].baseURL) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *hostPrompt = [UIAlertView alertViewWithTitle:@"Missing Host" message:@"Please enter a host in the form example.com:8000.  You don't need to add a port if it is 80."];
//            hostPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
//            [hostPrompt addButtonWithTitle:@"Cancel" handler:^{
//
//            }];
//            [hostPrompt addButtonWithTitle:@"Save" handler:^{
//
//            }];
//            [hostPrompt show];
//        });
//    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}


@end
