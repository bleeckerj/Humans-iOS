//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuFoursquareGroup : NSObject
{
	NSDecimalNumber *count;
	NSString *type;
}

@property (strong, nonatomic) NSDecimalNumber *count;
@property (strong, nonatomic) NSString *type;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
