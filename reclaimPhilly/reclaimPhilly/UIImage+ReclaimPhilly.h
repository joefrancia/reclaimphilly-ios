//
//  UIImage+ReclaimPhilly.h
//  reclaimPhilly
//
//  Created by Joe Francia on 2013-08-04.
//  Copyright (c) 2013 Reclaim Philly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ReclaimPhilly)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
@end
