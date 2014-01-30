//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareCheckin.h"
#import "HuFoursquareSource.h"
#import "HuFoursquareVenue.h"


@implementation HuFoursquareCheckin


@synthesize created = _created;
@synthesize createdAt = _createdAt;
@synthesize id = _id;
@synthesize lastUpdated = _lastUpdated;
@synthesize service = _service;
@synthesize source = _source;
@synthesize timeZoneOffset = _timeZoneOffset;
@synthesize type = _type;
@synthesize user_id = _user_id;
@synthesize venue = _venue;
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
	id created_ = [dic objectForKey:@"created"];
	if([created_ isKindOfClass:[NSNumber class]])
	{
		self.created = created_;
	}

	id createdAt_ = [dic objectForKey:@"createdAt"];
	if([createdAt_ isKindOfClass:[NSNumber class]])
	{
		self.createdAt = createdAt_;
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

	id service_ = [dic objectForKey:@"service"];
	if([service_ isKindOfClass:[NSString class]])
	{
		self.service = service_;
	}

	id source_ = [dic objectForKey:@"source"];
	if([source_ isKindOfClass:[NSDictionary class]])
	{
		self.source = [[HuFoursquareSource alloc] initWithJSONDictionary:source_];
	}

	id timeZoneOffset_ = [dic objectForKey:@"timeZoneOffset"];
	if([timeZoneOffset_ isKindOfClass:[NSString class]])
	{
		self.timeZoneOffset = timeZoneOffset_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	id user_id_ = [dic objectForKey:@"user_id"];
	if([user_id_ isKindOfClass:[NSString class]])
	{
		self.user_id = user_id_;
	}

	id venue_ = [dic objectForKey:@"venue"];
	if([venue_ isKindOfClass:[NSDictionary class]])
	{
		self.venue = [[HuFoursquareVenue alloc] initWithJSONDictionary:venue_];
	}

	id version_ = [dic objectForKey:@"version"];
	if([version_ isKindOfClass:[NSNumber class]])
	{
		self.version = version_;
	}

	
}

@end
