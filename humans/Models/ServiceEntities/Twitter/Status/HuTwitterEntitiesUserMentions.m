//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterEntitiesUserMentions.h"


@implementation HuTwitterEntitiesUserMentions


@synthesize id = _id;
@synthesize name = _name;
@synthesize indices = _indices;
@synthesize screen_name = _screen_name;
@synthesize id_str = _id_str;


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
	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSNumber class]])
	{
		self.id = id_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id indices_ = [dic objectForKey:@"indices"];
	if([indices_ isKindOfClass:[NSArray class]])
	{
		self.indices = indices_;
	}

	id screen_name_ = [dic objectForKey:@"screen_name"];
	if([screen_name_ isKindOfClass:[NSString class]])
	{
		self.screen_name = screen_name_;
	}

	id id_str_ = [dic objectForKey:@"id_str"];
	if([id_str_ isKindOfClass:[NSString class]])
	{
		self.id_str = id_str_;
	}

	
}

@end
