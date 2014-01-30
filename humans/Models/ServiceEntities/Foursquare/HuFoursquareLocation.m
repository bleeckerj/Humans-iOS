//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareLocation.h"


@implementation HuFoursquareLocation


@synthesize address = _address;
@synthesize cc = _cc;
@synthesize city = _city;
@synthesize country = _country;
@synthesize lat = _lat;
@synthesize lng = _lng;
@synthesize state = _state;


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
	id address_ = [dic objectForKey:@"address"];
	if([address_ isKindOfClass:[NSString class]])
	{
		self.address = address_;
	}

	id cc_ = [dic objectForKey:@"cc"];
	if([cc_ isKindOfClass:[NSString class]])
	{
		self.cc = cc_;
	}

	id city_ = [dic objectForKey:@"city"];
	if([city_ isKindOfClass:[NSString class]])
	{
		self.city = city_;
	}

	id country_ = [dic objectForKey:@"country"];
	if([country_ isKindOfClass:[NSString class]])
	{
		self.country = country_;
	}

	id lat_ = [dic objectForKey:@"lat"];
	if([lat_ isKindOfClass:[NSNumber class]])
	{
		self.lat = lat_;
	}

	id lng_ = [dic objectForKey:@"lng"];
	if([lng_ isKindOfClass:[NSNumber class]])
	{
		self.lng = lng_;
	}

	id state_ = [dic objectForKey:@"state"];
	if([state_ isKindOfClass:[NSString class]])
	{
		self.state = state_;
	}

	
}

@end
