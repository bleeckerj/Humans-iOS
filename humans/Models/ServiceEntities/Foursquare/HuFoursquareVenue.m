//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareVenue.h"
#import "HuFoursquareVenueIcons.h"
#import "HuFoursquareContact.h"
#import "HuFoursquareLocation.h"
#import "HuFoursquareStats.h"


@implementation HuFoursquareVenue


@synthesize categories = _categories;
@synthesize contact = _contact;
@synthesize id = _id;
@synthesize location = _location;
@synthesize name = _name;
@synthesize stats = _stats;
@synthesize url = _url;
@synthesize verified = _verified;


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
	id categories_ = [dic objectForKey:@"categories"];
	if([categories_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in categories_)
		{
			HuFoursquareVenueIcons *item = [[HuFoursquareVenueIcons alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.categories = [NSArray arrayWithArray:array];
	}

	id contact_ = [dic objectForKey:@"contact"];
	if([contact_ isKindOfClass:[NSDictionary class]])
	{
		self.contact = [[HuFoursquareContact alloc] initWithJSONDictionary:contact_];
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id location_ = [dic objectForKey:@"location"];
	if([location_ isKindOfClass:[NSDictionary class]])
	{
		self.location = [[HuFoursquareLocation alloc] initWithJSONDictionary:location_];
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id stats_ = [dic objectForKey:@"stats"];
	if([stats_ isKindOfClass:[NSDictionary class]])
	{
		self.stats = [[HuFoursquareStats alloc] initWithJSONDictionary:stats_];
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	id verified_ = [dic objectForKey:@"verified"];
	if([verified_ isKindOfClass:[NSNumber class]])
	{
		self.verified = [verified_ boolValue];
	}

	
}

@end
