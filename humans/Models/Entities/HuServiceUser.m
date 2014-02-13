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
@synthesize serviceName = _serviceName;
@synthesize serviceUserID = _serviceUserID;
@synthesize serviceUsername = _serviceUsername;


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

	id serviceName_ = [dic objectForKey:@"serviceName"];
	if([serviceName_ isKindOfClass:[NSString class]])
	{
		self.serviceName = serviceName_;
	}

	id serviceUserID_ = [dic objectForKey:@"serviceUserID"];
	if([serviceUserID_ isKindOfClass:[NSString class]])
	{
		self.serviceUserID = serviceUserID_;
	}

	id serviceUsername_ = [dic objectForKey:@"serviceUsername"];
	if([serviceUsername_ isKindOfClass:[NSString class]])
	{
		self.serviceUsername = serviceUsername_;
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
            self.onBehalfOf, @"onBehalfOf", self.serviceName, @"serviceName", self.serviceUserID, @"serviceUserID", self.serviceUsername, @"serviceUsername", nil];
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}


@end
