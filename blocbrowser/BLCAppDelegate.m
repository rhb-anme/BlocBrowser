//
//  AppDelegate.m
//  blocbrowser
//
//  Created by RH Blanchfield on 3/6/15.
//  Copyright (c) 2015 bloc. All rights reserved.
//

#import "BLCAppDelegate.h"
#import "BLCWebBrowserViewController.h"

@implementation BLCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BLCWebBrowserViewController alloc] init]];

    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    UINavigationController *navigationVC = (UINavigationController *)self.window.rootViewController;
    BLCWebBrowserViewController *browserVC = [[navigationVC viewControllers] firstObject];
    [browserVC resetWebView];
}
@end
