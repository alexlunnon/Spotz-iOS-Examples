//
//  SpotzBeacon.h
//  SpotzSDK
//
//  Created by Melvin Artemas on 9/09/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotzBeacon : NSObject
@property (nonatomic,strong)  NSString *spotzId;
@property (nonatomic,strong)  NSString *uuid;
@property (nonatomic) int major;
@property (nonatomic) int minor;
@property (nonatomic) int radius;
@property (nonatomic,strong)  NSString *vendor;
@property (nonatomic,strong)  NSString *serial;
@end