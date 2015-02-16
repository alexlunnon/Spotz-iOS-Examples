Spotz SDK
==========

## Adding the Spotz SDK framework to your project

Just add the following line to your Podfile:
```
pod 'SpotzSDK', :git => 'https://github.com/localz/Spotz-iOS-SDK.git'
```

How to use the SDK
==================

**Currently only devices that support Bluetooth Low Energy (iPhone 4s or above, running iOS 7 or better) are able to make use of the Spotz SDK**. It is safe to include the SDK on earlier versions of iOS or devices that don't support Bluetooth Low Energy. 

There are only 4 actions to implement - **configure, initialize, start services and listen!**

*Refer to the sample app code for a working implementation of the SDK.*


**1. Set authorization message**

For iOS 8 or later, please add the following key to Info.plist with a message that will be presented to the user when they first start the app.
```
NSLocationAlwaysUsageDescription
```

**2. Initialize the Spotz SDK**

In AppDelegate's didFinishLaunchingWithOptions add the following:
Swift
```
SpotzSDK.initializeWithAppId("<Enter your app ID here>", clientKey: "<Enter your client key here>", delegate: self, withOptions:nil)
```

Objective-C
```
[SpotzSDK initializeWithAppId:@"<Enter your app ID here>" clientKey:@"<Enter your client key here>" delegate:self withOptions:nil];
```

When initialization is successful, it will call the spotzSDKInitSuccessfull delegate method

**3. Start services**

Swift
```
func spotzSDKInitSuccessfull() {
    NSLog("SpotzSDK initialized successfully")
    SpotzSDK.startServices()
}

func spotzSDKInitFailed(error: NSError!) {
    NSLog("Error %@", error)
}
```

Objective-C
```
#pragma mark - SpotzSDK delegates
- (void)spotzSDKInitSuccessfull {
    NSLog(@"SpotzSDK initialized successfully");
    [SpotzSDK startServices];
}

- (void)spotzSDKInitFailed:(NSError *)error {
    NSLog(@"Error %@",error);
}
```

You can place this listener where it makes sense

**4. Listen for notifications**

Swift
```
// Set up to receive notifications from your spots
NSNotificationCenter.defaultCenter().addObserverForName(SpotzInsideNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
    if let data = note.object as? NSDictionary
    {
        // Take out the Spotz object and its beacon
        if let spotz = data["spotz"] as? Spotz
        {
            // Entry region will be either a geofence or a beacon
            if let beacon = data["beacon"] as? SpotzBeacon
            {
                NSLog("Entry beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
            }
            if let geofence = data["geofence"] as? SpotzGeofence
            {
                NSLog("Entry geofence (%@) detected with latitude: %f longitude: %f radius %i",spotz.name,geofence.latitude,geofence.longitude,Int(geofence.radius));
            }
        }
    }
}

NSNotificationCenter.defaultCenter().addObserverForName(SpotzRangingNotification, object: nil, queue: nil) { (note:NSNotification!) -> Void in
    if let data: NSDictionary = note.object as? NSDictionary
    {
        if let spotz = data["spotz"] as? Spotz
        {
            NSLog("Spotz id: %@ name: %@",spotz.id,spotz.name);
            // Do something with this Spotz data
        }
        if let acc = data["accuracy"] as? NSNumber
        {
            NSLog("Accuracy %@", acc)
            // Show the accuracy of the spotz
        }
        
        NSLog("Show spotz ranging details")
    }
}
```

Objective-C
```
[[NSNotificationCenter defaultCenter] addObserverForName:SpotzInsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
    if (note.object)
    {
        // Take out the Spotz object and its beacon
        NSDictionary *data = note.object;
        Spotz *spotz = data[@"spotz"];
        
        if (data[@"beacon"])
        {
            SpotzBeacon *beacon = data[@"beacon"];
            NSLog(@"Entry beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
        }
        else if (data[@"geofence"])
        {
            SpotzGeofence *geofence = data[@"geofence"];
            NSLog(@"Entry geofence (%@) detected with latitude: %f longitude %f",spotz.name,geofence.latitude,geofence.longitude);
        }
    }
}];

[[NSNotificationCenter defaultCenter] addObserverForName:SpotzRangingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
    if (note.object)
    {
        NSDictionary *data = note.object;
        
        Spotz *spotz = data[@"spotz"];
        NSNumber *acc = data[@"accuracy"];
        
        NSLog(@"Spotz id: %@ name: %@",spotz.id,spotz.name);
        NSLog(@"Accuracy %@", acc);

        // Do something with this Spotz and accuracy data
    }
}];
```

You can listen for the following notifications:

- SpotzInsideNotification
- SpotzOutsideNotification
- SpotzRangingNotification
- SpotzExtensionNotification

**Other things to remember**

When available, both Spotz and SpotzBeacon objects will be returned in the note.object's NSDictionary in both SpotzInsideNotification and SpotzOutsideNotification.
CLBeacon and rssi may be returned in SpotzRangingNotification.
When/if using CLBeacon, remember to @import CoreLocation at the top of your file.

You cannot monitor for more than 20 regions (20 regions = total beacons + total geofences) per app.
There is also a device limit which you are not told about. On smaller devices (e.g. iPod touch) this is 20 regions. On larger devices (e.g. iPhone 6) this is 30 regions.
BUT we use magic to avoid these limits, so there may be a delay between swapping inbetween Spotz groups if you don't use SpotzSDK.forceCheckSpotz() or [SpotzSDK forceCheckSpotz].

Geofences are not as accurate as beacons, AT BEST they have an accuracy of 5 meters.
So it is very possible that a devices can physically cross a geofences area but not be picked up because the device still thinks it is outside due to the low accuracy. Walking around a little may help.

Changelog
=========
**2.0.0**
* Spotz 2.0 release!
* Added spotz grouping
* Added geofences
* Added offline mode
* Added extensions
* Recheck regions greatly sped up

**1.0.5**
* Added spotz ranging

**1.0.4**
* Fixed issues with refreshing spotz
* Updated spotz data from NSArray to NSDictionary

**1.0.3**
* Added support for iOS 8

**1.0.2**
* Fixed initialisation issues.

**1.0.1**
* Initial public release.

Contribution
============
For bugs, feature requests, or other questions, [file an issue](https://github.com/localz/Spotz-iOS-SDK/issues/new).

License
=======
Copyright 2015 Localz Pty Ltd

