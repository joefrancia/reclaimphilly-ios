//
//  RPDBLogger.m
//  ReclaimPhilly
//
//  Created by Joe Francia on 4/21/13.
//  Copyright (c) 2013 MedTrak, Inc. All rights reserved.
//

#import "RPDBLogger.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "NSDate+ReclaimPhilly.h"

const int CURRENT_DB_SCHEMA = 1;
NSTimer *uploadTimer;
NSOperationQueue *uploadQueue;

@interface RPDBLogger ()
@property (nonatomic, strong) FMDatabaseQueue *logDB;
@end

@implementation RPDBLogger

-(id)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        uploadQueue = [[NSOperationQueue alloc] init];

        self.logDB = [FMDatabaseQueue databaseQueueWithPath:[basePath stringByAppendingPathComponent:@"logfile.sqlite"]];
        [self.logDB inDatabase:^(FMDatabase *db) {
            FMResultSet *s = [db executeQuery:@"PRAGMA table_info(logs)"];
            BOOL drop = NO;
            while ([s next]) {
                if ([[s stringForColumn:@"name"] isEqualToString:@"log"] &&
                    [[s stringForColumn:@"type"] isEqualToString:@"TEXT"]) {
                    drop = YES;
                }
            }

            [db closeOpenResultSets];

            if (drop) {
                if (![db executeUpdate:@"DROP TABLE logs"]) {
                    dispatch_async([DDLog loggingQueue], ^{
                        DDLogWarn(@"%@", [db lastError]);
                    });
                }
            }

            if (![db tableExists:@"logs"]) {
                [db executeUpdate:@"CREATE TABLE logs (id TEXT PRIMARY KEY ON CONFLICT IGNORE, log BLOB)"];
            }
        }];

        [self.logDB inDatabase:^(FMDatabase *db) {
            [db executeQuery:@"PRAGMA user_version = ?", [NSNumber numberWithInt:CURRENT_DB_SCHEMA]];
        }];

        uploadTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(uploadLogs:) userInfo:nil repeats:YES];
    }

    return self;
}

-(void)dealloc {
    [self.logDB close];
}

-(void)write:(NSDictionary *)logData {
    NSError *err;
    NSData *_logData = [NSJSONSerialization dataWithJSONObject:logData options:0 error:&err];
    if (_logData) {
        [self.logDB inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"INSERT INTO logs VALUES (?, ?)", logData[@"unique_hash"], _logData];
        }];
    } else {
        dispatch_async([DDLog loggingQueue], ^{
            DDLogWarn(@"Could not serialize %@ into JSON: %@", logData, [err localizedDescription]);
        });
    }
}

-(void)uploadLogs:(NSTimer *)timer {

    NSMutableDictionary *logs = [NSMutableDictionary dictionaryWithCapacity:2];
    [self.logDB inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM logs LIMIT 23"];
        NSError *err;
        while ([rs next]) {
            NSDictionary *log = [NSJSONSerialization JSONObjectWithData:[rs dataForColumn:@"log"] options:0 error:&err];
            if (log) {
                logs[[rs stringForColumn:@"id"]] = log;
            } else {
                dispatch_async([DDLog loggingQueue], ^{
                    DDLogWarn(@"Error deserializing log entry.  Discarding: %@", [err localizedDescription]);
                });
                if (![db executeUpdate:@"DELETE FROM logs WHERE id = ?", [rs stringForColumn:@"id"]]) {
                    dispatch_async([DDLog loggingQueue], ^{
                        DDLogWarn(@"%@", [db lastError]);
                    });
                }
            }
        }
    }];

    if (logs.count) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSMutableDictionary *logData = [NSMutableDictionary dictionaryWithCapacity:2];
            logData[@"udid"] = [RPSettings currentSettings].udid;
            logData[@"logs"] = logs;

            [[RPHTTPClient sharedInstance]
             postPath:@"api/import_logs/"
             parameters:logData
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self.logDB inDatabase:^(FMDatabase *db) {
                     for (NSString *id in responseObject[@"ids"]) {
                         if (![db executeUpdate:@"DELETE FROM logs WHERE id = ?", id]) {
                             dispatch_async([DDLog loggingQueue], ^{
                                 DDLogWarn(@"%@", [db lastError]);
                             });
                         }
                     }
                     [db executeUpdate:@"vacuum"];
                 }];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 dispatch_async([DDLog loggingQueue], ^{
                     //DDLogWarn(@"%@", error);
                 });
             }];
        }];

        [uploadQueue addOperation:op];
    }
}


-(void)logMessage:(DDLogMessage *)logMessage {

    NSString *logLevel;
    switch (logMessage->logFlag) {
        case LOG_FLAG_ERROR   : logLevel = @"E"; break;
        case LOG_FLAG_WARN    : logLevel = @"W"; break;
        case LOG_FLAG_INFO    : logLevel = @"I"; break;
        case LOG_FLAG_VERBOSE : logLevel = @"V"; break;
        case LOG_FLAG_DEBUG   : logLevel = @"D"; break;
        default               : logLevel = @"?"; break;
    }

    NSString *classFile = [[@(logMessage->file) lastPathComponent] stringByDeletingPathExtension];

    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    NSString *hash = (__bridge_transfer NSString *)(CFUUIDCreateString(NULL, theUUID));
    CFRelease(theUUID);

    NSDictionary *logObj = @{
                             @"timestamp": [NSDate timestamp],
                             @"thread_id": $(@"%x", logMessage->machThreadID),
                             @"log_level": logLevel,
                             @"msg": logMessage->logMsg,
                             @"class_name": classFile,
                             @"method": $(@"%s", logMessage->function),
                             @"line_number": [NSNumber numberWithInt:logMessage->lineNumber],
                             @"unique_hash": hash
                             };
    
    [self write:logObj];
    
}

@end
