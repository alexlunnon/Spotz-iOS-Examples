//
//  LocalzAppDelegate.m
//  LocalzProximityExample
//
//  Created by Melvin Artemas on 11/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import "LocalzAppDelegate.h"
#import <SpotzSDK/SpotzSDK.h>

@interface LocalzAppDelegate()<SpotzSDKDelegate>
@end

@implementation LocalzAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // your app and ios id from your app on the spotz website
    [SpotzSDK initializeWithAppId:@"<Insert Application ID here>" clientKey:@"<Insert iOS Client ID here>" delegate:self withOptions:nil];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SpotzSDK delegates

- (void)spotzSDKInitSuccessfull
{
    NSLog(@"SpotzSDK initialized successfully");
    [SpotzSDK startServices];
    
    // your extension ids
    NSMutableDictionary *payload = [NSMutableDictionary new];
    // zapier webhook
    [payload setObject:@"<myValue>" forKey:@"zapierWebhook.<myKey>"];
    // teradata atrim
    [payload setObject:@"<teradataAccount>" forKey:@"teradataARTIM.<customerAccount>"];
    // screenz
    [payload setObject:@"<Screenz API Application ID>" forKey:@"screenz-api.userId"];
    
    // uncomment this when you have chosen your extensions above
//    [SpotzSDK identity:@"<myUsername>" attributes:payload];
}

- (void)spotzSDKInitFailed:(NSError *)error
{
    NSLog(@"Error %@",error);
}

- (void)spotzSDKPushNotificationRegistrationSuccess
{
    NSLog(@"SpotzSDK Push Notification registration successfull");
}

- (void)spotzSDKPushNotificationRegistrationFailed:(NSError *)error
{
    NSLog(@"SpotzSDK push notification registration failed. %@", error);
}

@end
