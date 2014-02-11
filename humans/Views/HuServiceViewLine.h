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

@interface HuServiceViewLine : MGLine
@property HuServices *services;

- (id)initWithService:(HuServices *)aServices;

@end
