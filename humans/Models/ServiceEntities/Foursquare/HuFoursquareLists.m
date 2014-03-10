//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareLists.h"
#import "HuFoursquareGroup.h"


@implementation HuFoursquareLists


@synthesize groups;


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
	id groups_ = [dic objectForKey:@"groups"];
	if([groups_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in groups_)
		{
			HuFoursquareGroup *item = [[HuFoursquareGroup alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.groups = [NSArray arrayWithArray:array];
	}

	
}

@end
