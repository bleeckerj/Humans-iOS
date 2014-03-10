//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuFoursquareUserPhoto : NSObject
{
	NSString *prefix;
	NSString *suffix;
}

@property (strong, nonatomic) NSString *prefix;
@property (strong, nonatomic) NSString *suffix;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
