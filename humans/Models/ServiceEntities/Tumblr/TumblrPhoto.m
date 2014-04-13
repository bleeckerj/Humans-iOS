//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "TumblrPhoto.h"
#import "TumblrPhotoDetail.h"


@implementation TumblrPhoto


@synthesize caption;
@synthesize alt_sizes;


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
	id caption_ = [dic objectForKey:@"caption"];
	if([caption_ isKindOfClass:[NSString class]])
	{
		self.caption = caption_;
	}

	id alt_sizes_ = [dic objectForKey:@"alt_sizes"];
	if([alt_sizes_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in alt_sizes_)
		{
			TumblrPhotoDetail *item = [[TumblrPhotoDetail alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.alt_sizes = [NSArray arrayWithArray:array];
	}

	
}

@end
