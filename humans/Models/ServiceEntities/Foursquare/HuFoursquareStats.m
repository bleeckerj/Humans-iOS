//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareStats.h"


@implementation HuFoursquareStats


@synthesize checkinsCount = _checkinsCount;
@synthesize tipCount = _tipCount;
@synthesize usersCount = _usersCount;


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
	id checkinsCount_ = [dic objectForKey:@"checkinsCount"];
	if([checkinsCount_ isKindOfClass:[NSString class]])
	{
		self.checkinsCount = checkinsCount_;
	}

	id tipCount_ = [dic objectForKey:@"tipCount"];
	if([tipCount_ isKindOfClass:[NSString class]])
	{
		self.tipCount = tipCount_;
	}

	id usersCount_ = [dic objectForKey:@"usersCount"];
	if([usersCount_ isKindOfClass:[NSString class]])
	{
		self.usersCount = usersCount_;
	}

	
}

@end
