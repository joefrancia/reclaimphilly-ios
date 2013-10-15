//
//  NSDate+TeleBurn.m
//  TeleBurn Talk
//
//  Created by Joe Francia on 4/5/13.
//  Copyright (c) 2013 MedTrak, Inc. All rights reserved.
//

#import "NSDate+ReclaimPhilly.h"
#include <sys/time.h>

@implementation NSDate (ReclaimPhilly)

+(NSString *)timestamp {
    return [NSDate timestampWithFormat:@"%Y-%m-%d %H:%M:%S.%%06u %z"];
}

+(NSString *)timestampWithFormat:(NSString *)format {
    char fmt[64], buf[64];
    struct timeval tv;
    struct tm *tm;

    gettimeofday(&tv, NULL);
    if((tm = localtime(&tv.tv_sec)) != NULL) {
        strftime(fmt, sizeof fmt, [format UTF8String] , tm);
        snprintf(buf, sizeof buf, fmt, tv.tv_usec);
    }

    return [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
}

@end
