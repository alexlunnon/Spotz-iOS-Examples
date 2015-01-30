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
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float radius;
@end
