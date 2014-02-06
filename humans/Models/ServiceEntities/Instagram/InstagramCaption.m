//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramCaption.h"
#import "InstagramUser.h"

@implementation InstagramCaption


@synthesize created_time = _created_time;
@synthesize from = _from;
@synthesize id = _id;
@synthesize text = _text;


- (void) dealloc
{
	

}

- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
		[self parseJSONDictionary:dic];
	}
	
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
	// PARSER
	id created_time_ = [dic objectForKey:@"created_time"];
	if([created_time_ isKindOfClass:[NSNumber class]])
	{
		self.created_time = created_time_;
	}

	id from_ = [dic objectForKey:@"from"];
	if([from_ isKindOfClass:[NSDictionary class]])
	{
		self.from = [[InstagramUser alloc] initWithJSONDictionary:from_];
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id text_ = [dic objectForKey:@"text"];
	if([text_ isKindOfClass:[NSString class]])
	{
		self.text = text_;
	}

	
}

-(NSString *)description
{
    return [self jsonString];
}

-(NSString *)jsonString
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


-(NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[self created_time], @"created_time", [self from], @"from", [self id], @"id", [self text], @"text", nil];
}

@end
