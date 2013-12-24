//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramUser.h"


@implementation InstagramUser


@synthesize bio = _bio;
@synthesize full_name = _full_name;
@synthesize id = _id;
@synthesize profile_picture = _profile_picture;
@synthesize username = _username;
@synthesize website = _website;


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
	id bio_ = [dic objectForKey:@"bio"];
	if([bio_ isKindOfClass:[NSString class]])
	{
		self.bio = bio_;
	}

	id full_name_ = [dic objectForKey:@"full_name"];
	if([full_name_ isKindOfClass:[NSString class]])
	{
		self.full_name = full_name_;
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id profile_picture_ = [dic objectForKey:@"profile_picture"];
	if([profile_picture_ isKindOfClass:[NSString class]])
	{
		self.profile_picture = profile_picture_;
	}

	id username_ = [dic objectForKey:@"username"];
	if([username_ isKindOfClass:[NSString class]])
	{
		self.username = username_;
	}

	id website_ = [dic objectForKey:@"website"];
	if([website_ isKindOfClass:[NSString class]])
	{
		self.website = website_;
	}

	
}

-(NSString *)description
{
    return [self jsonString];
}

-(NSString *)jsonString
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[self bio], @"bio", [self full_name], @"full_name", [self profile_picture], @"profile_picture", [self username], @"username", [self website], @"website", nil];
}

@end
