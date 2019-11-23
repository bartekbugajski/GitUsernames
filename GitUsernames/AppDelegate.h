//
//  AppDelegate.h
//  GitUsernames
//
//  Created by Bartek Bugajski on 21/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;


- (void)saveContext;


@end

