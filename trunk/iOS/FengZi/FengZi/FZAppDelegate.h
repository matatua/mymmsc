//
//  FZAppDelegate.h
//  FengZi
//
//  Created by WangFeng on 11-12-25.
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iOSTabBarController;

@interface FZAppDelegate : UIResponder <UIApplicationDelegate> {
    //iOSTabBarController *tabBarController;
}

@property (retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) iOSTabBarController *tabBarController;

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
