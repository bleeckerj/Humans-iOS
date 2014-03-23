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


- (id) init
{
    self = [super init];
    if(self) {
    _id = @"";
        _humans = [NSMutableArray array];
    _services = [NSMutableArray array];
    _username = @"";
        _version = [NSDecimalNumber zero];
    _email = @"";
    }
    return self;
}

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
	id isAdmin_ = [dic objectForKey:@"isAdmin"];
	if([isAdmin_ isKindOfClass:[NSNumber class]])
	{
		self.isAdmin = isAdmin_;
	}
	id isSuperuser_ = [dic objectForKey:@"isSuperuser"];
	if([isSuperuser_ isKindOfClass:[NSNumber class]])
	{
		self.isSuperuser = isSuperuser_;
	}
	
}

-(Boolean)amSuperuser
{
    return [self.isSuperuser boolValue];
}

-(Boolean)amAdmin
{
    return [self.isAdmin boolValue];
}

-(NSString *)email
{
    if(_email == nil) {
        return @"";
    } else {
        return _email;
    }
}


- (HuHuman *)getHumanByID:(NSString *)humanID
{
    __block HuHuman *result = NULL;
    
    [self.humans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([[obj humanid]isEqualToString:humanID]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

-(NSString *)jsonString
{
    return [self description];
}

- (NSString *)description
{
    NSDictionary *dict = [self dictionary];
    NSError *error;
    
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    NSString *jsonString = [writer stringWithObject:self];
    if ( ! jsonString ) {
        LOG_ERROR(0, @"Error: %@", error);
    }
    return jsonString;
}


-(NSDictionary *)dictionary
{
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[self id],  @"id", [self email], @"email", [self humans], @"humans",
                [self services], @"services", self.username, @"username", self.isAdmin, @"isAdmin", self.isSuperuser, @"isSuperuser", nil];
    return result;
}



-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}

@end
