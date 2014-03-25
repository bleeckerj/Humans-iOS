//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterPlace.h"
#import "HuTwitterAttributes.h"
#import "HuTwitterBoundingBox.h"


@implementation HuTwitterPlace


@synthesize attributes = _attributes;
@synthesize bounding_box = _bounding_box;
@synthesize country = _country;
@synthesize country_code = _country_code;
@synthesize full_name = _full_name;
@synthesize id = _id;
@synthesize name = _name;
@synthesize place_type = _place_type;
@synthesize url = _url;


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
	id attributes_ = [dic objectForKey:@"attributes"];
	if([attributes_ isKindOfClass:[NSDictionary class]])
	{
		self.attributes = [[HuTwitterAttributes alloc] initWithJSONDictionary:attributes_];
	}

	id bounding_box_ = [dic objectForKey:@"bounding_box"];
	if([bounding_box_ isKindOfClass:[NSDictionary class]])
	{
		self.bounding_box = [[HuTwitterBoundingBox alloc] initWithJSONDictionary:bounding_box_];
	}

	id country_ = [dic objectForKey:@"country"];
	if([country_ isKindOfClass:[NSString class]])
	{
		self.country = country_;
	}

	id country_code_ = [dic objectForKey:@"country_code"];
	if([country_code_ isKindOfClass:[NSString class]])
	{
		self.country_code = country_code_;
	}

	id full_name_ = [dic objectForKey:@"full_name"];
	if([full_name_ isKindOfClass:[NSString class]])
	{
		self.full_name = full_name_;
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}

	id place_type_ = [dic objectForKey:@"place_type"];
	if([place_type_ isKindOfClass:[NSString class]])
	{
		self.place_type = place_type_;
	}

	id url_ = [dic objectForKey:@"url"];
	if([url_ isKindOfClass:[NSString class]])
	{
		self.url = url_;
	}

	
}

@end
