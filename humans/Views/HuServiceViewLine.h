//
//  HuServiceViewLine.h
//  humans
//
//  Created by Julian Bleecker on 2/8/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "MGLine.h"
#import "defines.h"
#import "HuServices.h"
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import <MRProgress.h>
@class HuServiceViewLine;

@protocol HuServiceViewLineDelegate <NSObject>
@required
- (void)lineDidDelete:(HuServiceViewLine *)line;

@end

@interface HuServiceViewLine : MGLine
@property HuServices *service;
@property UIViewController <HuServiceViewLineDelegate> *delegate;

- (id)initWithService:(HuServices *)aServices;

@end