//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterBoundingBox.h"


@implementation HuTwitterBoundingBox


@synthesize coordinates = _coordinates;
@synthesize type = _type;


- (void) dealloc
{
	

}

-(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if(_coordinates) {
        [dict setObject:_coordinates forKey:@"coordinates"];
    }
    if(_type) {
        [dict setObject:_type forKey:@"type"];
    }
    return dict;
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
    if([coordinates_ isKindOfClass:[NSArray class]]) {
        self.coordinates = coordinates_;
    }
	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	
}

@end
