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

- (id)init {
    if(self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.serviceUsers = [[NSMutableArray alloc]init];
    self.humanid = @"";
    self.name = @"";
}

- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
        [self commonInit];
		[self parseJSONDictionary:dic];
	}
	
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
    [self commonInit];

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
		self.serviceUsers = [NSMutableArray arrayWithArray:array];
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
                LOG_ERROR(0, @"For %@ failed to load %@ %@ %@", [self name], obj, request, error);
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
    NSDictionary *result =[NSDictionary dictionaryWithObjectsAndKeys:[self humanid],  @"humanid", [self name], @"name", [self serviceUsers], @"serviceUsers", nil];
    
    return result;
}

-(NSDictionary *)proxyForJson
{
    return [self dictionary];
}


-(NSString *)jsonString
{
    return [self description];
//    NSError *writeError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dictionary options:(NSJSONWritingPrettyPrinted | NSJSONReadingMutableContainers) error:&writeError];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return jsonString;
}


- (NSString *)description
{
    NSDictionary *dict = [self dictionary];
    NSError *error;
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonString = [writer stringWithObject:dict];
    if ( ! jsonString ) {
        NSLog(@"Error: %@", error);
    }
    return jsonString;
}

@end
