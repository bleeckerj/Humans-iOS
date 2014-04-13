//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TumblrUserInfo.h"


@implementation TumblrUserInfo


@synthesize following;
@synthesize default_post_format;
@synthesize name;
@synthesize likes;
@synthesize blogs;


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
	id following_ = [dic objectForKey:@"following"];
	if([following_ isKindOfClass:[NSNumber class]])
	{
		self.following = following_;
	}

	id default_post_format_ = [dic objectForKey:@"default_post_format"];
	if([default_post_format_ isKindOfClass:[NSString class]])
	{
		self.default_post_format = default_post_format_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id likes_ = [dic objectForKey:@"likes"];
	if([likes_ isKindOfClass:[NSNumber class]])
	{
		self.likes = likes_;
	}

	
}

@end
