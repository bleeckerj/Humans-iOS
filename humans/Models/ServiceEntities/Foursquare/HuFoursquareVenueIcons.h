//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HuFoursquareVenueIcon;

@interface HuFoursquareVenueIcons : NSObject



@property (strong, nonatomic) HuFoursquareVenueIcon *icon;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *pluralName;
@property (strong, nonatomic) NSString *shortName;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
