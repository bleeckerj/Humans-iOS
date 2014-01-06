//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

@interface HuTwitterEntitiesURL : NSObject



@property (strong, nonatomic) NSString *expanded_url;
@property (strong, nonatomic) NSArray *indices;
@property (strong, nonatomic) NSString *display_url;
@property (strong, nonatomic) NSString *url;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
