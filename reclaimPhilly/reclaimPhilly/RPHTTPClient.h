//
//  RPHTTPClient.h
//  reclaimPhilly
//
//  Created by Joe Francia on 12/9/12.
//  Copyright (c) 2012 Reclaim Philly. All rights reserved.
//

#import "AFHTTPClient.h"

@interface RPHTTPClient : AFHTTPClient
+(RPHTTPClient *)sharedInstance;
@end
