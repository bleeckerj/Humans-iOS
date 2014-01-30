//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuUser.h"
#import "HuHuman.h"
#import "HuServices.h"

//#import "NSObject+SBJson.h"
#import "SBJson4Writer.h"
#import "SBJson4Parser.h"

@implementation HuUser


@synthesize email = _email;
@synthesize humans = _humans;
@synthesize id = _id;
@synthesize services = _services;
@synthesize username = _username;
@synthesize version = _version;


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
	id email_ = [dic objectForKey:@"email"];
	if([email_ isKindOfClass:[NSString class]])
	{
		self.email = email_;
	}

	id humans_ = [dic objectForKey:@"humans"];
	if([humans_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in humans_)
		{
			HuHuman *item = [[HuHuman alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.humans = [NSArray arrayWithArray:array];
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id services_ = [dic objectForKey:@"services"];
	if([services_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in services_)
		{
			HuServices *item = [[HuServices alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.services = [NSArray arrayWithArray:array];
	}

	id username_ = [dic objectForKey:@"username"];
	if([username_ isKindOfClass:[NSString class]])
	{
		self.username = username_;
	}

	id version_ = [dic objectForKey:@"version"];
	if([version_ isKindOfClass:[NSNumber class]])
	{
		self.version = version_;
	}

	
}

-(NSString *)email
{
    if(_email == nil) {
        return @"";
    } else {
        return _email;
    }
}



-(NSDictionary *)dictionary
{
        return [NSDictionary dictionaryWithObjectsAndKeys:[self id],  @"id", [self email], @"email", [self humans], @"humans",
                [self services], @"services", self.username, @"username", nil];
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}

@end
