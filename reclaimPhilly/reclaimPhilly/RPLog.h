//
//  RPLog.h
//  ReclaimPhilly
//
//  Created by Joe Francia on 10/5/12.
//  Copyright (c) 2012 Joe Francia. All rights reserved.
//

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "RPLogFormatter.h"
#import "RPDBLogger.h"


#define LOG_FLAG_DEBUG    (1 << 4)  // 0...1001

#define LOG_LEVEL_DEBUG   (LOG_FLAG_ERROR | LOG_FLAG_WARN | LOG_FLAG_INFO | LOG_FLAG_VERBOSE | LOG_FLAG_DEBUG) // 0...1111

#define LOG_DEBUG (ddLogLevel & LOG_FLAG_DEBUG)

#define LOG_ASYNC_DEBUG (NO && LOG_ASYNC_ENABLED)

#define DDLogDebug(frmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_DEBUG, ddLogLevel, LOG_FLAG_DEBUG, 0, frmt, ##__VA_ARGS__)

#define DDLogCDebug(frmt, ...) LOG_C_MAYBE(LOG_ASYNC_DEBUG, ddLogLevel, LOG_FLAG_DEBUG, 0, frmt, ##__VA_ARGS__)



#ifdef DEBUG
static __unused int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static __unused int ddLogLevel = LOG_LEVEL_VERBOSE;
#endif
