//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareTips.h"


@implementation HuFoursquareTips


@synthesize count;


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
	if([count_ isKindOfClass:[NSString class]])
	{
		self.count = count_;
	}

	
}

@end
