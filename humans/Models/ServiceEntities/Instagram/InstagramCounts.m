//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramCounts.h"


@implementation InstagramCounts


@synthesize followed_by = _followed_by;
@synthesize follows = _follows;
@synthesize media = _media;


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
	id followed_by_ = [dic objectForKey:@"followed_by"];
	if([followed_by_ isKindOfClass:[NSString class]])
	{
		self.followed_by = followed_by_;
	}

	id follows_ = [dic objectForKey:@"follows"];
	if([follows_ isKindOfClass:[NSString class]])
	{
		self.follows = follows_;
	}

	id media_ = [dic objectForKey:@"media"];
	if([media_ isKindOfClass:[NSString class]])
	{
		self.media = media_;
	}

	
}

@end
