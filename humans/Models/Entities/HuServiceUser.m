//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuServiceUser.h"
#import "HuOnBehalfOf.h"


@implementation HuServiceUser


@synthesize id = _id;
@synthesize imageURL = _imageURL;
@synthesize lastUpdated = _lastUpdated;
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
	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id imageURL_ = [dic objectForKey:@"imageURL"];
	if([imageURL_ isKindOfClass:[NSString class]])
	{
		self.imageURL = imageURL_;
	}

	id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
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

-(NSString *)jsonString
{
    NSError *writeError = nil; 
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.id,@"id",self.imageURL, @"imageURL",self.lastUpdated, @"lastUpdated",
            self.onBehalfOf, @"onBehalfOf", self.service, @"service", self.serviceID, @"serviceID", self.username, @"username", nil];
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}


@end
