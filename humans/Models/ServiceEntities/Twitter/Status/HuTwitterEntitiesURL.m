//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterEntitiesURL.h"


@implementation HuTwitterEntitiesURL


@synthesize expanded_url = _expanded_url;
@synthesize indices = _indices;
@synthesize display_url = _display_url;
@synthesize url = _url;


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
	id expanded_url_ = [dic objectForKey:@"expanded_url"];
	if([expanded_url_ isKindOfClass:[NSString class]])
	{
		self.expanded_url = expanded_url_;
	}

	id indices_ = [dic objectForKey:@"indices"];
	if([indices_ isKindOfClass:[NSArray class]])
	{
		self.indices = indices_;
	}

	id display_url_ = [dic objectForKey:@"display_url"];
	if([display_url_ isKindOfClass:[NSString class]])
	{
		self.display_url = display_url_;
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	
}

@end
