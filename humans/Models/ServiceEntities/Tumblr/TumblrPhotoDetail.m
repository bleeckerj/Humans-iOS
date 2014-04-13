//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TumblrPhotoDetail.h"


@implementation TumblrPhotoDetail


@synthesize width;
@synthesize height;
@synthesize url;


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
	id width_ = [dic objectForKey:@"width"];
	if([width_ isKindOfClass:[NSNumber class]])
	{
		self.width = width_;
	}

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

	
}

@end
