//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

@interface TumblrPhoto : NSObject
{
	NSString *caption;
	NSArray *alt_sizes;
}

@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSArray *alt_sizes;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
