//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TumblrPost.h"
#import "NSString.h"


@implementation TumblrPost


@synthesize blog_name;
@synthesize id;
@synthesize post_url;
@synthesize type;
@synthesize date;
@synthesize timestamp;
@synthesize state;
@synthesize format;
@synthesize reblog_key;
@synthesize tags;
@synthesize note_count;
@synthesize title;
@synthesize body;


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
	id blog_name_ = [dic objectForKey:@"blog_name"];
	if([blog_name_ isKindOfClass:[NSString class]])
	{
		self.blog_name = blog_name_;
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSNumber class]])
	{
		self.id = id_;
	}

	id post_url_ = [dic objectForKey:@"post_url"];
	if([post_url_ isKindOfClass:[NSString class]])
	{
		self.post_url = post_url_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	id date_ = [dic objectForKey:@"date"];
	if([date_ isKindOfClass:[NSString class]])
	{
		self.date = date_;
	}

	id timestamp_ = [dic objectForKey:@"timestamp"];
	if([timestamp_ isKindOfClass:[NSNumber class]])
	{
		self.timestamp = timestamp_;
	}

	id state_ = [dic objectForKey:@"state"];
	if([state_ isKindOfClass:[NSString class]])
	{
		self.state = state_;
	}

	id format_ = [dic objectForKey:@"format"];
	if([format_ isKindOfClass:[NSString class]])
	{
		self.format = format_;
	}

	id reblog_key_ = [dic objectForKey:@"reblog_key"];
	if([reblog_key_ isKindOfClass:[NSString class]])
	{
		self.reblog_key = reblog_key_;
	}

	id tags_ = [dic objectForKey:@"tags"];
	if([tags_ isKindOfClass:[NSArray class]])
	{
		self.tags = tags;
	}

	id note_count_ = [dic objectForKey:@"note_count"];
	if([note_count_ isKindOfClass:[NSNumber class]])
	{
		self.note_count = note_count_;
	}

	id title_ = [dic objectForKey:@"title"];
	if([title_ isKindOfClass:[NSString class]])
	{
		self.title = title_;
	}

	id body_ = [dic objectForKey:@"body"];
	if([body_ isKindOfClass:[NSString class]])
	{
		self.body = body_;
	}

	
}

@end
