//
//  LocalzViewController.m
//  LocalzProximityExample
//
//  Created by Melvin Artemas on 11/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import "LocalzViewController.h"
#import <SpotzSDK/SpotzSDK.h>

@interface LocalzViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbSpotzName;
@property (weak, nonatomic) IBOutlet UILabel *lbDetails;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *spotzData;
@property (strong, nonatomic) NSString *currentRegionId;

@end

@implementation LocalzViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Start with a clean screen
    
    [self showSpotzDetails:nil];
    [self showBeaconDetails:nil];
    
    // Set up our Notification Observers
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzInsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (note.object)
        {
            // Take out the Spotz object and its beacon
            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];
            
            if (data[@"beacon"])
            {
                SpotzBeacon *beacon = data[@"beacon"];
                [self showBeaconDetails:beacon];
                
                NSLog(@"Entry beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
            }
            
            if (data[@"geofence"])
            {
                SpotzGeofence *geofence = data[@"geofence"];
                [self showGeofenceDetails:geofence];
                
                NSLog(@"Entry geofence (%@) detected with latitude: %f longitude %f",spotz.name,geofence.latitude,geofence.longitude);
            }
            
            self.lbStatus.text = @"Spotz rocks!";
            [self showSpotzDetails:spotz];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzOutsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if(note.object)
        {
            // Take out the Spotz object and its beacon
            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];
            
            // Remove the current spot from the screen if it is the last found as well
            if (data[@"beacon"])
            {
                SpotzBeacon *beacon = data[@"beacon"];
                if (self.currentRegionId && [beacon.serial isEqualToString:self.currentRegionId])
                {
                    self.lbStatus.text = @"Find me spotz yo!";
                    [self showSpotzDetails:nil];
                    [self showBeaconDetails:nil];
                }
                
                NSLog(@"Exit beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
            }
            
            if (data[@"geofence"])
            {
                SpotzGeofence *geofence = data[@"geofence"];
                if (self.currentRegionId && [geofence.spotzId isEqualToString:self.currentRegionId])
                {
                    self.lbStatus.text = @"Find me spotz yo!";
                    [self showSpotzDetails:nil];
                    [self showGeofenceDetails:nil];
                }
                
                NSLog(@"Exit geofence (%@) detected with latitude: %f longitude %f",spotz.name,geofence.latitude,geofence.longitude);
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzRangingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (note.object)
        {
            // Take out the Spotz object and the distance
            // Also available is the rssi and the CLBeacon
            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];
            NSNumber *acc = data[@"accuracy"];
            
            // Show the accuracy of the spotz
            self.lbDetails.hidden = false;
            self.lbDetails.text = [NSString stringWithFormat:@"Accuracy: %fm", acc.floatValue];
            
            [self showSpotzDetails:spotz];
            
            NSLog(@"Spotz %@ accuracy %@", spotz.name, acc);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzExtensionNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (note.object)
        {
            NSLog(@"Extension data: %@", note.object);
        }
    }];
}

- (void) showSpotzDetails:(Spotz *)spotz
{
    if(spotz)
    {
        // show the spotz name and any attributes
        self.lbSpotzName.hidden = NO;
        self.tableView.hidden = NO;
        self.lbSpotzName.text = spotz.name;
        
        self.spotzData = spotz.data;
        [self.tableView reloadData];
    }
    else
    {
        // hide the spotz name and any attributes
        self.lbSpotzName.hidden = YES;
        self.tableView.hidden = YES;
        self.spotzData = @{};
    }
}

- (void) showBeaconDetails:(SpotzBeacon *)beacon
{
    if (beacon)
    {
        // show the major, minor, serial and uuid of the beacon
        self.lbDetails.hidden = false;
        self.lbDetails.text = [NSString stringWithFormat:@"major:%i  minor:%i  serial(%@)\n%@", beacon.major, beacon.minor, beacon.serial, beacon.uuid];
        
        self.currentRegionId = beacon.serial;
    }
    else
    {
        // hide the major, minor, serial and uuid of the beacon
        self.lbDetails.hidden = true;
        
        self.currentRegionId = nil;
    }
}

- (void) showGeofenceDetails:(SpotzGeofence *)geofence
{
    if (geofence)
    {
        // show the latitude and longitude of the geofence
        self.lbDetails.hidden = false;
        self.lbDetails.text = [NSString stringWithFormat:@"latitude: %f longitude: %f\nradius: %f", geofence.latitude, geofence.longitude, geofence.radius];
        
        self.currentRegionId = geofence.spotzId;
    }
    else
    {
        // hide the latitude and longitude of the geofence
        self.lbDetails.hidden = true;
        
        self.currentRegionId = nil;
    }
}

#pragma mark - Button actions

- (IBAction)btnRecheckTapped:(id)sender
{
    [SpotzSDK forceCheckSpotz];
}


#pragma mark - Table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spotzData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // fill each cell with a attribute
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"dataCell"];
    cell.textLabel.text = self.spotzData.allKeys[indexPath.row];
    cell.detailTextLabel.text = self.spotzData.allValues[indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
