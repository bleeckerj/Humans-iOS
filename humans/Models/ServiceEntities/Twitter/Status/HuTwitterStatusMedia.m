//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterStatusMedia.h"


@implementation HuTwitterStatusMedia


@synthesize id = _id;
@synthesize id_str = _id_str;
@synthesize indices = _indices;
@synthesize media_url = _media_url;
@synthesize media_url_https = _media_url_https;
@synthesize url = _url;
@synthesize display_url = _display_url;
@synthesize expanded_url = _expanded_url;
@synthesize type = _type;
@synthesize sizes = _sizes;


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
	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSNumber class]])
	{
		self.id = id_;
	}

	id id_str_ = [dic objectForKey:@"id_str"];
	if([id_str_ isKindOfClass:[NSString class]])
	{
		self.id_str = id_str_;
	}

	id indices_ = [dic objectForKey:@"indices"];
	if([indices_ isKindOfClass:[NSArray class]])
	{
		self.indices = indices_;
	}

	id media_url_ = [dic objectForKey:@"media_url"];
	if([media_url_ isKindOfClass:[NSString class]])
	{
		self.media_url = media_url_;
	}

	id media_url_https_ = [dic objectForKey:@"media_url_https"];
	if([media_url_https_ isKindOfClass:[NSString class]])
	{
		self.media_url_https = media_url_https_;
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	id display_url_ = [dic objectForKey:@"display_url"];
	if([display_url_ isKindOfClass:[NSString class]])
	{
		self.display_url = display_url_;
	}

	id expanded_url_ = [dic objectForKey:@"expanded_url"];
	if([expanded_url_ isKindOfClass:[NSString class]])
	{
		self.expanded_url = expanded_url_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	id sizes_ = [dic objectForKey:@"sizes"];
	if([sizes_ isKindOfClass:[NSArray class]])
	{
		self.sizes = [[NSArray alloc] arrayByAddingObjectsFromArray:sizes_];
	}

	
}

@end
