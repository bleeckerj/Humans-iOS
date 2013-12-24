//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuOnBehalfOf.h"


@implementation HuOnBehalfOf

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
	id serviceName_ = [dic objectForKey:@"serviceName"];
	if([serviceName_ isKindOfClass:[NSString class]])
	{
		self.serviceName = serviceName_;
	}

	
}

-(NSString *)serviceName
{
    if(_serviceName == nil) {
        return @"";
    } else {
        return _serviceName;
    }
}

-(NSDictionary *)dictionary {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[self serviceName], @"serviceName", [self serviceUserID], @"serviceUserID", [self serviceUsername], @"serviceUsername", nil];
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}
@end
