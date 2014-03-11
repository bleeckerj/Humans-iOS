//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuServiceStatus.h"
#import "defines.h"
#import <SBJson4Writer.h>

//@class _id;
@class HuFlickrDescription;

@interface HuFlickrStatus : NSObject <HuServiceStatus>



//@property (strong, nonatomic) _id *_id;
@property (strong, nonatomic) NSDecimalNumber *accuracy;
@property (strong, nonatomic) NSDecimalNumber *context;
@property (strong, nonatomic) NSNumber *created;
@property (strong, nonatomic) NSDate *datetaken;
@property (strong, nonatomic) NSDecimalNumber *datetakengranularity;
@property (strong, nonatomic) NSDecimalNumber *dateupload;
@property (strong, nonatomic) HuFlickrDescription *flickr_description;
@property (strong, nonatomic) NSString *farm;
@property (strong, nonatomic) NSDecimalNumber *height_c;
@property (strong, nonatomic) NSDecimalNumber *height_l;
@property (strong, nonatomic) NSDecimalNumber *height_m;
@property (strong, nonatomic) NSDecimalNumber *height_n;
@property (strong, nonatomic) NSDecimalNumber *height_o;
@property (strong, nonatomic) NSDecimalNumber *height_q;
@property (strong, nonatomic) NSDecimalNumber *height_s;
@property (strong, nonatomic) NSDecimalNumber *height_sq;
@property (strong, nonatomic) NSDecimalNumber *height_t;
@property (strong, nonatomic) NSDecimalNumber *height_z;
@property (strong, nonatomic) NSDecimalNumber *iconfarm;
@property (strong, nonatomic) NSDecimalNumber *iconserver;
@property (strong, nonatomic) NSString *flickr_id;
@property (strong, nonatomic) NSString *isfamily;
@property (strong, nonatomic) NSString *isfriend;
@property (strong, nonatomic) NSString *ispublic;
@property (strong, nonatomic) NSDate *lastUpdated;
@property (strong, nonatomic) NSDecimalNumber *lastupdate;
@property (strong, nonatomic) NSDecimalNumber *latitude;
@property (strong, nonatomic) NSDecimalNumber *license;
@property (strong, nonatomic) NSDecimalNumber *longitude;
@property (strong, nonatomic) NSString *machine_tags;
@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSString *media_status;
@property (strong, nonatomic) NSDecimalNumber *o_height;
@property (strong, nonatomic) NSDecimalNumber *o_width;
@property (strong, nonatomic) NSString *originalformat;
@property (strong, nonatomic) NSString *originalsecret;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *ownername;
@property (strong, nonatomic) NSString *pathalias;
@property (strong, nonatomic) NSString *secret;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) NSString *tags;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url_c;
@property (strong, nonatomic) NSString *url_l;
@property (strong, nonatomic) NSString *url_m;
@property (strong, nonatomic) NSString *url_n;
@property (strong, nonatomic) NSString *url_o;
@property (strong, nonatomic) NSString *url_q;
@property (strong, nonatomic) NSString *url_s;
@property (strong, nonatomic) NSString *url_sq;
@property (strong, nonatomic) NSString *url_t;
@property (strong, nonatomic) NSString *url_z;
@property (strong, nonatomic) NSDecimalNumber *version;
@property (strong, nonatomic) NSDecimalNumber *views;
@property (strong, nonatomic) NSDecimalNumber *width_c;
@property (strong, nonatomic) NSDecimalNumber *width_l;
@property (strong, nonatomic) NSDecimalNumber *width_m;
@property (strong, nonatomic) NSDecimalNumber *width_n;
@property (strong, nonatomic) NSDecimalNumber *width_o;
@property (strong, nonatomic) NSDecimalNumber *width_q;
@property (strong, nonatomic) NSDecimalNumber *width_s;
@property (strong, nonatomic) NSDecimalNumber *width_sq;
@property (strong, nonatomic) NSDecimalNumber *width_t;
@property (strong, nonatomic) NSDecimalNumber *width_z;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
