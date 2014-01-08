//
//  HuRestStatusHeader.m
//  humans
//
//  Created by julian on 12/24/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuRestStatusHeader.h"
#import <SBJson/SBJson.h>

@implementation HuRestStatusHeader

@synthesize count;
@synthesize human_id;
@synthesize human_name;
@synthesize page;
@synthesize pages;
@synthesize total_status;

- (NSString *)description
{
    return [self.proxyForJson JSONRepresentation];
}

- (id) proxyForJson {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            count, @"count",
            human_id, @"human_id",
            human_name, @"human_name",
            pages, @"pages",
            page, @"page",
            total_status, @"total_status",
            nil ];
}

@end
