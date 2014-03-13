//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuServiceUser.h"
#import "HuOnBehalfOf.h"
#import <SBJson4Writer.h>
@implementation HuServiceUser


@synthesize id = _id;
@synthesize imageURL = _imageURL;
@synthesize lastUpdated = _lastUpdated;
@synthesize onBehalfOf = _onBehalfOf;
@synthesize serviceName = _serviceName;
@synthesize serviceUserID = _serviceUserID;
@synthesize username = _username;


- (void) dealloc
{
	

}

- (id) initWithFriend:(HuFriend *)aFriend
{
    NSDictionary *dic = @{@"id" : @"", @"lastUpdated" : @"", @"imageURL": [aFriend imageURL], @"onBehalfOf": [[aFriend onBehalfOf] dictionary], @"serviceName" : [aFriend serviceName], @"serviceUserID" : [aFriend serviceUserID], @"username": [aFriend username]};
    
    
    return [self initWithJSONDictionary:dic];
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
    //if(id_ != nil) {
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}
   // }
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
	} else
    if([onBehalfOf_ isKindOfClass:[HuOnBehalfOf class]]) {
        self.onBehalfOf = onBehalfOf_;
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

//	id serviceUsername_ = [dic objectForKey:@"serviceUsername"];
//	if([serviceUsername_ isKindOfClass:[NSString class]])
//	{
//		self.serviceUsername = serviceUsername_;
//	}
    	id username_ = [dic objectForKey:@"username"];
    	if([username_ isKindOfClass:[NSString class]])
    	{
    		self.username = username_;
    	}


}

-(NSString *)jsonString
{
    NSDictionary *dict = [self dictionary];
    NSError *error;
    
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    NSString *jsonString = [writer stringWithObject:dict];
    if ( ! jsonString ) {
        NSLog(@"Error: %@", error);
    }
    return jsonString;
}

-(NSDictionary *)dictionary {
    if(self.id == nil) {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.imageURL, @"imageURL",self.lastUpdated, @"lastUpdated",
            [self.onBehalfOf dictionary], @"onBehalfOf", self.serviceName, @"serviceName", self.serviceUserID, @"serviceUserID", self.username, @"username", nil];
    } else {
        return [NSDictionary dictionaryWithObjectsAndKeys:self.id,@"id",self.imageURL, @"imageURL",self.lastUpdated, @"lastUpdated",
                [self.onBehalfOf dictionary], @"onBehalfOf", self.serviceName, @"serviceName", self.serviceUserID, @"serviceUserID", self.username, @"username", nil];
    }
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}


@end
