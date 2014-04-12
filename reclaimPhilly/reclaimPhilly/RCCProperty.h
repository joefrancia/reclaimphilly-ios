//
//  Property.h
//  reclaimPhilly
//
//  Created by Joe Francia on 12/9/12.
//  Copyright (c) 2012 Reclaim Philly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const LOT;
extern NSString *const RES;
extern NSString *const NRS;

@interface RCCProperty : NSObject

@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *lotType;
@property (nonatomic, strong) UIImage  *picture1;
@property (nonatomic, strong) UIImage  *picture2;
@property (nonatomic, strong) UIImage  *picture3;
@property (nonatomic, strong) NSString *description;

-(id)initWithAddress:(NSString *)address1 andAddress:(NSString *)address2;
-(void)report;
-(NSNumber *)addPicture:(UIImage *)picture;

@end
