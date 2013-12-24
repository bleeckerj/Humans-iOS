//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramLikes.h"


@implementation InstagramLikes


@synthesize count = _count;
@synthesize data = _data;


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
	id count_ = [dic objectForKey:@"count"];
	if([count_ isKindOfClass:[NSNumber class]])
	{
		self.count = count_;
	}

	id data_ = [dic objectForKey:@"data"];
//	if([data_ isKindOfClass:[NSArray class]])
//	{
//		NSMutableArray *array = [NSMutableArray array];
//		for(NSDictionary *itemDic in data_)
//		{
//			Object[0] *item = [[Object[0] alloc] initWithJSONDictionary:itemDic];
//			[array addObject:item];
//		}
//		self.data = [NSArray arrayWithArray:array];
//	}

	
}

@end
