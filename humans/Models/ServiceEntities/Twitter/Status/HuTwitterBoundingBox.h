//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

@interface HuTwitterBoundingBox : NSObject



@property (strong, nonatomic) NSArray *vertex;
@property (strong, nonatomic) NSString *type;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
