//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuHuman.h"
#import "HuServiceUser.h"
#import "SBJsonWriter.h"

@implementation HuHuman


@synthesize humanid = _humanid;
@synthesize name = _name;
@synthesize serviceUsers = _serviceUsers;


- (void) dealloc
{
	
    
}

- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
		[self parseJSONDictionary:dic];
	}
	
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
	// PARSER
	id humanid_ = [dic objectForKey:@"humanid"];
	if([humanid_ isKindOfClass:[NSString class]])
	{
		self.humanid = humanid_;
	}
    
	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}
    
	id serviceUsers_ = [dic objectForKey:@"serviceUsers"];
	if([serviceUsers_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in serviceUsers_)
		{
			HuServiceUser *item = [[HuServiceUser alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.serviceUsers = [NSArray arrayWithArray:array];
	}
    
	
}

-(NSArray *)serviceUserProfileImages
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for(int i=0; i<self.serviceUsers.count; i++) {
        HuServiceUser *s = [self.serviceUsers objectAtIndex:i];
        if(s && [s imageURL]) {
        [result addObject:[s imageURL]];
        }
    }
    return result;
}

-(NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[self humanid],  @"humanid", [self name], @"name", [self serviceUsers], @"serviceUsers", nil];
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}


- (NSString *)description
{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *json = [writer stringWithObject:[self dictionary]];
    return json;
}

@end
