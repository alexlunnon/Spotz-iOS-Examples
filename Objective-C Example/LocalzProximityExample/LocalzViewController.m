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
@property (nonatomic,weak) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbSpotzName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *spotzData;

@end

@implementation LocalzViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self showSpotzDetails:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzInsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.lbStatus.text = @"Spotz rocks!";
        
        if(note.object)
        {
            //Spotz *spotz = note.object;

            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];
            SpotzBeacon *beacon = data[@"beacon"];
            NSLog(@"Show spotz details");
            
            NSLog(@"Enter beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid,beacon.major,beacon.minor);
            NSLog(@"Spotz id: %@ name: %@",spotz.id,spotz.name);
            
            [self showSpotzDetails:spotz];
        }
        else
            [self showSpotzDetails:nil];
        
        
        [self.tableView reloadData];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzOutsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        self.lbStatus.text = @"Find me spotz yo!";
        [self showSpotzDetails:nil];
        if(note.object)
        {
            //Spotz *spotz = note.object;

            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];
            SpotzBeacon *beacon = data[@"beacon"];
            
            NSLog(@"Exit beacon detected with UUID: %@ major: %i minor: %i",beacon.uuid,beacon.major,beacon.minor);
            NSLog(@"Spotz id: %@ name: %@",spotz.id,spotz.name);
        }
    }];
}

- (void) showSpotzDetails:(Spotz *)spotz
{
    if(spotz)
    {
        self.lbSpotzName.hidden = NO;
        self.tableView.hidden = NO;
        self.lbSpotzName.text = spotz.name;
        
        if(spotz.data.count > 0)
        {
            self.spotzData = spotz.data;
        }
    }
    else
    {
        self.lbSpotzName.hidden = YES;
        self.tableView.hidden = YES;
        self.spotzData = @[];
    }
}

#pragma mark - Button actions

- (IBAction)btnRecheckTapped:(id)sender {
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
    NSDictionary *data = [self.spotzData objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"dataCell"];
    cell.textLabel.text = data[@"key"];
    cell.detailTextLabel.text = data[@"value"];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
