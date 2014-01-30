//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareVenueIcon.h"


@implementation HuFoursquareVenueIcon


@synthesize prefix = _prefix;
@synthesize suffix = _suffix;


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
	id prefix_ = [dic objectForKey:@"prefix"];
	if([prefix_ isKindOfClass:[NSString class]])
	{
		self.prefix = prefix_;
	}

	id suffix_ = [dic objectForKey:@"suffix"];
	if([suffix_ isKindOfClass:[NSString class]])
	{
		self.suffix = suffix_;
	}

	
}

@end
