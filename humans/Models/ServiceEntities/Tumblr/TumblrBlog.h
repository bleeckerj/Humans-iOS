//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TumblrBlog : NSObject
{
	NSString *title;
	NSDecimalNumber *posts;
	NSString *name;
	NSString *url;
	NSDecimalNumber *updated;
	NSString *description;
	BOOL ask;
	BOOL ask_anon;
	NSDecimalNumber *likes;
}

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDecimalNumber *posts;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDecimalNumber *updated;
@property (strong, nonatomic) NSString *description;
@property (assign, nonatomic) BOOL ask;
@property (assign, nonatomic) BOOL ask_anon;
@property (strong, nonatomic) NSDecimalNumber *likes;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
