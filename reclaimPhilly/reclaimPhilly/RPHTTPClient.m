//
//  RPHTTPClient.m
//  reclaimPhilly
//
//  Created by Joe Francia on 12/9/12.
//  Copyright (c) 2012 Reclaim Philly. All rights reserved.
//

#import "RPHTTPClient.h"

@implementation RPHTTPClient

+(RPHTTPClient *)sharedInstance {
    static RPHTTPClient *sharedRPHTTPClient = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        NSURL *url = [NSURL URLWithString:kBaseURL];
        sharedRPHTTPClient = [[self alloc] initWithBaseURL:url];
    });
    return sharedRPHTTPClient;
}



@end
