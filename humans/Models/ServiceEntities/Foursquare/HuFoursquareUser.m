//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareUser.h"
#import "HuFoursquareContact.h"
#import "HuFoursquareLists.h"
#import "HuFoursquareUserPhoto.h"
#import "HuFoursquareTips.h"


@implementation HuFoursquareUser


@synthesize bio;
@synthesize contact;
@synthesize firstName;
@synthesize gender;
@synthesize homeCity;
@synthesize id;
@synthesize lastName;
@synthesize lastUpdated;
//@synthesize lists;
@synthesize photo;
@synthesize relationship;
@synthesize tips;
@synthesize version;


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
	id bio_ = [dic objectForKey:@"bio"];
	if([bio_ isKindOfClass:[NSString class]])
	{
		self.bio = bio_;
	}

	id contact_ = [dic objectForKey:@"contact"];
	if([contact_ isKindOfClass:[NSDictionary class]])
	{
		self.contact = [[HuFoursquareContact alloc] initWithJSONDictionary:contact_];
	}

	id firstName_ = [dic objectForKey:@"firstName"];
	if([firstName_ isKindOfClass:[NSString class]])
	{
		self.firstName = firstName_;
	}

	id gender_ = [dic objectForKey:@"gender"];
	if([gender_ isKindOfClass:[NSString class]])
	{
		self.gender = gender_;
	}

	id homeCity_ = [dic objectForKey:@"homeCity"];
	if([homeCity_ isKindOfClass:[NSString class]])
	{
		self.homeCity = homeCity_;
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id lastName_ = [dic objectForKey:@"lastName"];
	if([lastName_ isKindOfClass:[NSString class]])
	{
		self.lastName = lastName_;
	}

	id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
	}

//	id lists_ = [dic objectForKey:@"lists"];
//	if([lists_ isKindOfClass:[NSDictionary class]])
//	{
//		self.lists = [[HuFoursquareLists alloc] initWithJSONDictionary:lists_];
//	}

	id photo_ = [dic objectForKey:@"photo"];
	if([photo_ isKindOfClass:[NSDictionary class]])
	{
		self.photo = [[HuFoursquareUserPhoto alloc] initWithJSONDictionary:photo_];
	}

	id relationship_ = [dic objectForKey:@"relationship"];
	if([relationship_ isKindOfClass:[NSString class]])
	{
		self.relationship = relationship_;
	}

	id tips_ = [dic objectForKey:@"tips"];
	if([tips_ isKindOfClass:[NSDictionary class]])
	{
		self.tips = [[HuFoursquareTips alloc] initWithJSONDictionary:tips_];
	}

	id version_ = [dic objectForKey:@"version"];
	if([version_ isKindOfClass:[NSNumber class]])
	{
		self.version = version_;
	}

	
}

@end
