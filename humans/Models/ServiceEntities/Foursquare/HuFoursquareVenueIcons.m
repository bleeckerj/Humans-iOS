//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareVenueIcons.h"
#import "HuFoursquareVenueIcon.h"


@implementation HuFoursquareVenueIcons


@synthesize icon = _icon;
@synthesize id = _id;
@synthesize name = _name;
@synthesize pluralName = _pluralName;
@synthesize shortName = _shortName;


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
	id icon_ = [dic objectForKey:@"icon"];
	if([icon_ isKindOfClass:[NSDictionary class]])
	{
		self.icon = [[HuFoursquareVenueIcon alloc] initWithJSONDictionary:icon_];
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id pluralName_ = [dic objectForKey:@"pluralName"];
	if([pluralName_ isKindOfClass:[NSString class]])
	{
		self.pluralName = pluralName_;
	}

	id shortName_ = [dic objectForKey:@"shortName"];
	if([shortName_ isKindOfClass:[NSString class]])
	{
		self.shortName = shortName_;
	}

	
}

@end
