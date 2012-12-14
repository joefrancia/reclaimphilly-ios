//
//  RPAppDelegate.h
//  reclaimPhilly
//
//  Created by Joe Francia on 12/6/12.
//  Copyright (c) 2012 Reclaim Philly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end