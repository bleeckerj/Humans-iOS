//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFriend.h"
#import "HuOnBehalfOf.h"


@implementation HuFriend


@synthesize imageURL = _imageURL;
@synthesize largeImageURL = _largeImageURL;
@synthesize onBehalfOf = _onBehalfOf;
@synthesize service = _service;
@synthesize serviceID = _serviceID;
@synthesize username = _username;


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
	id imageURL_ = [dic objectForKey:@"imageURL"];
	if([imageURL_ isKindOfClass:[NSString class]])
	{
		self.imageURL = imageURL_;
	}

	id largeImageURL_ = [dic objectForKey:@"largeImageURL"];
	if([largeImageURL_ isKindOfClass:[NSString class]])
	{
		self.largeImageURL = largeImageURL_;
	}

	id onBehalfOf_ = [dic objectForKey:@"onBehalfOf"];
	if([onBehalfOf_ isKindOfClass:[NSDictionary class]])
	{
		self.onBehalfOf = [[HuOnBehalfOf alloc] initWithJSONDictionary:onBehalfOf_];
	}

	id service_ = [dic objectForKey:@"service"];
	if([service_ isKindOfClass:[NSString class]])
	{
		self.service = service_;
	}

	id serviceID_ = [dic objectForKey:@"serviceID"];
	if([serviceID_ isKindOfClass:[NSString class]])
	{
		self.serviceID = serviceID_;
	}

	id username_ = [dic objectForKey:@"username"];
	if([username_ isKindOfClass:[NSString class]])
	{
		self.username = username_;
	}

	
}

@end
