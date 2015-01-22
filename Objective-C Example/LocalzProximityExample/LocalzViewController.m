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
@property (weak, nonatomic) IBOutlet UILabel *lbBeaconDetails;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *spotzData;

@end

@implementation LocalzViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self showSpotzDetails:nil];
    [self showBeaconDetails:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzInsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.lbStatus.text = @"Spotz rocks!";
        
        if(note.object)
        {
            // the dictionary will contain a spotz object and a beacon object from inside notification
            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];
            SpotzBeacon *beacon = data[@"beacon"];
            NSLog(@"Show spotz details");
            
            NSLog(@"Enter beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid,beacon.major,beacon.minor);
            NSLog(@"Spotz id: %@ name: %@",spotz.id,spotz.name);
            
            // show the spotz and beacon data
            [self showSpotzDetails:spotz];
            [self showBeaconDetails:beacon];
        }
        else
        {
            [self showSpotzDetails:nil];
            [self showBeaconDetails:nil];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzOutsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if(note.object)
        {
            // the dictionary will contain a spotz object and a beacon object from outside notification
            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];
            SpotzBeacon *beacon = data[@"beacon"];
            
            // if we have received an outside notification from the current spot, clear the screen (if not, the screen will contain info from another spot which we want to keep there)
            if ([self.lbBeaconDetails.text isEqualToString:[NSString stringWithFormat:@"major:%i  minor:%i  serial(%@)\n%@", beacon.major, beacon.minor, beacon.serial, beacon.uuid]])
            {
                self.lbStatus.text = @"Find me spotz yo!";
                [self showSpotzDetails:nil];
                [self showBeaconDetails:nil];
            }
            
            NSLog(@"Exit beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid,beacon.major,beacon.minor);
            NSLog(@"Spotz id: %@ name: %@",spotz.id,spotz.name);
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzRangingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // beacon details are not relevant so hide clear them
        [self showBeaconDetails:nil];
        
        if (note.object)
        {
            // the dictionary will contain a spotz object and its accuracy
            NSDictionary *data = note.object;
            
            Spotz *spotz = data[@"spotz"];
            NSNumber *acc = data[@"accuracy"];
            
            NSLog(@"Show spotz ranging details");
            
            // show any spotz data
            [self showSpotzDetails:spotz];
            
            // show the accuracy of the spotz
            self.lbBeaconDetails.hidden = false;
            self.lbBeaconDetails.text = [NSString stringWithFormat:@"Accuracy: %fm", acc.floatValue];
        }
        else
        {
            self.lbBeaconDetails.hidden = true;
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
        self.lbBeaconDetails.hidden = false;
        self.lbBeaconDetails.text = [NSString stringWithFormat:@"major:%i  minor:%i  serial(%@)\n%@", beacon.major, beacon.minor, beacon.serial, beacon.uuid];
    }
    else
    {
        // hide the major, minor, serial and uuid of the beacon
        self.lbBeaconDetails.hidden = true;
    }
}


#pragma mark - Button actions

- (IBAction)btnRecheckTapped:(id)sender
{
    [SpotzSDK checkSpotz];
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
