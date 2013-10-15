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
        NSURL *url = [NSURL URLWithString:[RPSettings currentSettings].baseURL];
        sharedRPHTTPClient = [[self alloc] initWithBaseURL:url];
    });
    return sharedRPHTTPClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.parameterEncoding = AFJSONParameterEncoding;
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
        [self setDefaultHeader:@"X-Device-UDID" value:[RPSettings currentSettings].udid];

        [self setDefaultHeader:@"User-Agent"
                         value:[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f; %@)",
                                [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey],
                                (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey],
                                [[UIDevice currentDevice] model],
                                [[UIDevice currentDevice] systemVersion],
                                ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f),
                                [RPSettings currentSettings].udid]];
    }

    return self;
}


@end
