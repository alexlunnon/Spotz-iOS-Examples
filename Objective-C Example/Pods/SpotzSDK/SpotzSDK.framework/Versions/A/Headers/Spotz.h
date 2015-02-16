//
//  Spotz.h
//  SpotzSDK
//
//  Created by Melvin Artemas on 24/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spotz : NSObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSDictionary *data;

/*
 encodeWithCoder and initWithCoder have been added so you may save and load.
 
 to save:
 NSData *dataToSave = [NSKeyedArchiver archivedDataWithRootObject:mySpotz];
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 [def setObject:dataToSave forKey:@"dataKey"];
 
 to load:
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 NSData *dataToLoad = [def objectForKey:@"dataKey"];
 NSArray *mySpotz = [NSKeyedUnarchiver unarchiveObjectWithData:dataToLoad];
 
 (where mySpotz is an array filled with Spotz. you could also save a single Spotz without an array)
*/

@end
