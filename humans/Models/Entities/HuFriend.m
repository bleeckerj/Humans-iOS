//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "defines.h"
#import "HuFriend.h"
#import "HuOnBehalfOf.h"
#import "UIImageView+WebCache.h"


@implementation HuFriend


@synthesize imageURL = _imageURL;
@synthesize largeImageURL = _largeImageURL;
@synthesize onBehalfOf = _onBehalfOf;
@synthesize serviceName = _serviceName;
@synthesize serviceUserID = _serviceUserID;
@synthesize username = _username;
@synthesize profileImage;
@synthesize lastname;
@synthesize firstname;
@synthesize fullname;
@synthesize lastUpdated;
//@synthesize largeProfileImage;
//
@synthesize serviceImageBadge;
@synthesize tinyServiceImageBadge;
@synthesize monochromeServiceImageBadge;
@synthesize monochromeTinyServiceImageBadge;
@synthesize serviceSolidColor;

//-(NSString *)fullname
//{
//    NSMutableString *result = [[NSMutableString alloc]init];
//    if(fullname == nil || [fullname length] < 1) {
//        
//        if(firstname != nil) {
//        [result appendString:firstname];
//        }
//        if(lastname != nil) {
//        [result appendString:firstname];
//        }
//    }
//    return (NSString *)result;
//        
//}

- (void) dealloc
{
	

}

- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
		[self parseJSONDictionary:dic];
	}
	
    if(self.onBehalfOf) {
        self.onBehalfOf.serviceName = self.serviceName;
    }
    
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
	// PARSER
	id imageURL_ = [dic objectForKey:@"imageURL"];
	if([imageURL_ isKindOfClass:[NSString class]])
	{
		self.imageURL = imageURL_;
	}

	id largeImageURL_ = [dic objectForKey:@"largeImageURL"];
	if([largeImageURL_ isKindOfClass:[NSString class]])
	{
		self.largeImageURL = largeImageURL_;
	}

	id onBehalfOf_ = [dic objectForKey:@"onBehalfOf"];
	if([onBehalfOf_ isKindOfClass:[NSDictionary class]])
	{
		self.onBehalfOf = [[HuOnBehalfOf alloc] initWithJSONDictionary:onBehalfOf_];
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

	id username_ = [dic objectForKey:@"username"];
	if([username_ isKindOfClass:[NSString class]])
	{
		self.username = username_;
	}

    id lastUpdated_ = [dic objectForKey:@"lastUpdated"];
	if([lastUpdated_ isKindOfClass:[NSString class]])
	{
		self.lastUpdated = lastUpdated_;
	}

    
    if(self.onBehalfOf) {
        self.onBehalfOf.serviceName = self.serviceName;
    }
	
}

-(NSString *)jsonString
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.imageURL, @"imageURL",
            self.onBehalfOf, @"onBehalfOf", self.serviceName, @"serviceName", self.serviceUserID, @"serviceUserID", self.username, @"username", self.lastUpdated, @"lastUpdated", nil];
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"username=%@ serviceName=%@ fullname=%@", self.username, self.serviceName, self.fullname];
}

- (void)getProfileImageWithCompletionHandler:(FetchImageHandler)completionHandler {
    UIImageView *imageView = [[UIImageView alloc]init];
    NSURL *url = [[NSURL alloc]initWithString:self.imageURL];
    
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        LOG_NETWORK(0, @"cacheType=%d", cacheType);
        if(error == nil) {
            self.profileImage = image;
        }
        if(completionHandler) {
            completionHandler(image, error);
        }
    }];
    
    
}

- (BOOL)isEqual:(id)object
{
    if(self == object) {
        return YES;
    }
    if(![object isKindOfClass:[HuFriend class]]) {
        return NO;
    }
    
    if([self.username isEqualToString:[object username]] &&
       [self.serviceName isEqualToString:[object serviceName]] &&
       [self.serviceUserID isEqualToString:[object serviceUserID]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
