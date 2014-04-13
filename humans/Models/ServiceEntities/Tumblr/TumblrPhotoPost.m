//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TumblrPhotoPost.h"
#import "TumblrPhoto.h"


@implementation TumblrPhotoPost


@synthesize blog_name;
@synthesize id;
@synthesize post_url;
@synthesize type;
@synthesize date;
@synthesize timestamp;
@synthesize format;
@synthesize reblog_key;
@synthesize tags;
@synthesize note_count;
@synthesize caption;
@synthesize photos;


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

	id note_count_ = [dic objectForKey:@"note_count"];
	if([note_count_ isKindOfClass:[NSNumber class]])
	{
		self.note_count = note_count_;
	}

	id caption_ = [dic objectForKey:@"caption"];
	if([caption_ isKindOfClass:[NSString class]])
	{
		self.caption = caption_;
	}

	id photos_ = [dic objectForKey:@"photos"];
	if([photos_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in photos_)
		{
			TumblrPhoto *item = [[TumblrPhoto alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.photos = [NSArray arrayWithArray:array];
	}

	
}

@end
