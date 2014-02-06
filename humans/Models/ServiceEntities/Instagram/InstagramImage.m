//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramImage.h"


@implementation InstagramImage


@synthesize height = _height;
@synthesize url = _url;
@synthesize width = _width;


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
	id height_ = [dic objectForKey:@"height"];
	if([height_ isKindOfClass:[NSNumber class]])
	{
		self.height = height_;
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	id width_ = [dic objectForKey:@"width"];
	if([width_ isKindOfClass:[NSNumber class]])
	{
		self.width = width_;
	}

	
}

@end
