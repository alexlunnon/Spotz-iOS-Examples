//
//  SpotzNotifications.h
//  SpotzSDK
//
//  Created by Daniel Sykes-Turner on 19/01/2015.
//  Copyright (c) 2015 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SpotzNotifications : NSObject

- (void) registeredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void) failedToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void) receivedRemoteNotification:(NSDictionary *)userInfo applicationState:(UIApplicationState)state;

@end
