//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TumblrBlog.h"


@implementation TumblrBlog


@synthesize title;
@synthesize posts;
@synthesize name;
@synthesize url;
@synthesize updated;
@synthesize description;
@synthesize ask;
@synthesize ask_anon;
@synthesize likes;


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
	id title_ = [dic objectForKey:@"title"];
	if([title_ isKindOfClass:[NSString class]])
	{
		self.title = title_;
	}

	id posts_ = [dic objectForKey:@"posts"];
	if([posts_ isKindOfClass:[NSNumber class]])
	{
		self.posts = posts_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	id updated_ = [dic objectForKey:@"updated"];
	if([updated_ isKindOfClass:[NSNumber class]])
	{
		self.updated = updated_;
	}

	id description_ = [dic objectForKey:@"description"];
	if([description_ isKindOfClass:[NSString class]])
	{
		self.description = description_;
	}

	id ask_ = [dic objectForKey:@"ask"];
	if([ask_ isKindOfClass:[NSNumber class]])
	{
		self.ask = [ask_ boolValue];
	}

	id ask_anon_ = [dic objectForKey:@"ask_anon"];
	if([ask_anon_ isKindOfClass:[NSNumber class]])
	{
		self.ask_anon = [ask_anon_ boolValue];
	}

	id likes_ = [dic objectForKey:@"likes"];
	if([likes_ isKindOfClass:[NSNumber class]])
	{
		self.likes = likes_;
	}

	
}

@end
