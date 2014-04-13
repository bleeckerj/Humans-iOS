//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TumblrUserInfo : NSObject
{
	NSDecimalNumber *following;
	NSString *default_post_format;
	NSString *name;
	NSDecimalNumber *likes;
	NSArray *blogs;
}

@property (strong, nonatomic) NSDecimalNumber *following;
@property (strong, nonatomic) NSString *default_post_format;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDecimalNumber *likes;
@property (strong, nonatomic) NSArray *blogs;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
