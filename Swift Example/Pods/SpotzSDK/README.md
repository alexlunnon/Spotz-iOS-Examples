Spotz SDK
==========

## Adding the Spotz SDK framework to your project

Just add the following line to your Podfile:
```
pod 'SpotzSDK', :git => 'https://github.com/localz/Spotz-iOS-SDK.git'
```

Changelog
=========
**1.0.2**
* Fixed initialisation issues.

**1.0.1**
* Initial public release.

How to use the SDK
==================

**Currently only devices that support Bluetooth Low Energy (iPhone 4s or above, running iOS 7 or better) are able to make use of the Spotz SDK**. It is safe to include the SDK on earlier versions of iOS or devices that don't support Bluetooth Low Energy. 

There are only 3 actions to implement - **initialize, start services and listen!**

*Refer to the sample app code for a working implementation of the SDK.*

In AppDelegate's didFinishLaunchingWithOptions add the following:

**1. Initialize the Spotz SDK**

```
    [SpotzSDK initializeWithAppId:@"<Enter your app ID here>" clientKey:@"<Enter your client key here>" delegate:self withOptions:nil];

```

When initialization is successful, it will call the spotzSDKInitSuccessfull delegate

**2. Start services**

```
#pragma mark - SpotzSDK delegates
- (void)spotzSDKInitSuccessfull
{
    NSLog(@"SpotzSDK initialized successfully");
    [SpotzSDK startServices];
}

- (void)spotzSDKInitFailed:(NSError *)error
{
	// Spotz failed to initialise
    NSLog(@"Error %@",error);
}
```

You can place this listener where it makes sense

**3. Listen for notifications**
```
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzInsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
      NSDictionary *data = note.object;
       Spotz *spotz = data[@"spotz"];
       SpotzBeacon *beacon = data[@"beacon"];
       
       NSLog(@"Beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid,beacon.major,beacon.minor);
       NSLog(@"Show spotz details");

       // Do something amazing here
    }];
```

You can listen for the following notifications:

- SpotzInsideNotification
- SpotzOutsideNotification

When available, both Spotz and SpotzBeacon objects will be returned in the note.object's NSDictionary in both events.

Contribution
============

For bugs, feature requests, or other questions, [file an issue](https://github.com/localz/Spotz-iOS-SDK/issues/new).

License
=======

Copyright 2014 Localz Pty Ltd

