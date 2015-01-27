//
//  LocalzViewController.m
//  LocalzProximityExample
//
//  Created by Melvin Artemas on 11/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import "LocalzViewController.h"
#import <SpotzSDK/SpotzSDK.h>

@interface LocalzViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,strong) NSDictionary *spotzData;
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
            SpotzBeacon *beacon = payload[@"beacon"];
            
            
            // Spotz Data to JSON
            NSDictionary *data = spotz.data;
            NSData* spotzData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString* spotzDataJSON = [[NSString alloc] initWithBytes:[spotzData bytes] length:[spotzData length] encoding:NSUTF8StringEncoding];
            
            // Spotz Name to JSON
            NSDictionary *spotzName = @{@"id":spotz.id,@"name":spotz.name};
            NSData* spotzNameData = [NSJSONSerialization dataWithJSONObject:spotzName options:0 error:nil];
            NSString* spotzNameJSON = [[NSString alloc] initWithBytes:[spotzNameData bytes] length:[spotzNameData length] encoding:NSUTF8StringEncoding];
            
            // Spotz Beacon to JSON
            NSDictionary *spotzBeacon = @{@"uuid":beacon.uuid,@"major":[NSNumber numberWithInt:beacon.major],@"minor":[NSNumber numberWithInt:beacon.minor]};
            NSData* spotzBeaconData = [NSJSONSerialization dataWithJSONObject:spotzBeacon options:0 error:nil];
            NSString* spotzBeaconJSON = [[NSString alloc] initWithBytes:[spotzBeaconData bytes] length:[spotzBeaconData length] encoding:NSUTF8StringEncoding];
            
            
            NSString *str = [NSString stringWithFormat:@"displayData(%@,%@,%@)",spotzNameJSON,spotzBeaconJSON,spotzDataJSON];
            
            [self.webview stringByEvaluatingJavaScriptFromString:str];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzOutsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Spotz outside");
        
        if(note.object)
        {
            NSDictionary *payload = note.object;
            Spotz *spotz = payload[@"spotz"];
            SpotzBeacon *beacon = payload[@"beacon"];
            
            // Spotz Data to JSON
            NSDictionary *data = spotz.data;
            NSData* spotzData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString* spotzDataJSON = [[NSString alloc] initWithBytes:[spotzData bytes] length:[spotzData length] encoding:NSUTF8StringEncoding];
            
            // Spotz Name to JSON
            NSDictionary *spotzName = @{@"id":spotz.id,@"name":spotz.name};
            NSData* spotzNameData = [NSJSONSerialization dataWithJSONObject:spotzName options:0 error:nil];
            NSString* spotzNameJSON = [[NSString alloc] initWithBytes:[spotzNameData bytes] length:[spotzNameData length] encoding:NSUTF8StringEncoding];
            
            // Spotz Beacon to JSON
            NSDictionary *spotzBeacon = @{@"uuid":beacon.uuid,@"major":[NSNumber numberWithInt:beacon.major],@"minor":[NSNumber numberWithInt:beacon.minor]};
            NSData* spotzBeaconData = [NSJSONSerialization dataWithJSONObject:spotzBeacon options:0 error:nil];
            NSString* spotzBeaconJSON = [[NSString alloc] initWithBytes:[spotzBeaconData bytes] length:[spotzBeaconData length] encoding:NSUTF8StringEncoding];
            
            
            NSString *str = [NSString stringWithFormat:@"hideData(%@,%@,%@)",spotzNameJSON,spotzBeaconJSON,spotzDataJSON];
            
            [self.webview stringByEvaluatingJavaScriptFromString:str];
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
            
            
            NSString *str = [NSString stringWithFormat:@"rangeData(%@,%@,%@)",spotzNameJSON,spotzDataJSON,beaconAccJSON];
            
            [self.webview stringByEvaluatingJavaScriptFromString:str];
        }
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzExtensionNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
         NSLog(@"Extension payload recieved: %@", note.object);
         
         if (note.object)
         {
             // Payload Dictionary to JSON
             NSString *payload = note.object;
             NSData* extensionPayload = [NSJSONSerialization dataWithJSONObject:@{@"payload":payload} options:0 error:nil];
             NSString* extensionJSON = [[NSString alloc] initWithBytes:[extensionPayload bytes] length:[extensionPayload length] encoding:NSUTF8StringEncoding];
             
             
             NSString *str = [NSString stringWithFormat:@"extensionData(%@)",extensionJSON];
             
             [self.webview stringByEvaluatingJavaScriptFromString:str];
         }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
