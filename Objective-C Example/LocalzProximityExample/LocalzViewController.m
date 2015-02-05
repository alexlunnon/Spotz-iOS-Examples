//
//  LocalzViewController.m
//  LocalzProximityExample
//
//  Created by Melvin Artemas on 11/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import "LocalzViewController.h"
#import <SpotzSDK/SpotzSDK.h>

@interface LocalzViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end

@implementation LocalzViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localz.co/spotz-web-examples/index.html"]]];

    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzInsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Spotz inside");
        
        if(note.object)
        {
            NSDictionary *payload = note.object;
            Spotz *spotz = payload[@"spotz"];
            
            // Spotz Data to JSON
            NSDictionary *data = spotz.data;
            NSData* spotzData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString* spotzDataJSON = [[NSString alloc] initWithBytes:[spotzData bytes] length:[spotzData length] encoding:NSUTF8StringEncoding];
            
            // Spotz Name to JSON
            NSDictionary *spotzName = @{@"id":spotz.id,@"name":spotz.name};
            NSData* spotzNameData = [NSJSONSerialization dataWithJSONObject:spotzName options:0 error:nil];
            NSString* spotzNameJSON = [[NSString alloc] initWithBytes:[spotzNameData bytes] length:[spotzNameData length] encoding:NSUTF8StringEncoding];
            
            // Either a beacon or a geofence will be passed over
            if (payload[@"beacon"])
            {
                SpotzBeacon *beacon = payload[@"beacon"];
            
                // Spotz Beacon to JSON
                NSDictionary *spotzBeacon = @{@"uuid":beacon.uuid,@"major":[NSNumber numberWithInt:beacon.major],@"minor":[NSNumber numberWithInt:beacon.minor],@"serial":beacon.serial};
                NSData* spotzBeaconData = [NSJSONSerialization dataWithJSONObject:spotzBeacon options:0 error:nil];
                NSString* spotzBeaconJSON = [[NSString alloc] initWithBytes:[spotzBeaconData bytes] length:[spotzBeaconData length] encoding:NSUTF8StringEncoding];
                
                
                NSString *str = [NSString stringWithFormat:@"monitorData(%@,%@,%@)",spotzNameJSON,spotzBeaconJSON,spotzDataJSON];

                [self.webview stringByEvaluatingJavaScriptFromString:str];
            }
            else if (payload[@"geofence"])
            {
                SpotzGeofence *geofence = payload[@"geofence"];
                
                // Spotz Geofence to JSON
                NSDictionary *spotzGeofence = @{@"latitude":[NSNumber numberWithFloat:geofence.latitude],@"longitude":[NSNumber numberWithFloat:geofence.longitude],@"radius":[NSNumber numberWithFloat:geofence.radius]};
                NSData* spotzGeofenceData = [NSJSONSerialization dataWithJSONObject:spotzGeofence options:0 error:nil];
                NSString* spotzGeofenceJSON = [[NSString alloc] initWithBytes:[spotzGeofenceData bytes] length:[spotzGeofenceData length] encoding:NSUTF8StringEncoding];
                
                NSString *str = [NSString stringWithFormat:@"monitorData(%@,%@,%@)",spotzNameJSON,spotzGeofenceJSON,spotzDataJSON];

                [self.webview stringByEvaluatingJavaScriptFromString:str];
            }
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzOutsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Spotz outside");
        
        if(note.object)
        {
            NSDictionary *payload = note.object;
            Spotz *spotz = payload[@"spotz"];
            
            // Spotz Data to JSON
            NSDictionary *data = spotz.data;
            NSData* spotzData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString* spotzDataJSON = [[NSString alloc] initWithBytes:[spotzData bytes] length:[spotzData length] encoding:NSUTF8StringEncoding];
            
            // Spotz Name to JSON
            NSDictionary *spotzName = @{@"id":spotz.id,@"name":spotz.name};
            NSData* spotzNameData = [NSJSONSerialization dataWithJSONObject:spotzName options:0 error:nil];
            NSString* spotzNameJSON = [[NSString alloc] initWithBytes:[spotzNameData bytes] length:[spotzNameData length] encoding:NSUTF8StringEncoding];
            
            // Either a beacon or a geofence will be passed over
            if (payload[@"beacon"])
            {
                SpotzBeacon *beacon = payload[@"beacon"];
                
                // Spotz Beacon to JSON
                NSDictionary *spotzBeacon = @{@"uuid":beacon.uuid,@"major":[NSNumber numberWithInt:beacon.major],@"minor":[NSNumber numberWithInt:beacon.minor],@"serial":beacon.serial};
                NSData* spotzBeaconData = [NSJSONSerialization dataWithJSONObject:spotzBeacon options:0 error:nil];
                NSString* spotzBeaconJSON = [[NSString alloc] initWithBytes:[spotzBeaconData bytes] length:[spotzBeaconData length] encoding:NSUTF8StringEncoding];
                
                
                NSString *str = [NSString stringWithFormat:@"hideData(%@,%@,%@)",spotzNameJSON,spotzBeaconJSON,spotzDataJSON];
                
                [self.webview stringByEvaluatingJavaScriptFromString:str];
            }
            else if (payload[@"geofence"])
            {
                SpotzGeofence *geofence = payload[@"geofence"];
                
                // Spotz Geofence to JSON
                NSDictionary *spotzGeofence = @{@"latitude":[NSNumber numberWithFloat:geofence.latitude],@"longitude":[NSNumber numberWithFloat:geofence.longitude],@"radius":[NSNumber numberWithFloat:geofence.radius]};
                NSData* spotzGeofenceData = [NSJSONSerialization dataWithJSONObject:spotzGeofence options:0 error:nil];
                NSString* spotzGeofenceJSON = [[NSString alloc] initWithBytes:[spotzGeofenceData bytes] length:[spotzGeofenceData length] encoding:NSUTF8StringEncoding];
                
                NSString *str = [NSString stringWithFormat:@"hideData(%@,%@,%@)",spotzNameJSON,spotzGeofenceJSON,spotzDataJSON];
                
                [self.webview stringByEvaluatingJavaScriptFromString:str];
            }
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzRangingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Spotz ranging");
        
        if (note.object)
        {
            NSDictionary *payload = note.object;
            Spotz *spotz = payload[@"spotz"];
            NSNumber *acc = payload[@"accuracy"];
            
            // Spotz Data to JSON
            NSDictionary *data = spotz.data;
            NSData* spotzData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString* spotzDataJSON = [[NSString alloc] initWithBytes:[spotzData bytes] length:[spotzData length] encoding:NSUTF8StringEncoding];
            
            // Spotz Name to JSON
            NSDictionary *spotzName = @{@"id":spotz.id,@"name":spotz.name};
            NSData* spotzNameData = [NSJSONSerialization dataWithJSONObject:spotzName options:0 error:nil];
            NSString* spotzNameJSON = [[NSString alloc] initWithBytes:[spotzNameData bytes] length:[spotzNameData length] encoding:NSUTF8StringEncoding];
            
            // Beacon Accuracy to JSON
            NSDictionary *beaconAcc = @{@"acc":[NSNumber numberWithFloat:acc.floatValue]};
            NSData* beaconAccData = [NSJSONSerialization dataWithJSONObject:beaconAcc options:0 error:nil];
            NSString* beaconAccJSON = [[NSString alloc] initWithBytes:[beaconAccData bytes] length:[beaconAccData length] encoding:NSUTF8StringEncoding];
            
            
            NSString *str = [NSString stringWithFormat:@"rangeData(%@,%@,%@)",spotzNameJSON,beaconAccJSON,spotzDataJSON];

            [self.webview stringByEvaluatingJavaScriptFromString:str];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzExtensionNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Spotz Extension");
        
        NSDictionary *payload = note.object;
        
        if (payload)
        {
            // Payload String to JSON
            NSData *extensionData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
            NSString* extensionJSON = [[NSString alloc] initWithBytes:[extensionData bytes] length:[extensionData length] encoding:NSUTF8StringEncoding];
            
            NSString *str = [NSString stringWithFormat:@"extensionData(%@)",extensionJSON];
            
            [self.webview stringByEvaluatingJavaScriptFromString:str];
        }
    }];
}

// Actions available to the website
- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)inType
{
    if ([request.URL.scheme isEqualToString:@"recheck"])
    {
        [SpotzSDK forceCheckSpotz];
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
