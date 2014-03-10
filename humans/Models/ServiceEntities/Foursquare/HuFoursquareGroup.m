//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareGroup.h"


@implementation HuFoursquareGroup


@synthesize count;
@synthesize type;


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
	id count_ = [dic objectForKey:@"count"];
	if([count_ isKindOfClass:[NSNumber class]])
	{
		self.count = count_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	
}

@end
