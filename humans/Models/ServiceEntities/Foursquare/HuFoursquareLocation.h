//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuFoursquareLocation : NSObject



@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *cc;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSDecimalNumber *lat;
@property (strong, nonatomic) NSDecimalNumber *lng;
@property (strong, nonatomic) NSString *state;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
