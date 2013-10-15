//
//  CSLogFormatter.h
//  CareSense
//
//  Created by Joe Francia on 2011-08-26.
//  Copyright 2011 Joe Francia All rights reserved.
//

#import "RPLog.h"

@interface RPLogFormatter : NSObject <DDLogFormatter> {
    NSDateFormatter *df;
}

@end

@interface RPConsoleLogFormatter : RPLogFormatter
@end

@interface RPFileLogFormatter : RPLogFormatter
@end
