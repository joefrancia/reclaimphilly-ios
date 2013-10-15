//
//  Settings.h
//  CareSense
//
//  Created by Joe Francia on 2011-02-24.
//  Copyright 2011 MedTrak, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RPSettings : NSObject

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSString *host;

+(RPSettings *)currentSettings;

@end
