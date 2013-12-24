//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TwitterUser.h"


@implementation TwitterUser


@synthesize lastUpdated;
@synthesize id;


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
	id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id contributors_enabled_ = [dic objectForKey:@"contributors_enabled"];
	if([contributors_enabled_ isKindOfClass:[NSNumber class]])
	{
		self.contributors_enabled = [contributors_enabled_ boolValue];
	}

	id created_at_ = [dic objectForKey:@"created_at"];
	if([created_at_ isKindOfClass:[NSString class]])
	{
		self.created_at = created_at_;
	}

	id default_profile_ = [dic objectForKey:@"default_profile"];
	if([default_profile_ isKindOfClass:[NSNumber class]])
	{
		self.default_profile = [default_profile_ boolValue];
	}

	id default_profile_image_ = [dic objectForKey:@"default_profile_image"];
	if([default_profile_image_ isKindOfClass:[NSNumber class]])
	{
		self.default_profile_image = [default_profile_image_ boolValue];
	}

	id description_ = [dic objectForKey:@"description"];
	if([description_ isKindOfClass:[NSString class]])
	{
		self.description = description_;
	}

	id favourites_count_ = [dic objectForKey:@"favourites_count"];
	if([favourites_count_ isKindOfClass:[NSNumber class]])
	{
		self.favourites_count = favourites_count_;
	}

	id follow_request_sent_ = [dic objectForKey:@"follow_request_sent"];
	if([follow_request_sent_ isKindOfClass:[NSNumber class]])
	{
		self.follow_request_sent = [follow_request_sent_ boolValue];
	}

	id following_ = [dic objectForKey:@"following"];
	if([following_ isKindOfClass:[NSNumber class]])
	{
		self.following = [following_ boolValue];
	}

	id followers_count_ = [dic objectForKey:@"followers_count"];
	if([followers_count_ isKindOfClass:[NSNumber class]])
	{
		self.followers_count = followers_count_;
	}

	id friends_count_ = [dic objectForKey:@"friends_count"];
	if([friends_count_ isKindOfClass:[NSNumber class]])
	{
		self.friends_count = friends_count_;
	}

	id geo_enabled_ = [dic objectForKey:@"geo_enabled"];
	if([geo_enabled_ isKindOfClass:[NSNumber class]])
	{
		self.geo_enabled = [geo_enabled_ boolValue];
	}

	id id_str_ = [dic objectForKey:@"id_str"];
	if([id_str_ isKindOfClass:[NSString class]])
	{
		self.id_str = id_str_;
	}

	id is_translator_ = [dic objectForKey:@"is_translator"];
	if([is_translator_ isKindOfClass:[NSNumber class]])
	{
		self.is_translator = [is_translator_ boolValue];
	}

	id lang_ = [dic objectForKey:@"lang"];
	if([lang_ isKindOfClass:[NSString class]])
	{
		self.lang = lang_;
	}

	id listed_count_ = [dic objectForKey:@"listed_count"];
	if([listed_count_ isKindOfClass:[NSNumber class]])
	{
		self.listed_count = listed_count_;
	}

	id location_ = [dic objectForKey:@"location"];
	if([location_ isKindOfClass:[NSString class]])
	{
		self.location = location_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id profile_image_url_ = [dic objectForKey:@"profile_image_url"];
	if([profile_image_url_ isKindOfClass:[NSString class]])
	{
		self.profile_image_url = profile_image_url_;
	}

	id profile_image_url_https_ = [dic objectForKey:@"profile_image_url_https"];
	if([profile_image_url_https_ isKindOfClass:[NSString class]])
	{
		self.profile_image_url_https = profile_image_url_https_;
	}

	id _protected_ = [dic objectForKey:@"_protected"];
	if([_protected_ isKindOfClass:[NSNumber class]])
	{
		self._protected = [_protected_ boolValue];
	}

	id screen_name_ = [dic objectForKey:@"screen_name"];
	if([screen_name_ isKindOfClass:[NSString class]])
	{
		self.screen_name = screen_name_;
	}

	id show_all_inline_media_ = [dic objectForKey:@"show_all_inline_media"];
	if([show_all_inline_media_ isKindOfClass:[NSNumber class]])
	{
		self.show_all_inline_media = [show_all_inline_media_ boolValue];
	}

	id statuses_count_ = [dic objectForKey:@"statuses_count"];
	if([statuses_count_ isKindOfClass:[NSNumber class]])
	{
		self.statuses_count = statuses_count_;
	}

	id time_zone_ = [dic objectForKey:@"time_zone"];
	if([time_zone_ isKindOfClass:[NSString class]])
	{
		self.time_zone = time_zone_;
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	id utc_offset_ = [dic objectForKey:@"utc_offset"];
	if([utc_offset_ isKindOfClass:[NSNumber class]])
	{
		self.utc_offset = utc_offset_;
	}

	id verified_ = [dic objectForKey:@"verified"];
	if([verified_ isKindOfClass:[NSNumber class]])
	{
		self.verified = [verified_ boolValue];
	}

	
}

@end
