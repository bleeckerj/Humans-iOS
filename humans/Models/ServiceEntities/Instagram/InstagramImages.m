//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramImages.h"
#import "InstagramImage.h"
#import "InstagramImage.h"
#import "InstagramImage.h"


@implementation InstagramImages


@synthesize low_resolution = _low_resolution;
@synthesize standard_resolution = _standard_resolution;
@synthesize thumbnail = _thumbnail;


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
	id low_resolution_ = [dic objectForKey:@"low_resolution"];
	if([low_resolution_ isKindOfClass:[NSDictionary class]])
	{
		self.low_resolution = [[InstagramImage alloc] initWithJSONDictionary:low_resolution_];
	}

	id standard_resolution_ = [dic objectForKey:@"standard_resolution"];
	if([standard_resolution_ isKindOfClass:[NSDictionary class]])
	{
		self.standard_resolution = [[InstagramImage alloc] initWithJSONDictionary:standard_resolution_];
	}

	id thumbnail_ = [dic objectForKey:@"thumbnail"];
	if([thumbnail_ isKindOfClass:[NSDictionary class]])
	{
		self.thumbnail = [[InstagramImage alloc] initWithJSONDictionary:thumbnail_];
	}

	
}

@end
