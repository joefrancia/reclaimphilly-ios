//
//  CSLogFormatter.m
//  CareSense
//
//  Created by Joe Francia on 2011-08-26.
//  Copyright 2011 Joe Francia All rights reserved.
//

#import "RPLogFormatter.h"
#import <pthread.h>
#import <CommonCrypto/CommonDigest.h>

pthread_mutex_t c_log_mutex;
pthread_mutex_t f_log_mutex;

@implementation RPLogFormatter

-(id)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&c_log_mutex, NULL);
        pthread_mutex_init(&f_log_mutex, NULL);

        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }

    return self;
}

-(void)dealloc {
    pthread_mutex_destroy(&f_log_mutex);
    pthread_mutex_destroy(&c_log_mutex);
}

//This is implemented to prevent warnings when compiling
//You'll want to override this in derived classes
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    return logMessage->logMsg;
}

@end

@implementation RPConsoleLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->logFlag) {
        case LOG_FLAG_ERROR   : logLevel = @"E"; break;
        case LOG_FLAG_WARN    : logLevel = @"W"; break;
        case LOG_FLAG_INFO    : logLevel = @"I"; break;
        case LOG_FLAG_VERBOSE : logLevel = @"V"; break;
        case LOG_FLAG_DEBUG   : logLevel = @"D"; break;
        default               : logLevel = @"?"; break;
    }

    return [NSString stringWithFormat:@"%@ %x %@ %@", [NSDate timestamp], logMessage->machThreadID, logLevel, logMessage->logMsg];
}

@end

