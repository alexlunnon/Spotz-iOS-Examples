//
//  Spotz.h
//  SpotzSDK
//
//  Created by Melvin Artemas on 24/08/2014.
//  Copyright (c) 2014 Localz Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spotz : NSObject
@property (nonatomic,strong)  NSString *id;
@property (nonatomic,strong)  NSString *name;
@property (nonatomic,strong)  NSString *tag;
@property (nonatomic,strong) NSDictionary *data;

@end
