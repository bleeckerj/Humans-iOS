//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuServiceStatus.h"
#import "HuTwitterStatusMedia.h"
//#import "defines.h"
#import "HuOnBehalfOf.h"

@class HuTwitterUser;
@class HuTwitterCoordinates;
@class HuTwitterPlace;
@class HuTwitterStatusEntities;
@class HuTwitterStatusMedia;
@class HuOnBehalfOf;
@interface HuTwitterStatus : NSObject <HuServiceStatus>


@property (strong, nonatomic) HuOnBehalfOf *status_on_behalf_of;
@property (strong, nonatomic) NSDate *created_at;
@property (strong, nonatomic) NSDecimalNumber *created;
@property (strong, nonatomic) NSDecimalNumber *tweet_id;
@property (strong, nonatomic) NSString *id_str;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *source;
@property (assign, nonatomic) BOOL truncated;
@property (strong, nonatomic) NSString *in_reply_to_status_id;
@property (strong, nonatomic) NSString *in_reply_to_status_id_str;
@property (strong, nonatomic) NSString *in_reply_to_user_id;
@property (strong, nonatomic) NSString *in_reply_to_user_id_str;
@property (strong, nonatomic) NSString *in_reply_to_screen_name;
@property (strong, nonatomic) HuTwitterUser *user;
@property (strong, nonatomic) NSString *geo;
@property (strong, nonatomic) HuTwitterCoordinates *coordinates;
@property (strong, nonatomic) HuTwitterPlace *place;
@property (strong, nonatomic) NSString *contributors;
@property (strong, nonatomic) NSDecimalNumber *retweet_count;
@property (strong, nonatomic) NSDecimalNumber *favorite_count;
@property (strong, nonatomic) HuTwitterStatusEntities *entities;
@property (assign, nonatomic) BOOL favorited;
@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL possibly_sensitive;
@property (strong, nonatomic) NSString *lang;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
- (BOOL)containsMedia;

@end
