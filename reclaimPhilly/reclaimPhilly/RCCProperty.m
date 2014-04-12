//
//  Property.m
//  reclaimPhilly
//
//  Created by Joe Francia on 12/9/12.
//  Copyright (c) 2012 Reclaim Philly. All rights reserved.
//

#import "RCCProperty.h"
//#import "RPHTTPClient.h"
#import "NSDate+ReclaimCities.h"

static NSString *const postURL = @"/services/location";
NSString *const LOT = @"lot";
NSString *const RES = @"res";
NSString *const NRS = @"nrs";

@implementation RCCProperty

-(id)init {
    if (self = [super init]) {
        self.address1 = @"";
        self.address2 = @"";
        self.description = @"";
    }

    return self;
}

-(id)initWithAddress:(NSString *)address1 andAddress:(NSString *)address2 {
    if (self = [super init]) {
        self.address1 = address1;
        self.address2 = address2;
        self.description = @"";
    }

    return self;
}

-(NSNumber *)addPicture:(UIImage *)picture {
    if (!self.picture1) {
        self.picture1 = picture;
        return @1;
    }

    if (!self.picture2) {
        self.picture2 = picture;
        return @2;
    }

    if (!self.picture3) {
        self.picture3 = picture;
        return @3;
    }

    self.picture1 = picture;
    return @1;
}

-(void)setLotType:(NSString *)lotType {
    if (![lotType isEqualToString:LOT] &&
        ![lotType isEqualToString:RES] &&
        ![lotType isEqualToString:NRS]) {
#pragma mark TODO How do handle this?
    } else {
        _lotType = lotType;
    }
}

-(void)report {

    if (!self.address1 || !self.latitude || !self.longitude || !self.lotType) {
#pragma mark TODO Error handling
        return;
    }

    NSDictionary *parameters = @{@"address": [self.address1 copy],
                                 @"description": [self.description copy],
                                 @"latitude": @(self.latitude),
                                 @"longitude": @(self.longitude),
                                 @"lot_type": [self.lotType copy]
                                 };

    if (!self.picture1 && !self.picture2 && !self.picture3) {
        //TODO: Must fix
//        [[RPHTTPClient sharedInstance] POST:postURL
//                                 parameters:parameters
//                                    success:^(NSURLSessionDataTask *task, id responseObject) {
//                                        DDLogInfo(@"Ph yea");
//                                    }
//                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                        DDLogError(@"%@", error);
//                                    }];
//    } else {
//
//        [[RPHTTPClient sharedInstance] POST:postURL
//                                 parameters:parameters
//                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                      if (self.picture1) {
//                          [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picture1, 0.7)
//                                                      name:@"picture1"
//                                                  fileName:[NSString stringWithFormat:@"1-%@.jpeg", [NSDate timestamp]]
//                                                  mimeType:@"image/jpeg"];
//                      }
//
//                      if (self.picture2) {
//                          [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picture2, 0.7)
//                                                      name:@"picture2"
//                                                  fileName:[NSString stringWithFormat:@"2-%@.jpeg", [NSDate timestamp]]
//                                                  mimeType:@"image/jpeg"];
//                      }
//
//                      if (self.picture3) {
//                          [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picture3, 0.7)
//                                                      name:@"picture3"
//                                                  fileName:[NSString stringWithFormat:@"3-%@.jpeg", [NSDate timestamp]]
//                                                  mimeType:@"image/jpeg"];
//                      }
//                  }
//                                    success:^(NSURLSessionDataTask *task, id responseObject) {
//                                        DDLogInfo(@"Oh yea");
//                                    }
//                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                        DDLogError(@"%@", error);
//                                    }];
    }
}


@end
