//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFlickrDescription.h"


@implementation HuFlickrDescription


@synthesize _content = __content;


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
	id _content_ = [dic objectForKey:@"_content"];
	if([_content_ isKindOfClass:[NSString class]])
	{
		self._content = _content_;
	}

	
}

- (NSString *)_stringRepresentation
{
    return [self description];
}

- (NSString *)description
{
    return self._content;
}

@end
