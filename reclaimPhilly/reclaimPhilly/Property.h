//
//  Property.h
//  reclaimPhilly
//
//  Created by Joe Francia on 12/9/12.
//  Copyright (c) 2012 Reclaim Philly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Property : NSManagedObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * image;

@end
