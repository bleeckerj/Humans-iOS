//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TwitterUser : NSObject
{
//	NSString *lastUpdated;
//	NSString *id;
//	BOOL contributors_enabled;
//	NSString *created_at;
//	BOOL default_profile;
//	BOOL default_profile_image;
//	NSString *description;
//	NSDecimalNumber *favourites_count;
//	BOOL follow_request_sent;
//	BOOL following;
//	NSDecimalNumber *followers_count;
//	NSDecimalNumber *friends_count;
//	BOOL geo_enabled;
//	NSString *id_str;
//	BOOL is_translator;
//	NSString *lang;
//	NSDecimalNumber *listed_count;
//	NSString *location;
//	NSString *name;
//	NSString *profile_image_url;
//	NSString *profile_image_url_https;
//	BOOL _protected;
//	NSString *screen_name;
//	BOOL show_all_inline_media;
//	NSDecimalNumber *statuses_count;
//	NSString *time_zone;
//	NSString *url;
//	NSDecimalNumber *utc_offset;
//	BOOL verified;
}

@property (strong, nonatomic) NSString *lastUpdated;
@property (strong, nonatomic) NSString *id;
@property (assign, nonatomic) BOOL contributors_enabled;
@property (strong, nonatomic) NSDate *created_at;
@property (assign, nonatomic) BOOL default_profile;
@property (assign, nonatomic) BOOL default_profile_image;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDecimalNumber *favourites_count;
@property (assign, nonatomic) BOOL follow_request_sent;
@property (assign, nonatomic) BOOL following;
@property (strong, nonatomic) NSDecimalNumber *followers_count;
@property (strong, nonatomic) NSDecimalNumber *friends_count;
@property (assign, nonatomic) BOOL geo_enabled;
@property (strong, nonatomic) NSString *id_str;
@property (assign, nonatomic) BOOL is_translator;
@property (strong, nonatomic) NSString *lang;
@property (strong, nonatomic) NSDecimalNumber *listed_count;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profile_image_url;
@property (strong, nonatomic) NSString *profile_image_url_https;
@property (assign, nonatomic) BOOL _protected;
@property (strong, nonatomic) NSString *screen_name;
@property (assign, nonatomic) BOOL show_all_inline_media;
@property (strong, nonatomic) NSDecimalNumber *statuses_count;
@property (strong, nonatomic) NSString *time_zone;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDecimalNumber *utc_offset;
@property (assign, nonatomic) BOOL verified;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
