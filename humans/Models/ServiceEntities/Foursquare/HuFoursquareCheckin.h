//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuServiceStatus.h"

@class HuFoursquareSource;
@class HuFoursquareVenue;
@class HuFoursquareUser;

@interface HuFoursquareCheckin : NSObject <HuServiceStatus>



@property (strong, nonatomic) NSDecimalNumber *created;
@property (strong, nonatomic) NSDecimalNumber *createdAt;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *lastUpdated;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) HuFoursquareSource *source;
@property (strong, nonatomic) NSString *timeZoneOffset;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) HuFoursquareVenue *venue;
@property (strong, nonatomic) NSDecimalNumber *version;
@property (strong, nonatomic) HuFoursquareUser *user;
- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
