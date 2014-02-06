//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterEntitiesSymbols.h"


@implementation HuTwitterEntitiesSymbols


@synthesize text = _text;
@synthesize indices = _indices;


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
	id text_ = [dic objectForKey:@"text"];
	if([text_ isKindOfClass:[NSString class]])
	{
		self.text = text_;
	}

	id indices_ = [dic objectForKey:@"indices"];
	if([indices_ isKindOfClass:[NSArray class]])
	{
		self.indices = indices_;
	}

	
}

@end
