//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterMediaSize.h"


@implementation HuTwitterMediaSize


@synthesize w = _w;
@synthesize h = _h;
@synthesize resize = _resize;


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
	id w_ = [dic objectForKey:@"w"];
	if([w_ isKindOfClass:[NSNumber class]])
	{
		self.w = w_;
	}

	id h_ = [dic objectForKey:@"h"];
	if([h_ isKindOfClass:[NSNumber class]])
	{
		self.h = h_;
	}

	id resize_ = [dic objectForKey:@"resize"];
	if([resize_ isKindOfClass:[NSString class]])
	{
		self.resize = resize_;
	}

	
}

@end
