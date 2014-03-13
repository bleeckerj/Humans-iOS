//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFoursquareCheckin.h"
#import "HuFoursquareSource.h"
#import "HuFoursquareVenue.h"
#import "HuFoursquareUser.h"
#import "HuFoursquareUserPhoto.h"
#import "defines.h"

#import <UIColor+FPBrandColor.h>


@implementation HuFoursquareCheckin


@synthesize created = _created;
@synthesize createdAt = _createdAt;
@synthesize id = _id;
@synthesize lastUpdated = _lastUpdated;
@synthesize service = _service;
@synthesize source = _source;
@synthesize timeZoneOffset = _timeZoneOffset;
@synthesize type = _type;
@synthesize user_id = _user_id;
@synthesize venue = _venue;
@synthesize version = _version;
@synthesize hasBeenRead;
@synthesize doNotShow;
@synthesize serviceUsername = _serviceUsername;
@synthesize serviceSolidColor = _serviceSolidColor;
@synthesize statusText = _statusText;

- (NSDate *)dateForSorting
{
    return [NSDate dateWithTimeIntervalSince1970:[[self createdAt]doubleValue]];
}

- (UIColor *)serviceSolidColor
{
    return [UIColor Foursquare];
}

- (NSString *)serviceImageBadgeName
{
    return @"foursquare-icon-36x36";
}

- (NSString *)tinyServiceImageBadgeName
{
    return @"foursquare-icon-16x16";
}

- (NSString *)monochromeServiceImageBadgeName
{
    return @"foursquare-icon-gray-36x36";
}

- (NSString *)tinyMonochromeServiceImageBadgeName
{
    return @"foursquare-icon-gray-16x16";
}

- (NSURL *)userProfileImageURL
{
    NSURL *result = nil;
    HuFoursquareUserPhoto *photo = [[self user]photo];
    NSString *c = [NSString stringWithFormat:@"%@original%@", [photo prefix], [photo suffix]];
    result = [NSURL URLWithString:c];
    return result;
}

- (NSString *)serviceUsername
{
    NSString *name = [self.user firstName];
    return name;
}


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
	id created_ = [dic objectForKey:@"created"];
	if([created_ isKindOfClass:[NSNumber class]])
	{
		self.created = created_;
	}

	id createdAt_ = [dic objectForKey:@"createdAt"];
	if([createdAt_ isKindOfClass:[NSNumber class]])
	{
		self.createdAt = createdAt_;
	}

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSString class]])
	{
		self.id = id_;
	}

	id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
	}

	id service_ = [dic objectForKey:@"service"];
	if([service_ isKindOfClass:[NSString class]])
	{
		self.service = service_;
	}

	id source_ = [dic objectForKey:@"source"];
	if([source_ isKindOfClass:[NSDictionary class]])
	{
		self.source = [[HuFoursquareSource alloc] initWithJSONDictionary:source_];
	}

	id timeZoneOffset_ = [dic objectForKey:@"timeZoneOffset"];
	if([timeZoneOffset_ isKindOfClass:[NSString class]])
	{
		self.timeZoneOffset = timeZoneOffset_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	id user_id_ = [dic objectForKey:@"user_id"];
	if([user_id_ isKindOfClass:[NSString class]])
	{
		self.user_id = user_id_;
	}

    id user_ = [dic objectForKey:@"user"];
	if([user_ isKindOfClass:[NSDictionary class]])
	{
		self.user = [[HuFoursquareUser alloc] initWithJSONDictionary:user_];
	}

	id venue_ = [dic objectForKey:@"venue"];
	if([venue_ isKindOfClass:[NSDictionary class]])
	{
		self.venue = [[HuFoursquareVenue alloc] initWithJSONDictionary:venue_];
	}

	id version_ = [dic objectForKey:@"version"];
	if([version_ isKindOfClass:[NSNumber class]])
	{
		self.version = version_;
	}

	
}

@end
