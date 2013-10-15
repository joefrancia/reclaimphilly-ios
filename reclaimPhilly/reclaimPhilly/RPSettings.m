//
//  RPSettings.m
//  Reclaim Philly
//
//  Created by Joe Francia on 2011-02-24.
//  Copyright 2013 Joe Francia All rights reserved.

#import "RPSettings.h"
#import "BPXLUUIDHandler.h"

@interface RPSettings()

@end

@implementation RPSettings

+(RPSettings *)currentSettings {
    static dispatch_once_t pred;
    static RPSettings *shared = nil;

    dispatch_once(&pred, ^{
        shared = [[RPSettings alloc] init];
    });
    return shared;
}

-(NSString *)baseURL {
#ifdef DEBUG
    return @"http://monkeybrain.local:8000";
#else
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"baseURL"];
#endif
}

-(void)setBaseURL:(NSString *)baseURL {
    [[NSUserDefaults standardUserDefaults] setValue:baseURL forKey:@"baseURL"];
}


-(NSString *)udid {
    return [[[BPXLUUIDHandler UUID] lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}


-(NSString *)host {
    if (self.baseURL) {
        return [[NSURL URLWithString:self.baseURL] host];
    }

    return nil;
}



@end
