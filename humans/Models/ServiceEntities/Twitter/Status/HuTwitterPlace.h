//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HuTwitterAttributes;
@class HuTwitterBoundingBox;

@interface HuTwitterPlace : NSObject



@property (strong, nonatomic) HuTwitterAttributes *attributes;
@property (strong, nonatomic) HuTwitterBoundingBox *bounding_box;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *country_code;
@property (strong, nonatomic) NSString *full_name;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *place_type;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *dictionary;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
-(NSString *)jsonString;

@end
