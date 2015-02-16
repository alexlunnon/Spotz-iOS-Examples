//
//  SpotzGeofence.h
//  SpotzSDK
//
//  Created by Melvin Artemas on 30/01/2015.
//  Copyright (c) 2015 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotzGeofence : NSObject
@property (nonatomic,strong) NSString *spotzId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float radius;

/*
 encodeWithCoder and initWithCoder have been added so you may save and load.
 
 to save:
 NSData *dataToSave = [NSKeyedArchiver archivedDataWithRootObject:myGeofences];
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 [def setObject:dataToSave forKey:@"dataKey"];
 
 to load:
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 NSData *dataToLoad = [def objectForKey:@"dataKey"];
 NSArray *myGeofences = [NSKeyedUnarchiver unarchiveObjectWithData:dataToLoad];
 
 (where myGeofences is an array filled with SpotzGeofence. you could also save a single SpotzGeofence without an array)
 */

@end
