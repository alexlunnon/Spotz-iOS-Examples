//
//  SpotzSDK.h
//  SpotzSDK
//
//  Created by Melvin Artemas on 19/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spotz.h"
#import "SpotzBeacon.h"

typedef enum {
    SpotzOptionCustomLocationPermissionPrompt = 1
} SpotzOption;

typedef enum {
    SpotzLocationServiceStateNotEnabled = 1,
    SpotzLocationServiceStateNotDetermined = 2,
    SpotzLocationServiceStateAuthorized = 3,
    SpotzLocationServiceStateRestricted = 4,
    SpotzLocationServiceStateDenied = 5,
} SpotzLocationServiceState;

/**
 *  Notification when spotz is found. Spotz object will be attached to note.object if exists
 */
extern NSString * const SpotzInsideNotification;

/**
 *  Notification when previously found spotz is no longer detected.
 */
extern NSString * const SpotzOutsideNotification;

@protocol SpotzSDKDelegate <NSObject>
@optional
- (void) spotzSDKInitSuccessfull;
- (void) spotzSDKInitFailed:(NSError *)error;
- (void) spotzSDKPushNotificationRegistrationSuccess;
- (void) spotzSDKPushNotificationRegistrationFailed:(NSError *)error;
@end

@interface SpotzSDK : NSObject

/**
 *  Initialise service and register device with the given API Key and client Key
 *
 *  @param appId appId provided by Localz
 *  @param clientKey clientKey provided by Localz
 *  @param delegate delegate
 *  @param options dictionary of Spotz's options
 */
+ (void) initializeWithAppId:(NSString *)appId clientKey:(NSString *)clientKey delegate:(id)delegate withOptions:(NSDictionary *)options;

/**
 *  Register push notification device token for Push Notification
 *
 *  @param deviceToken deviceToken
 *  @param completion  completion
 */
+ (void) registerPushDeviceToken:(NSData *)deviceToken;

/**
 *  This will force check for beacons and trigger spotz notifications if any
 */
+ (void) checkSpotz;

/**
 *  Clear all spotz cached data. To restart please call startServices.
 */
+ (void) clearCache;

/**
 *  Delete everything and start from scratch. To restart please call startServices.
 */
+ (void) reset;

/**
 *  Check the current status of location service
 *
 *  @return SpotzLocationServiceState
 */
+ (SpotzLocationServiceState) checkLocationServices;

/**
 *  Start location service once permission has been obtained
 *  If this is the first time it is run, iOS will prompt user to enable the location service
 *  If location service has been denied previously, this method will do nothing.
 *  Please run [SpotzSDK checkLocationServices] to check the state of location service.
 */
+ (void) startServices;

@property (nonatomic,assign) id<SpotzSDKDelegate> delegate;

@end
