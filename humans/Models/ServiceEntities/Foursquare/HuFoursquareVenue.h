//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;
@class HuFoursquareContact;
@class HuFoursquareLocation;
@class HuFoursquareStats;

@interface HuFoursquareVenue : NSObject



@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) HuFoursquareContact *contact;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) HuFoursquareLocation *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) HuFoursquareStats *stats;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) BOOL verified;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
