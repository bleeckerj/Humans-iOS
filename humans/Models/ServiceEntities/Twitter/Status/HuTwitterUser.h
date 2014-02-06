//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HuTwitterUserEntities;

@interface HuTwitterUser : NSObject



@property (strong, nonatomic) NSDecimalNumber *id;
@property (strong, nonatomic) NSString *id_str;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screen_name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) BOOL protected;
@property (strong, nonatomic) NSDecimalNumber *followers_count;
@property (strong, nonatomic) NSDecimalNumber *friends_count;
@property (strong, nonatomic) NSDecimalNumber *listed_count;
@property (strong, nonatomic) NSDate *created_at;
@property (strong, nonatomic) NSDecimalNumber *favourites_count;
@property (strong, nonatomic) NSDecimalNumber *utc_offset;
@property (strong, nonatomic) NSString *time_zone;
@property (assign, nonatomic) BOOL geo_enabled;
@property (assign, nonatomic) BOOL verified;
@property (strong, nonatomic) NSDecimalNumber *statuses_count;
@property (strong, nonatomic) NSString *lang;
@property (assign, nonatomic) BOOL contributors_enabled;
@property (assign, nonatomic) BOOL is_translator;
@property (strong, nonatomic) NSString *profile_background_color;
@property (strong, nonatomic) NSString *profile_background_image_url;
@property (strong, nonatomic) NSString *profile_background_image_url_https;
@property (assign, nonatomic) BOOL profile_background_tile;
@property (strong, nonatomic) NSString *profile_image_url;
@property (strong, nonatomic) NSString *profile_image_url_https;
@property (strong, nonatomic) NSString *profile_link_color;
@property (strong, nonatomic) NSString *profile_sidebar_border_color;
@property (strong, nonatomic) NSString *profile_sidebar_fill_color;
@property (strong, nonatomic) NSString *profile_text_color;
@property (assign, nonatomic) BOOL profile_use_background_image;
@property (assign, nonatomic) BOOL default_profile;
@property (assign, nonatomic) BOOL default_profile_image;
@property (assign, nonatomic) BOOL following;
@property (assign, nonatomic) BOOL follow_request_sent;
@property (assign, nonatomic) BOOL notifications;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
