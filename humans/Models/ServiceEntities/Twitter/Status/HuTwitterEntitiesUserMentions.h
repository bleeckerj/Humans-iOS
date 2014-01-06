//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

@interface HuTwitterEntitiesUserMentions : NSObject



@property (strong, nonatomic) NSDecimalNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *indices;
@property (strong, nonatomic) NSString *screen_name;
@property (strong, nonatomic) NSString *id_str;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
