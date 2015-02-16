//
//  SpotzBeacon.h
//  SpotzSDK
//
//  Created by Melvin Artemas on 9/09/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotzBeacon : NSObject
@property (nonatomic,strong) NSString *spotzId;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic) int major;
@property (nonatomic) int minor;
@property (nonatomic) int radius;
@property (nonatomic,strong) NSString *vendor;
@property (nonatomic,strong) NSString *serial;
@property (nonatomic) int ranging;

/*
 encodeWithCoder and initWithCoder have been added so you may save and load.
 
 to save:
 NSData *dataToSave = [NSKeyedArchiver archivedDataWithRootObject:myBeacons];
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 [def setObject:dataToSave forKey:@"dataKey"];
 
 to load:
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 NSData *dataToLoad = [def objectForKey:@"dataKey"];
 NSArray *myBeacons = [NSKeyedUnarchiver unarchiveObjectWithData:dataToLoad];
 
 (where myBeacons is an array filled with SpotzBeacon. you could also save a single SpotzBeacon without an array)
 */

@end