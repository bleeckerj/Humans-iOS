//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuFoursquareContact : NSObject
{
	NSString *email;
	NSString *twitter;
}

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *twitter;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
