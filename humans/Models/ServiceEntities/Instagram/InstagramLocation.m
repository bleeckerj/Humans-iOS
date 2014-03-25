//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "InstagramLocation.h"


@implementation InstagramLocation


@synthesize id;
@synthesize latitude;
@synthesize longitude;
@synthesize name;


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

	id latitude_ = [dic objectForKey:@"latitude"];
	if([latitude_ isKindOfClass:[NSString class]])
	{
		self.latitude = latitude_;
	}

	id longitude_ = [dic objectForKey:@"longitude"];
	if([longitude_ isKindOfClass:[NSString class]])
	{
		self.longitude = longitude_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	
}

-(NSString *)jsonString
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


-(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if(latitude) {
        [dict setObject:latitude forKey:@"lat"];
    }
    if(longitude) {
        [dict setObject:longitude forKey:@"lon"];
    }
    if(name) {
        [dict setObject:name forKey:@"name"];
    }
    if(id) {
        [dict setObject:id forKey:@"id"];
    }
    return dict;
}


@end
