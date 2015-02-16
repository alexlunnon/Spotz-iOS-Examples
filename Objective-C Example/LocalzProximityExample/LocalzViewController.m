//
//  LocalzViewController.m
//  LocalzProximityExample
//
//  Created by Melvin Artemas on 11/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

// Things to remember
// ------------------
//
// You cannot monitor for more than 20 regions
//  (20 regions = total beacons + total geofences)
//  per app.
// There is also a device limit which you are
//  not told about. On smaller devices (e.g.
//  iPod touch) this is 20 regions. On larger
//  devices (e.g. iPhone 6) this is 30 regions.
// BUT we use magic to avoid these limits, so
//  there may be a delay between swapping
//  inbetween Spotz groups if you don't use
//  SpotzSDK.forceCheckSpotz().
//
// Geofences are not as accurate as beacons,
//  AT BEST they have an accuracy of 5 meters.
// So it is very possible that a devices can
//  physically cross a geofences area but not
//  be picked up because the device still thinks
//  it is outside due to the low accuracy. Walking
//  around a little may help.
//
// That is all :)

#import "LocalzViewController.h"
#import <SpotzSDK/SpotzSDK.h>

@interface LocalzViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbSpotzName;
@property (weak, nonatomic) IBOutlet UILabel *lbDetails;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *foundSpotz; // all the spotz we have seen
@property (strong, nonatomic) NSMutableArray *insideRegions; // all the regions we are currently inside (can be more than 1 beacon per spot)
@property (strong, nonatomic) NSDictionary *spotzData; // the attributes of the current spot

@end

@implementation LocalzViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.foundSpotz = [NSMutableDictionary new];
    self.insideRegions = [NSMutableArray new];
    
    // Start with a clean screen
    [self updateView];
    
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
                [self addRegionWithSpotz:spotz beacon:beacon geofence:nil];
                
                NSLog(@"Entry beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
            }
            else if (data[@"geofence"])
            {
                SpotzGeofence *geofence = data[@"geofence"];
                [self addRegionWithSpotz:spotz beacon:nil geofence:geofence];
                
                NSLog(@"Entry geofence (%@) detected with latitude: %f longitude %f",spotz.name,geofence.latitude,geofence.longitude);
            }
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
                [self removeRegionsWithBeacon:beacon geofence:nil];
                
                NSLog(@"Exit beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
            }
            else if (data[@"geofence"])
            {
                SpotzGeofence *geofence = data[@"geofence"];
                [self removeRegionsWithBeacon:nil geofence:geofence];
                
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
            self.lbDetails.text = [NSString stringWithFormat:@"Accuracy: %fm", acc.floatValue];
            self.lbSpotzName.text = spotz.name;
            if (![self.spotzData isEqualToDictionary:spotz.data])
            {
                self.spotzData = spotz.data;
                [self.tableView reloadData];
            }
            
            NSLog(@"Spotz %@ accuracy %@", spotz.name, acc);
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzExtensionNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (note.object)
        {
            NSDictionary *payload = note.object;
            if (payload[@"httpGetWebhook"])
            {
                NSDictionary *httpGetWebhook = payload[@"httpGetWebhook"];
                NSLog(@"httpGetWebhook: %@", httpGetWebhook);
            }
            if (payload[@"teradataARTIM"])
            {
                NSDictionary *teradataARTIM = payload[@"teradataARTIM"];
                NSLog(@"teradataARTIM: %@", teradataARTIM);
            }
            if (payload[@"spotz"])
            {
                Spotz *spotz = payload[@"spotz"];
                NSLog(@"Extension for Spotz: %@", spotz);
            }
        }
    }];
}

- (void) addRegionWithSpotz:(Spotz *)spotz beacon:(SpotzBeacon *)beacon geofence:(SpotzGeofence *)geofence
{
    // add or update the known spotz
    
    [self.foundSpotz setObject:spotz forKey:spotz.id];
    
    // add to our currently inside regions
    if (beacon)
    {
        [self.insideRegions insertObject:beacon atIndex:0];
    }
    if (geofence)
    {
        [self.insideRegions insertObject:geofence atIndex:0];
    }
    
    [self updateView];
}

- (void) removeRegionsWithBeacon:(SpotzBeacon *)beacon geofence:(SpotzGeofence *)geofence
{
    NSMutableArray *newArray = [NSMutableArray new];
    
    // create a new array with all the same regions excluding the beacons and geofences passed in
    for (int i = 0; i < self.insideRegions.count; i++)
    {
        if ([self.insideRegions[i] isKindOfClass:[SpotzBeacon class]])
        {
            // we can use the serial here beacuse every beacon has a different serial
            SpotzBeacon *b = self.insideRegions[i];
            if (beacon.serial && ![beacon.serial isEqualToString:b.serial])
            {
                [newArray addObject:b];
            }
        }
        else if ([self.insideRegions[i] isKindOfClass:[SpotzGeofence class]])
        {
            // we can use spotzId here because each spot can ONLY have one geofence at most
            SpotzGeofence *g = self.insideRegions[i];
            if (geofence.spotzId && ![geofence.spotzId isEqualToString:g.spotzId])
            {
                [newArray addObject:g];
            }
        }
        else
        {
            // something odd has been passed in or nothing. don't update
            return;
        }
    }
    
    self.insideRegions = newArray;
    [self updateView];
}

- (void) updateView
{
    // if we're currently inside a region. otherwise clear the screen
    if (self.insideRegions.count > 0)
    {
        // check whether the last inside region object was a beacon or a geofence.
        // the list is sorted by order seen, so the first object will be the last seen
        if ([self.insideRegions.firstObject isKindOfClass:[SpotzBeacon class]])
        {
            SpotzBeacon *beacon = self.insideRegions.firstObject;
            Spotz *spotz = [self.foundSpotz objectForKey:beacon.spotzId];
            self.spotzData = spotz.data;
            
            self.lbSpotzName.text = spotz.name;
            self.lbStatus.text = @"Spotz rocks!";
            self.lbDetails.text = [NSString stringWithFormat:@"major: %i minor: %i serial(%@)\n%@", beacon.major, beacon.minor, beacon.serial, beacon.uuid];
        }
        else if ([self.insideRegions.firstObject isKindOfClass:[SpotzGeofence class]])
        {
            SpotzGeofence *geofence = self.insideRegions.firstObject;
            Spotz *spotz = [self.foundSpotz objectForKey:geofence.spotzId];
            self.spotzData = spotz.data;
            
            self.lbSpotzName.text = spotz.name;
            self.lbStatus.text = @"Spotz rocks!";
            self.lbDetails.text = [NSString stringWithFormat:@"%f, %f\nradius: %i", geofence.latitude, geofence.longitude, (int)geofence.radius];
        }
    }
    else
    {
        // clear the screen
        self.lbSpotzName.text = @"";
        self.lbStatus.text = @"";
        self.lbDetails.text = @"";
        self.spotzData = nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Button actions

- (IBAction)btnRecheckTapped:(id)sender
{
    [SpotzSDK forceCheckSpotz];
}


#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.spotzData.count > 0)
        return 1;
    else
        return 0;
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
