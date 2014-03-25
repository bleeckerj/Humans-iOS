//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterCoordinates.h"


@implementation HuTwitterCoordinates


@synthesize coordinates = _coordinates;
@synthesize type = _type;


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
	id coordinates_ = [dic objectForKey:@"coordinates"];
	if([coordinates_ isKindOfClass:[NSArray class]])
	{
		self.coordinates = coordinates_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
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
    if(self.coordinates) {
        [dict setObject:self.coordinates forKey:@"coordinates"];
    }
    if(self.type) {
        [dict setObject:self.type forKey:@"type"];
    }
    return dict;
}


@end
