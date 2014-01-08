//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterStatus.h"
#import "HuTwitterUser.h"
#import "HuTwitterCoordinates.h"
#import "HuTwitterPlace.h"
#import "HuTwitterStatusEntities.h"


@implementation HuTwitterStatus


@synthesize created_at = _created_at;
@synthesize tweet_id = _tweet_id;
@synthesize id_str = _id_str;
@synthesize text = _text;
@synthesize source = _source;
@synthesize truncated = _truncated;
@synthesize in_reply_to_status_id = _in_reply_to_status_id;
@synthesize in_reply_to_status_id_str = _in_reply_to_status_id_str;
@synthesize in_reply_to_user_id = _in_reply_to_user_id;
@synthesize in_reply_to_user_id_str = _in_reply_to_user_id_str;
@synthesize in_reply_to_screen_name = _in_reply_to_screen_name;
@synthesize user = _user;
@synthesize geo = _geo;
@synthesize coordinates = _coordinates;
@synthesize place = _place;
@synthesize contributors = _contributors;
@synthesize retweet_count = _retweet_count;
@synthesize favorite_count = _favorite_count;
@synthesize entities = _entities;
@synthesize favorited = _favorited;
@synthesize retweeted = _retweeted;
@synthesize possibly_sensitive = _possibly_sensitive;
@synthesize lang = _lang;

@synthesize hasBeenRead;
@synthesize doNotShow;
@synthesize serviceSolidColor;
@synthesize serviceUsername;
@synthesize statusText;
@synthesize statusTime;


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
	id created_at_ = [dic objectForKey:@"created_at"];
	if([created_at_ isKindOfClass:[NSDate class]])
	{
		self.created_at = created_at_;
	}
    
	id tweet_id_ = [dic objectForKey:@"tweet_id"];
	if([tweet_id_ isKindOfClass:[NSNumber class]])
	{
		self.tweet_id = tweet_id_;
	}
    
	id id_str_ = [dic objectForKey:@"id_str"];
	if([id_str_ isKindOfClass:[NSString class]])
	{
		self.id_str = id_str_;
	}
    
	id text_ = [dic objectForKey:@"text"];
	if([text_ isKindOfClass:[NSString class]])
	{
		self.text = text_;
	}
    
	id source_ = [dic objectForKey:@"source"];
	if([source_ isKindOfClass:[NSString class]])
	{
		self.source = source_;
	}
    
	id truncated_ = [dic objectForKey:@"truncated"];
	if([truncated_ isKindOfClass:[NSNumber class]])
	{
		self.truncated = [truncated_ boolValue];
	}
    
	id in_reply_to_status_id_ = [dic objectForKey:@"in_reply_to_status_id"];
	if([in_reply_to_status_id_ isKindOfClass:[NSNull class]])
	{
		self.in_reply_to_status_id = in_reply_to_status_id_;
	}
    
	id in_reply_to_status_id_str_ = [dic objectForKey:@"in_reply_to_status_id_str"];
	if([in_reply_to_status_id_str_ isKindOfClass:[NSNull class]])
	{
		self.in_reply_to_status_id_str = in_reply_to_status_id_str_;
	}
    
	id in_reply_to_user_id_ = [dic objectForKey:@"in_reply_to_user_id"];
	if([in_reply_to_user_id_ isKindOfClass:[NSNull class]])
	{
		self.in_reply_to_user_id = in_reply_to_user_id_;
	}
    
	id in_reply_to_user_id_str_ = [dic objectForKey:@"in_reply_to_user_id_str"];
	if([in_reply_to_user_id_str_ isKindOfClass:[NSNull class]])
	{
		self.in_reply_to_user_id_str = in_reply_to_user_id_str_;
	}
    
	id in_reply_to_screen_name_ = [dic objectForKey:@"in_reply_to_screen_name"];
	if([in_reply_to_screen_name_ isKindOfClass:[NSNull class]])
	{
		self.in_reply_to_screen_name = in_reply_to_screen_name_;
	}
    
	id user_ = [dic objectForKey:@"user"];
	if([user_ isKindOfClass:[NSDictionary class]])
	{
		self.user = [[HuTwitterUser alloc] initWithJSONDictionary:user_];
	}
    
	id geo_ = [dic objectForKey:@"geo"];
	if([geo_ isKindOfClass:[NSNull class]])
	{
		self.geo = geo_;
	}
    
	id coordinates_ = [dic objectForKey:@"coordinates"];
	if([coordinates_ isKindOfClass:[NSDictionary class]])
	{
		self.coordinates = [[HuTwitterCoordinates alloc] initWithJSONDictionary:coordinates_];
	}
    
	id place_ = [dic objectForKey:@"place"];
	if([place_ isKindOfClass:[NSDictionary class]])
	{
		self.place = [[HuTwitterPlace alloc] initWithJSONDictionary:place_];
	}
    
	id contributors_ = [dic objectForKey:@"contributors"];
	if([contributors_ isKindOfClass:[NSNull class]])
	{
		self.contributors = contributors_;
	}
    
	id retweet_count_ = [dic objectForKey:@"retweet_count"];
	if([retweet_count_ isKindOfClass:[NSNumber class]])
	{
		self.retweet_count = retweet_count_;
	}
    
	id favorite_count_ = [dic objectForKey:@"favorite_count"];
	if([favorite_count_ isKindOfClass:[NSNumber class]])
	{
		self.favorite_count = favorite_count_;
	}
    
	id entities_ = [dic objectForKey:@"entities"];
	if([entities_ isKindOfClass:[NSDictionary class]])
	{
		self.entities = [[HuTwitterStatusEntities alloc] initWithJSONDictionary:entities_];
	}
    
	id favorited_ = [dic objectForKey:@"favorited"];
	if([favorited_ isKindOfClass:[NSNumber class]])
	{
		self.favorited = [favorited_ boolValue];
	}
    
	id retweeted_ = [dic objectForKey:@"retweeted"];
	if([retweeted_ isKindOfClass:[NSNumber class]])
	{
		self.retweeted = [retweeted_ boolValue];
	}
    
	id possibly_sensitive_ = [dic objectForKey:@"possibly_sensitive"];
	if([possibly_sensitive_ isKindOfClass:[NSNumber class]])
	{
		self.possibly_sensitive = [possibly_sensitive_ boolValue];
	}
    
	id lang_ = [dic objectForKey:@"lang"];
	if([lang_ isKindOfClass:[NSString class]])
	{
		self.lang = lang_;
	}
    
	
}



#pragma mark HuServiceStatus delegate methods
- (BOOL)containsMedia {
    //TODO: redundant. HuTwitterStatus will always contain a non-nil entities, entities.media so just need to check count
    if([self entities] && [[[self entities]media] count] > 0) {
        return true;
    } else {
        return false;
    }
}

//TODO: deal with image media etc for twitter
- (NSString *)statusImageURL
{
    HuTwitterStatusMedia *first_media;
    NSString *result = nil;
    LOG_TWITTER(0, @"Checking for an image with Twitter Status %@ %@", self.tweet_id, [self entities]);
    // do we have an image?
    if([self containsMedia]) {
        // we have an array of media..
        NSArray *media = [[self entities]media];
        if([media count] > 0) {
            assert([[media objectAtIndex:0] isKindOfClass:[HuTwitterStatusMedia class]]);
            first_media = [media objectAtIndex:0];
        }
    }
    
    if(first_media) {
        if([first_media media_url] != nil) {
        result = [first_media media_url];
        }
//        if([first_media display_url] != nil) {
//            NSMutableString *str = [[NSMutableString alloc]initWithString:@"http://"];
//            [str appendString:[first_media display_url]];
//            result = str;
//        }
    }
    return result;
}

- (NSString *)statusText
{
    return [self text];
}


-(UIColor *)serviceSolidColor
{
    return [UIColor blueColor];
}

-(NSString *)serviceUsername
{
    return [self.user screen_name];
}

- (NSURL *)userProfileImageURL
{
    NSURL *result = nil;
    if(self.user && [self.user profile_image_url]) {
        result = [NSURL URLWithString:[self.user profile_image_url]];
    }
    
    return result;
}


- (NSTimeInterval)statusTime
{
    return [[self created_at]timeIntervalSince1970];
}
- (NSDate *)dateForSorting
{
    return [NSDate dateWithTimeIntervalSince1970:[self statusTime]];
}

- (NSString *)serviceImageBadgeName
{
    return @"twitter-bird-gray.png";
}
- (NSString *)monochromeServiceImageBadgeName
{
    return @"twitter-bird-white.png";
}
- (NSString *)tinyMonochromeServiceImageBadgeName
{
    return @"twitter-bird-white-tiny.png";
}
-(NSString *)tinyServiceImageBadgeName
{
    return @"twitter-bird-gray-tiny.png";
}
@end
