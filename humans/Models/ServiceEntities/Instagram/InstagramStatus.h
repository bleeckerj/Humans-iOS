//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuServiceStatus.h"
#import "InstagramUser.h"
#import "HuOnBehalfOf.h"

@class InstagramCaption;
@class InstagramComments;
@class InstagramImages;
@class InstagramLikes;
@class TransientInstagramUser;
@class InstagramUser;
@class InstagramLocation;

@interface InstagramStatus : NSObject <HuServiceStatus>


@property (strong, nonatomic) HuOnBehalfOf *status_on_behalf_of;
@property (strong, nonatomic) InstagramCaption *caption;
@property (strong, nonatomic) InstagramComments *comments;
@property (strong, nonatomic) NSDate *created_time;
@property (strong, nonatomic) NSString *filter;
@property (strong, nonatomic) NSString *instagram_id;
@property (strong, nonatomic) InstagramImages *images;
@property (strong, nonatomic) NSString *lastUpdated;
@property (strong, nonatomic) InstagramLikes *likes;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) TransientInstagramUser *transient_instagram_user;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) InstagramUser *user;
@property (strong, nonatomic) InstagramLocation *location;
@property (strong, nonatomic) NSString *user_has_liked;
@property (strong, nonatomic) NSDecimalNumber *version;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
- (NSString *)low_resolution_url;

@end
