//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuHuman.h"
#import "HuServiceUser.h"
#import "SBJsonWriter.h"
#import <AFNetworking/AFNetworking.h>

@implementation HuHuman


@synthesize humanid = _humanid;
@synthesize name = _name;
@synthesize serviceUsers = _serviceUsers;

@synthesize profile_images;

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
	id humanid_ = [dic objectForKey:@"humanid"];
	if([humanid_ isKindOfClass:[NSString class]])
	{
		self.humanid = humanid_;
	}
    
	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}
    
	id serviceUsers_ = [dic objectForKey:@"serviceUsers"];
	if([serviceUsers_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in serviceUsers_)
		{
			HuServiceUser *item = [[HuServiceUser alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.serviceUsers = [NSArray arrayWithArray:array];
	}
    
	
}


-(UIImage *)largestServiceUserProfileImage
{
    __block UIImage *result = nil;
    __block CGFloat max_area = 0;
    [profile_images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = (UIImage *)obj;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        
        if(max_area < ( width * height )) {
            max_area = width * height;
            result = image;
        }
    }];
    return result;
}

-(void)loadServiceUsersProfileImagesWithCompletionHandler:(CompletionHandler)completionHandler
{
    NSArray *image_urls = [self serviceUserProfileImageURLs];
    profile_images = [[NSMutableArray alloc]init];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
        [image_urls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            dispatch_group_enter(group);
            NSString *url_str = (NSString*)obj;
            NSURLRequest *req_1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url_str] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
            
            UIImageView *iv_tmp = [[UIImageView alloc]init];
            
            [iv_tmp setImageWithURLRequest:req_1 placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                //
                [profile_images addObject:image];
                dispatch_group_leave(group);
    
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                //
                LOG_ERROR(0, @"Failed to load %@ %@ %@", obj, request, error);
                [profile_images addObject:[UIImage imageNamed:@"angry_unicorn_tiny.png"]];
                dispatch_group_leave(group);
    
            }];
    
        }];
    
    dispatch_group_notify(group, queue, ^{
        if(completionHandler) {
            completionHandler();
        }
        
    });
}

-(NSArray *)serviceUserProfileImageURLs
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for(int i=0; i<self.serviceUsers.count; i++) {
        HuServiceUser *s = [self.serviceUsers objectAtIndex:i];
        if(s && [s imageURL]) {
            [result addObject:[s imageURL]];
        }
    }
    return result;
}

-(NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[self humanid],  @"humanid", [self name], @"name", [self serviceUsers], @"serviceUsers", nil];
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}


- (NSString *)description
{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *json = [writer stringWithObject:[self dictionary]];
    return json;
}

@end
