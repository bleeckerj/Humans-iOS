//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuFlickrStatus.h"
#import "HuFlickrDescription.h"
#import <UIColor+FPBrandColor.h>


@implementation HuFlickrStatus

@synthesize hasBeenRead;
@synthesize doNotShow;
@synthesize statusText;
@synthesize statusTime;
@synthesize serviceUsername;
@synthesize serviceSolidColor;

//@synthesize _id = __id;
@synthesize accuracy = _accuracy;
@synthesize context = _context;
@synthesize created = _created;
@synthesize datetaken = _datetaken;
@synthesize datetakengranularity = _datetakengranularity;
@synthesize dateupload = _dateupload;
@synthesize flickr_description = _flickr_description;
@synthesize farm = _farm;
@synthesize height_c = _height_c;
@synthesize height_l = _height_l;
@synthesize height_m = _height_m;
@synthesize height_n = _height_n;
@synthesize height_o = _height_o;
@synthesize height_q = _height_q;
@synthesize height_s = _height_s;
@synthesize height_sq = _height_sq;
@synthesize height_t = _height_t;
@synthesize height_z = _height_z;
@synthesize iconfarm = _iconfarm;
@synthesize iconserver = _iconserver;
@synthesize flickr_id = _flickr_id;
@synthesize isfamily = _isfamily;
@synthesize isfriend = _isfriend;
@synthesize ispublic = _ispublic;
@synthesize lastUpdated = _lastUpdated;
@synthesize lastupdate = _lastupdate;
@synthesize latitude = _latitude;
@synthesize license = _license;
@synthesize longitude = _longitude;
@synthesize machine_tags = _machine_tags;
@synthesize media = _media;
@synthesize media_status = _media_status;
@synthesize o_height = _o_height;
@synthesize o_width = _o_width;
@synthesize originalformat = _originalformat;
@synthesize originalsecret = _originalsecret;
@synthesize owner = _owner;
@synthesize ownername = _ownername;
@synthesize pathalias = _pathalias;
@synthesize secret = _secret;
@synthesize server = _server;
@synthesize service = _service;
@synthesize tags = _tags;
@synthesize title = _title;
@synthesize url_c = _url_c;
@synthesize url_l = _url_l;
@synthesize url_m = _url_m;
@synthesize url_n = _url_n;
@synthesize url_o = _url_o;
@synthesize url_q = _url_q;
@synthesize url_s = _url_s;
@synthesize url_sq = _url_sq;
@synthesize url_t = _url_t;
@synthesize url_z = _url_z;
@synthesize version = _version;
@synthesize views = _views;
@synthesize width_c = _width_c;
@synthesize width_l = _width_l;
@synthesize width_m = _width_m;
@synthesize width_n = _width_n;
@synthesize width_o = _width_o;
@synthesize width_q = _width_q;
@synthesize width_s = _width_s;
@synthesize width_sq = _width_sq;
@synthesize width_t = _width_t;
@synthesize width_z = _width_z;


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
//	id _id_ = [dic objectForKey:@"_id"];
//	if([_id_ isKindOfClass:[NSNumber class]])
//	{
//		self.flickr_id = _id_;
//	}
    id status_on_behalf_of_ = [dic objectForKey:@"status_on_behalf_of"];
    if([status_on_behalf_of_ isKindOfClass:[NSDictionary class]])
    {
        self.status_on_behalf_of = [[HuOnBehalfOf alloc]initWithJSONDictionary:status_on_behalf_of_];
    }
    
    
	id accuracy_ = [dic objectForKey:@"accuracy"];
	if([accuracy_ isKindOfClass:[NSNumber class]])
	{
		self.accuracy = accuracy_;
	}

	id context_ = [dic objectForKey:@"context"];
	if([context_ isKindOfClass:[NSNumber class]])
	{
		self.context = context_;
	}

	id created_ = [dic objectForKey:@"created"];
	if([created_ isKindOfClass:[NSNumber class]])
	{
		self.created = created_;
	}

	id datetaken_ = [dic objectForKey:@"datetaken"];
	if([datetaken_ isKindOfClass:[NSString class]])
	{
		self.datetaken = datetaken_;
	}

	id datetakengranularity_ = [dic objectForKey:@"datetakengranularity"];
	if([datetakengranularity_ isKindOfClass:[NSNumber class]])
	{
		self.datetakengranularity = datetakengranularity_;
	}

	id dateupload_ = [dic objectForKey:@"dateupload"];
	if([dateupload_ isKindOfClass:[NSNumber class]])
	{
		self.dateupload = dateupload_;
	}

	id _flickr_description_ = [dic objectForKey:@"description"];
	if([_flickr_description_ isKindOfClass:[NSDictionary class]])
	{
		self.flickr_description = [[HuFlickrDescription alloc] initWithJSONDictionary:_flickr_description_];
	}

	id farm_ = [dic objectForKey:@"farm"];
	if([farm_ isKindOfClass:[NSString class]])
	{
		self.farm = farm_;
	}

	id height_c_ = [dic objectForKey:@"height_c"];
	if([height_c_ isKindOfClass:[NSNumber class]])
	{
		self.height_c = height_c_;
	}

	id height_l_ = [dic objectForKey:@"height_l"];
	if([height_l_ isKindOfClass:[NSNumber class]])
	{
		self.height_l = height_l_;
	}

	id height_m_ = [dic objectForKey:@"height_m"];
	if([height_m_ isKindOfClass:[NSNumber class]])
	{
		self.height_m = height_m_;
	}

	id height_n_ = [dic objectForKey:@"height_n"];
	if([height_n_ isKindOfClass:[NSNumber class]])
	{
		self.height_n = height_n_;
	}

	id height_o_ = [dic objectForKey:@"height_o"];
	if([height_o_ isKindOfClass:[NSNumber class]])
	{
		self.height_o = height_o_;
	}

	id height_q_ = [dic objectForKey:@"height_q"];
	if([height_q_ isKindOfClass:[NSNumber class]])
	{
		self.height_q = height_q_;
	}

	id height_s_ = [dic objectForKey:@"height_s"];
	if([height_s_ isKindOfClass:[NSNumber class]])
	{
		self.height_s = height_s_;
	}

	id height_sq_ = [dic objectForKey:@"height_sq"];
	if([height_sq_ isKindOfClass:[NSNumber class]])
	{
		self.height_sq = height_sq_;
	}

	id height_t_ = [dic objectForKey:@"height_t"];
	if([height_t_ isKindOfClass:[NSNumber class]])
	{
		self.height_t = height_t_;
	}

	id height_z_ = [dic objectForKey:@"height_z"];
	if([height_z_ isKindOfClass:[NSNumber class]])
	{
		self.height_z = height_z_;
	}

	id iconfarm_ = [dic objectForKey:@"iconfarm"];
	if([iconfarm_ isKindOfClass:[NSNumber class]])
	{
		self.iconfarm = iconfarm_;
	}

	id iconserver_ = [dic objectForKey:@"iconserver"];
	if([iconserver_ isKindOfClass:[NSNumber class]])
	{
		self.iconserver = iconserver_;
	}

	id flickr_id_ = [dic objectForKey:@"id"];
	if([flickr_id_ isKindOfClass:[NSString class]])
	{
		self.flickr_id = flickr_id_;
	}

	id isfamily_ = [dic objectForKey:@"isfamily"];
	if([isfamily_ isKindOfClass:[NSString class]])
	{
		self.isfamily = isfamily_;
	}

	id isfriend_ = [dic objectForKey:@"isfriend"];
	if([isfriend_ isKindOfClass:[NSString class]])
	{
		self.isfriend = isfriend_;
	}

	id ispublic_ = [dic objectForKey:@"ispublic"];
	if([ispublic_ isKindOfClass:[NSString class]])
	{
		self.ispublic = ispublic_;
	}

	id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
	}

	id lastupdate_ = [dic objectForKey:@"lastupdate"];
	if([lastupdate_ isKindOfClass:[NSNumber class]])
	{
		self.lastupdate = lastupdate_;
	}

	id latitude_ = [dic objectForKey:@"latitude"];
	if([latitude_ isKindOfClass:[NSNumber class]])
	{
		self.latitude = latitude_;
	}

	id license_ = [dic objectForKey:@"license"];
	if([license_ isKindOfClass:[NSNumber class]])
	{
		self.license = license_;
	}

	id longitude_ = [dic objectForKey:@"longitude"];
	if([longitude_ isKindOfClass:[NSNumber class]])
	{
		self.longitude = longitude_;
	}

	id machine_tags_ = [dic objectForKey:@"machine_tags"];
	if([machine_tags_ isKindOfClass:[NSString class]])
	{
		self.machine_tags = machine_tags_;
	}

	id media_ = [dic objectForKey:@"media"];
	if([media_ isKindOfClass:[NSString class]])
	{
		self.media = media_;
	}

	id media_status_ = [dic objectForKey:@"media_status"];
	if([media_status_ isKindOfClass:[NSString class]])
	{
		self.media_status = media_status_;
	}

	id o_height_ = [dic objectForKey:@"o_height"];
	if([o_height_ isKindOfClass:[NSNumber class]])
	{
		self.o_height = o_height_;
	}

	id o_width_ = [dic objectForKey:@"o_width"];
	if([o_width_ isKindOfClass:[NSNumber class]])
	{
		self.o_width = o_width_;
	}

	id originalformat_ = [dic objectForKey:@"originalformat"];
	if([originalformat_ isKindOfClass:[NSString class]])
	{
		self.originalformat = originalformat_;
	}

	id originalsecret_ = [dic objectForKey:@"originalsecret"];
	if([originalsecret_ isKindOfClass:[NSString class]])
	{
		self.originalsecret = originalsecret_;
	}

	id owner_ = [dic objectForKey:@"owner"];
	if([owner_ isKindOfClass:[NSString class]])
	{
		self.owner = owner_;
	}

	id ownername_ = [dic objectForKey:@"ownername"];
	if([ownername_ isKindOfClass:[NSString class]])
	{
		self.ownername = ownername_;
	}

	id pathalias_ = [dic objectForKey:@"pathalias"];
	if([pathalias_ isKindOfClass:[NSString class]])
	{
		self.pathalias = pathalias_;
	}

	id secret_ = [dic objectForKey:@"secret"];
	if([secret_ isKindOfClass:[NSString class]])
	{
		self.secret = secret_;
	}

	id server_ = [dic objectForKey:@"server"];
	if([server_ isKindOfClass:[NSString class]])
	{
		self.server = server_;
	}

	id service_ = [dic objectForKey:@"service"];
	if([service_ isKindOfClass:[NSString class]])
	{
		self.service = service_;
	}

	id tags_ = [dic objectForKey:@"tags"];
	if([tags_ isKindOfClass:[NSString class]])
	{
		self.tags = tags_;
	}

	id title_ = [dic objectForKey:@"title"];
	if([title_ isKindOfClass:[NSString class]])
	{
		self.title = title_;
	}

	id url_c_ = [dic objectForKey:@"url_c"];
	if([url_c_ isKindOfClass:[NSString class]])
	{
		self.url_c = url_c_;
	}

	id url_l_ = [dic objectForKey:@"url_l"];
	if([url_l_ isKindOfClass:[NSString class]])
	{
		self.url_l = url_l_;
	}

	id url_m_ = [dic objectForKey:@"url_m"];
	if([url_m_ isKindOfClass:[NSString class]])
	{
		self.url_m = url_m_;
	}

	id url_n_ = [dic objectForKey:@"url_n"];
	if([url_n_ isKindOfClass:[NSString class]])
	{
		self.url_n = url_n_;
	}

	id url_o_ = [dic objectForKey:@"url_o"];
	if([url_o_ isKindOfClass:[NSString class]])
	{
		self.url_o = url_o_;
	}

	id url_q_ = [dic objectForKey:@"url_q"];
	if([url_q_ isKindOfClass:[NSString class]])
	{
		self.url_q = url_q_;
	}

	id url_s_ = [dic objectForKey:@"url_s"];
	if([url_s_ isKindOfClass:[NSString class]])
	{
		self.url_s = url_s_;
	}

	id url_sq_ = [dic objectForKey:@"url_sq"];
	if([url_sq_ isKindOfClass:[NSString class]])
	{
		self.url_sq = url_sq_;
	}

	id url_t_ = [dic objectForKey:@"url_t"];
	if([url_t_ isKindOfClass:[NSString class]])
	{
		self.url_t = url_t_;
	}

	id url_z_ = [dic objectForKey:@"url_z"];
	if([url_z_ isKindOfClass:[NSString class]])
	{
		self.url_z = url_z_;
	}

	id version_ = [dic objectForKey:@"version"];
	if([version_ isKindOfClass:[NSNumber class]])
	{
		self.version = version_;
	}

	id views_ = [dic objectForKey:@"views"];
	if([views_ isKindOfClass:[NSNumber class]])
	{
		self.views = views_;
	}

	id width_c_ = [dic objectForKey:@"width_c"];
	if([width_c_ isKindOfClass:[NSNumber class]])
	{
		self.width_c = width_c_;
	}

	id width_l_ = [dic objectForKey:@"width_l"];
	if([width_l_ isKindOfClass:[NSNumber class]])
	{
		self.width_l = width_l_;
	}

	id width_m_ = [dic objectForKey:@"width_m"];
	if([width_m_ isKindOfClass:[NSNumber class]])
	{
		self.width_m = width_m_;
	}

	id width_n_ = [dic objectForKey:@"width_n"];
	if([width_n_ isKindOfClass:[NSNumber class]])
	{
		self.width_n = width_n_;
	}

	id width_o_ = [dic objectForKey:@"width_o"];
	if([width_o_ isKindOfClass:[NSNumber class]])
	{
		self.width_o = width_o_;
	}

	id width_q_ = [dic objectForKey:@"width_q"];
	if([width_q_ isKindOfClass:[NSNumber class]])
	{
		self.width_q = width_q_;
	}

	id width_s_ = [dic objectForKey:@"width_s"];
	if([width_s_ isKindOfClass:[NSNumber class]])
	{
		self.width_s = width_s_;
	}

	id width_sq_ = [dic objectForKey:@"width_sq"];
	if([width_sq_ isKindOfClass:[NSNumber class]])
	{
		self.width_sq = width_sq_;
	}

	id width_t_ = [dic objectForKey:@"width_t"];
	if([width_t_ isKindOfClass:[NSNumber class]])
	{
		self.width_t = width_t_;
	}

	id width_z_ = [dic objectForKey:@"width_z"];
	if([width_z_ isKindOfClass:[NSNumber class]])
	{
		self.width_z = width_z_;
	}

	
}

#pragma mark HuServiceStatus protocol methods
- (NSString *)statusImageURL
{
    if(self.height_c != 0) {
    
    return [self url_c];
    }
    if(self.height_l != 0) {
        return [self url_l];
    }
    if(self.height_m != 0) {
        return [self url_m];
    }
    if(self.height_n != 0) {
        return [self url_n];
    }
    if(self.height_z != 0) {
        return [self url_z];
    }
    if(self.height_q != 0) {
        return [self url_q];
        
    }
    if(self.height_s != 0) {
        return [self url_s];
    }
    return @"https://dl.dropboxusercontent.com/u/339883/GIJoeAngry.jpg";
}

- (NSString *)statusLowResImageURL
{
    if(self.height_m != 0) {
         return [self url_m];
    }
    if(self.height_n != 0) {
        return [self url_n];
    }
    if(self.height_z != 0) {
        return [self url_z];
    }
    if(self.height_q != 0) {
        return [self url_q];
        
    }
    if(self.height_s != 0) {
        return [self url_s];
    }
    return @"https://dl.dropboxusercontent.com/u/339883/BoozyBear.jpg";

   
}

- (UIColor *)serviceSolidColor
{
    return [UIColor FlickrBlue];
}

- (NSString *)serviceUsername
{
    return [self ownername];
}

- (NSTimeInterval)statusTime
{
    return [[self created]doubleValue];
}

- (NSString *)statusText
{
    return [self.flickr_description _content];
}


- (NSDate *)dateForSorting
{
    
    NSTimeInterval interval = [[self created]doubleValue];
    interval /= 1000;
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:interval];
    return result;
}

-(NSString *)tinyServiceImageBadgeName
{
    return @"flickr-peepers-color";
}


-(NSString *)serviceImageBadgeName
{
    return @"flickr-peepers-color";
}

-(NSString *)monochromeServiceImageBadgeName
{
    return @"flickr-white-large-chiclet";
}

//- (NSDictionary*) proxyForJson
//{
//    NSDictionary *result =  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"hello", @"goodbye"
//            ,
//            nil];
//    return result;
//}


//- (NSString *)description
//{
//    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
//    writer.humanReadable = YES;
//    NSString* json = [writer stringWithObject:self];
//    return json;
//}
- (NSString *)tinyMonochromeServiceImageBadgeName
{
    return @"flickr-peepers-white-tiny.png";
}

- (NSURL *)userProfileImageURL
{
    NSURL *result = nil;
    NSString *flickrBuddyIconSillyness = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", self.iconfarm, self.iconserver, self.owner];
    result = [NSURL URLWithString:flickrBuddyIconSillyness];
    return result;
}



@end
