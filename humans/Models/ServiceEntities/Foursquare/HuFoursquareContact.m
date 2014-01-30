//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareContact.h"


@implementation HuFoursquareContact


@synthesize formattedPhone = _formattedPhone;
@synthesize phone = _phone;


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
	id formattedPhone_ = [dic objectForKey:@"formattedPhone"];
	if([formattedPhone_ isKindOfClass:[NSString class]])
	{
		self.formattedPhone = formattedPhone_;
	}

	id phone_ = [dic objectForKey:@"phone"];
	if([phone_ isKindOfClass:[NSString class]])
	{
		self.phone = phone_;
	}

	
}

@end
