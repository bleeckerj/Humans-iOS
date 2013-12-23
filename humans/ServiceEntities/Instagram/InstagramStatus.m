//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramStatus.h"
#import "InstagramCaption.h"
#import "InstagramComments.h"
#import "InstagramImages.h"
#import "InstagramLikes.h"
#import "TransientInstagramUser.h"
#import "InstagramUser.h"
#import "InstagramImage.h"


@implementation InstagramStatus


@synthesize caption = _caption;
@synthesize comments = _comments;
@synthesize created_time = _created_time;
@synthesize filter = _filter;
@synthesize instagram_id = _instagram_id;
@synthesize images = _images;
@synthesize lastUpdated = _lastUpdated;
@synthesize likes = _likes;
@synthesize link = _link;
@synthesize service = _service;
@synthesize transient_instagram_user = _transient_instagram_user;
@synthesize type = _type;
@synthesize user = _user;
@synthesize user_has_liked = _user_has_liked;
@synthesize version = _version;


- (NSString *)statusText
{
    return [self.caption text];
}


- (NSString *)low_resolution_url
{
    return [[self.images low_resolution]url];
}

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
	id caption_ = [dic objectForKey:@"caption"];
	if([caption_ isKindOfClass:[NSDictionary class]])
	{
		self.caption = [[InstagramCaption alloc] initWithJSONDictionary:caption_];
	}

	id comments_ = [dic objectForKey:@"comments"];
	if([comments_ isKindOfClass:[NSDictionary class]])
	{
		self.comments = [[InstagramComments alloc] initWithJSONDictionary:comments_];
	}

	id created_time_ = [dic objectForKey:@"created_time"];
	if([created_time_ isKindOfClass:[NSNumber class]])
	{
		self.created_time = created_time_;
	}

	id filter_ = [dic objectForKey:@"filter"];
	if([filter_ isKindOfClass:[NSString class]])
	{
		self.filter = filter_;
	}

	id _instagram_id_ = [dic objectForKey:@"instagram_id"];
	if([_instagram_id_ isKindOfClass:[NSString class]])
	{
		self.instagram_id = _instagram_id_;
	}

	id images_ = [dic objectForKey:@"images"];
	if([images_ isKindOfClass:[NSDictionary class]])
	{
		self.images = [[InstagramImages alloc] initWithJSONDictionary:images_];
	}

	id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
	}

	id likes_ = [dic objectForKey:@"likes"];
	if([likes_ isKindOfClass:[NSDictionary class]])
	{
		self.likes = [[InstagramLikes alloc] initWithJSONDictionary:likes_];
	}

	id link_ = [dic objectForKey:@"link"];
	if([link_ isKindOfClass:[NSString class]])
	{
		self.link = link_;
	}

	id service_ = [dic objectForKey:@"service"];
	if([service_ isKindOfClass:[NSString class]])
	{
		self.service = service_;
	}

	id transient_instagram_user_ = [dic objectForKey:@"transient_instagram_user"];
	if([transient_instagram_user_ isKindOfClass:[NSDictionary class]])
	{
		self.transient_instagram_user = [[TransientInstagramUser alloc] initWithJSONDictionary:transient_instagram_user_];
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	id user_ = [dic objectForKey:@"user"];
	if([user_ isKindOfClass:[NSDictionary class]])
	{
		self.user = [[InstagramUser alloc] initWithJSONDictionary:user_];
	}

	id user_has_liked_ = [dic objectForKey:@"user_has_liked"];
	if([user_has_liked_ isKindOfClass:[NSString class]])
	{
		self.user_has_liked = user_has_liked_;
	}

	id version_ = [dic objectForKey:@"version"];
	if([version_ isKindOfClass:[NSNumber class]])
	{
		self.version = version_;
	}

    
	
}
//-(NSString *)description
//{
//    return [self jsonString];
//}

-(NSString *)jsonString
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


-(NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:/*[self caption], @"caption",*//* [self comments], @"comments",*/ [self created_time], @"created_time", [self filter], @"filter", [self instagram_id], @"instagram_id", [self images], @"images", [self lastUpdated], @"lastUpdated", [self likes], @"likes", [self link], @"link", [self service], @"service", [self transient_instagram_user], @"transient_instagram_user", [self type], @"type", [self user], @"user", [self user_has_liked], @"user_has_liked", [self version], @"version", nil];
}



@end