//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuServices.h"

@implementation HuServices 


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

-(id)json
{
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary] options:NSJSONWritingPrettyPrinted error:&err];
    return jsonData;
}


- (BOOL)isEqual:(id)service {
    if(self == service) {
        return YES;
    }
    
    if([service isKindOfClass:[HuServices class]] == NO) {
        return NO;
    }
    
    if([self.serviceName isEqualToString:[service serviceName]] &&
       [self.serviceUserID isEqualToString:[service serviceUserID]] &&
       [self.serviceUsername isEqualToString:[service serviceUsername]]) {
        
        return YES;
    } else {
        return NO;
    }
}


- (NSUInteger)hash {
    return [self.serviceUsername hash] ^ [self.serviceUserID hash] ^ [self.serviceName hash];
}


-(NSString *)description
{
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary] options:NSJSONWritingPrettyPrinted error:&err];
    return [[NSString alloc] initWithData:[self json] encoding:NSUTF8StringEncoding];
   
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setServiceName:[self.serviceName copyWithZone:zone]];
        [copy setServiceUserID:[self.serviceUserID copyWithZone:zone]];
        [copy setServiceUsername:[self.serviceUsername copyWithZone:zone]];
        
    }
    
    return copy;
}

@end
