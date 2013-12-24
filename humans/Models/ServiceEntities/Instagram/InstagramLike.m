//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramLike.h"


@implementation InstagramLike


@synthesize full_name = _full_name;
@synthesize id = _id;
@synthesize profile_picture = _profile_picture;
@synthesize username = _username;


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

	
}

@end
