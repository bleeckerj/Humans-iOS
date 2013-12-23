//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TransientInstagramUser.h"
#import "InstagramCounts.h"


@implementation TransientInstagramUser


@synthesize bio = _bio;
@synthesize counts = _counts;
@synthesize full_name = _full_name;
@synthesize id = _id;
@synthesize lastUpdated = _lastUpdated;
@synthesize profile_picture = _profile_picture;
@synthesize username = _username;
@synthesize version = _version;
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

	id counts_ = [dic objectForKey:@"counts"];
	if([counts_ isKindOfClass:[NSDictionary class]])
	{
		self.counts = [[InstagramCounts alloc] initWithJSONDictionary:counts_];
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

	id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
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

	id version_ = [dic objectForKey:@"version"];
	if([version_ isKindOfClass:[NSNumber class]])
	{
		self.version = version_;
	}

	id website_ = [dic objectForKey:@"website"];
	if([website_ isKindOfClass:[NSString class]])
	{
		self.website = website_;
	}

	
}

@end
