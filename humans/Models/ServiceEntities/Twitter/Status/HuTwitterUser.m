//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterUser.h"


@implementation HuTwitterUser


@synthesize id = _id;
@synthesize id_str = _id_str;
@synthesize name = _name;
@synthesize screen_name = _screen_name;
@synthesize location = _location;
@synthesize description = _description;
@synthesize url = _url;
@synthesize protected = _protected;
@synthesize followers_count = _followers_count;
@synthesize friends_count = _friends_count;
@synthesize listed_count = _listed_count;
@synthesize created_at = _created_at;
@synthesize favourites_count = _favourites_count;
@synthesize utc_offset = _utc_offset;
@synthesize time_zone = _time_zone;
@synthesize geo_enabled = _geo_enabled;
@synthesize verified = _verified;
@synthesize statuses_count = _statuses_count;
@synthesize lang = _lang;
@synthesize contributors_enabled = _contributors_enabled;
@synthesize is_translator = _is_translator;
@synthesize profile_background_color = _profile_background_color;
@synthesize profile_background_image_url = _profile_background_image_url;
@synthesize profile_background_image_url_https = _profile_background_image_url_https;
@synthesize profile_background_tile = _profile_background_tile;
@synthesize profile_image_url = _profile_image_url;
@synthesize profile_image_url_https = _profile_image_url_https;
@synthesize profile_link_color = _profile_link_color;
@synthesize profile_sidebar_border_color = _profile_sidebar_border_color;
@synthesize profile_sidebar_fill_color = _profile_sidebar_fill_color;
@synthesize profile_text_color = _profile_text_color;
@synthesize profile_use_background_image = _profile_use_background_image;
@synthesize default_profile = _default_profile;
@synthesize default_profile_image = _default_profile_image;
@synthesize following = _following;
@synthesize follow_request_sent = _follow_request_sent;
@synthesize notifications = _notifications;


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

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id screen_name_ = [dic objectForKey:@"screen_name"];
	if([screen_name_ isKindOfClass:[NSString class]])
	{
		self.screen_name = screen_name_;
	}

	id location_ = [dic objectForKey:@"location"];
	if([location_ isKindOfClass:[NSString class]])
	{
		self.location = location_;
	}

	id description_ = [dic objectForKey:@"description"];
	if([description_ isKindOfClass:[NSString class]])
	{
		self.description = description_;
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	id protected_ = [dic objectForKey:@"protected"];
	if([protected_ isKindOfClass:[NSNumber class]])
	{
		self.protected = [protected_ boolValue];
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

	id listed_count_ = [dic objectForKey:@"listed_count"];
	if([listed_count_ isKindOfClass:[NSNumber class]])
	{
		self.listed_count = listed_count_;
	}

	id created_at_ = [dic objectForKey:@"created_at"];
	if([created_at_ isKindOfClass:[NSDate class]])
	{
		self.created_at = created_at_;
	}

	id favourites_count_ = [dic objectForKey:@"favourites_count"];
	if([favourites_count_ isKindOfClass:[NSNumber class]])
	{
		self.favourites_count = favourites_count_;
	}

	id utc_offset_ = [dic objectForKey:@"utc_offset"];
	if([utc_offset_ isKindOfClass:[NSNumber class]])
	{
		self.utc_offset = utc_offset_;
	}

	id time_zone_ = [dic objectForKey:@"time_zone"];
	if([time_zone_ isKindOfClass:[NSString class]])
	{
		self.time_zone = time_zone_;
	}

	id geo_enabled_ = [dic objectForKey:@"geo_enabled"];
	if([geo_enabled_ isKindOfClass:[NSNumber class]])
	{
		self.geo_enabled = [geo_enabled_ boolValue];
	}

	id verified_ = [dic objectForKey:@"verified"];
	if([verified_ isKindOfClass:[NSNumber class]])
	{
		self.verified = [verified_ boolValue];
	}

	id statuses_count_ = [dic objectForKey:@"statuses_count"];
	if([statuses_count_ isKindOfClass:[NSNumber class]])
	{
		self.statuses_count = statuses_count_;
	}

	id lang_ = [dic objectForKey:@"lang"];
	if([lang_ isKindOfClass:[NSString class]])
	{
		self.lang = lang_;
	}

	id contributors_enabled_ = [dic objectForKey:@"contributors_enabled"];
	if([contributors_enabled_ isKindOfClass:[NSNumber class]])
	{
		self.contributors_enabled = [contributors_enabled_ boolValue];
	}

	id is_translator_ = [dic objectForKey:@"is_translator"];
	if([is_translator_ isKindOfClass:[NSNumber class]])
	{
		self.is_translator = [is_translator_ boolValue];
	}

	id profile_background_color_ = [dic objectForKey:@"profile_background_color"];
	if([profile_background_color_ isKindOfClass:[NSString class]])
	{
		self.profile_background_color = profile_background_color_;
	}

	id profile_background_image_url_ = [dic objectForKey:@"profile_background_image_url"];
	if([profile_background_image_url_ isKindOfClass:[NSString class]])
	{
		self.profile_background_image_url = profile_background_image_url_;
	}

	id profile_background_image_url_https_ = [dic objectForKey:@"profile_background_image_url_https"];
	if([profile_background_image_url_https_ isKindOfClass:[NSString class]])
	{
		self.profile_background_image_url_https = profile_background_image_url_https_;
	}

	id profile_background_tile_ = [dic objectForKey:@"profile_background_tile"];
	if([profile_background_tile_ isKindOfClass:[NSNumber class]])
	{
		self.profile_background_tile = [profile_background_tile_ boolValue];
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

	id profile_link_color_ = [dic objectForKey:@"profile_link_color"];
	if([profile_link_color_ isKindOfClass:[NSString class]])
	{
		self.profile_link_color = profile_link_color_;
	}

	id profile_sidebar_border_color_ = [dic objectForKey:@"profile_sidebar_border_color"];
	if([profile_sidebar_border_color_ isKindOfClass:[NSString class]])
	{
		self.profile_sidebar_border_color = profile_sidebar_border_color_;
	}

	id profile_sidebar_fill_color_ = [dic objectForKey:@"profile_sidebar_fill_color"];
	if([profile_sidebar_fill_color_ isKindOfClass:[NSString class]])
	{
		self.profile_sidebar_fill_color = profile_sidebar_fill_color_;
	}

	id profile_text_color_ = [dic objectForKey:@"profile_text_color"];
	if([profile_text_color_ isKindOfClass:[NSString class]])
	{
		self.profile_text_color = profile_text_color_;
	}

	id profile_use_background_image_ = [dic objectForKey:@"profile_use_background_image"];
	if([profile_use_background_image_ isKindOfClass:[NSNumber class]])
	{
		self.profile_use_background_image = [profile_use_background_image_ boolValue];
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

	id following_ = [dic objectForKey:@"following"];
	if([following_ isKindOfClass:[NSNumber class]])
	{
		self.following = [following_ boolValue];
	}

	id follow_request_sent_ = [dic objectForKey:@"follow_request_sent"];
	if([follow_request_sent_ isKindOfClass:[NSNumber class]])
	{
		self.follow_request_sent = [follow_request_sent_ boolValue];
	}

	id notifications_ = [dic objectForKey:@"notifications"];
	if([notifications_ isKindOfClass:[NSNumber class]])
	{
		self.notifications = [notifications_ boolValue];
	}

	
}

@end
