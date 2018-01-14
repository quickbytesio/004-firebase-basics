//
//  AppDelegate.m
//  Example 004
//
//  Created by Aaron Brethorst on 1/13/18.
//  Copyright © 2018 Quickbytes.io. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@import Firebase;

@interface AppDelegate ()
@property(nonatomic,strong) ViewController *viewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    self.viewController = [[ViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.viewController];

    self.window.rootViewController = navigation;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
