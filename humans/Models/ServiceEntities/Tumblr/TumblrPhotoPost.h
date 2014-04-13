//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

@interface TumblrPhotoPost : NSObject
{
	NSString *blog_name;
	NSDecimalNumber *id;
	NSString *post_url;
	NSString *type;
	NSString *date;
	NSDecimalNumber *timestamp;
	NSString *format;
	NSString *reblog_key;
	NSArray *tags;
	NSDecimalNumber *note_count;
	NSString *caption;
	NSArray *photos;
}

@property (strong, nonatomic) NSString *blog_name;
@property (strong, nonatomic) NSDecimalNumber *id;
@property (strong, nonatomic) NSString *post_url;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSDecimalNumber *timestamp;
@property (strong, nonatomic) NSString *format;
@property (strong, nonatomic) NSString *reblog_key;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSDecimalNumber *note_count;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSArray *photos;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
