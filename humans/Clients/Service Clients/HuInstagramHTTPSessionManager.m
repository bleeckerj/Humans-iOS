//
//  HuInstagramHTTPSessionManager.m
//  humans
//
//  Created by Julian Bleecker on 5/25/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuInstagramHTTPSessionManager.h"

@implementation HuInstagramHTTPSessionManager
static NSString * const kInstagramAPIBaseURLString = @"https://api.instagram.com/v1/";

+ (HuInstagramHTTPSessionManager *)sharedInstagramClient {
    static HuInstagramHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HuInstagramHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kInstagramAPIBaseURLString]];
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url withAccessDictionary:(NSDictionary *)accessParameters{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    AFCompoundResponseSerializer *c = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[ [AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer] ]];
    
    [self setResponseSerializer:c];
    return self;
}

- (void)unlike:(InstagramStatus*)status
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
    
    NSDictionary *auth_stuff = [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
    NSString *access_token = [auth_stuff objectForKey:@"token_key"];
    [self unlike:[status instagram_id] withAccessToken:access_token];
    
}

- (void)unlike:(NSString *)mediaId withAccessToken:(NSString *)accessToken
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *full_path = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", mediaId, accessToken];
    
    NSDictionary *parameters = nil;//@{@"access_token": accessToken};
    
    
    [manager DELETE:full_path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        LOG_INSTAGRAM(0, @"Like Got %@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        LOG_INSTAGRAM(0, @"Like Got %@", error);
        
    }];
}

- (void)like:(InstagramStatus*)status
{
    BOOL user_has_liked = [[status user_has_liked]boolValue];
    if(user_has_liked == NO) {
    
    // it'll seem zippier if we just show this first before waiting for the "like" API call to return
    [HuAppDelegate popGoodToastNotification:@"Liked That." withColor:[UIColor Instagram]];

    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSDictionary *auth_stuff = [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
    NSString *access_token = [auth_stuff objectForKey:@"token_key"];
    [self like:[status instagram_id] withAccessToken:access_token withCompletionHandler:^(BOOL success, NSError *error) {
        //
        if(success) {
            status.user_has_liked = @"true";
            HuUserHandler *appUser = [delegate humansAppUser];
            [appUser updateInstagramMediaByID:[status instagram_id] for:[[status status_on_behalf_of]serviceUsername]];

        } else {
            [HuAppDelegate popBadToastNotification:@"Woops. Something broke" withSubnotice:[error localizedDescription]];
            NSDictionary *dimensions = @{@"key": CLUSTERED_UUID, @"error": error==nil?@"nil":[[error userInfo]description]};
            LELog *log = [LELog sharedInstance];
            [log log:dimensions];

        }
    }];
    }
}

- (void)like:(NSString *)mediaId withAccessToken:(NSString *)accessToken withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *full_path = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", mediaId, accessToken];
    
    NSDictionary *parameters = nil;//@{@"access_token": accessToken};
    
    [manager POST:full_path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        LOG_INSTAGRAM(0, @"%@", responseObject);
        if(completionHandler) {
            completionHandler(YES, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        LOG_INSTAGRAM(0, @"%@", error);
        if(completionHandler) {
            completionHandler(NO, error);
        }
        
    }];
    
}

// Retrieve status by ID
// Tell server to update status by ID
- (void)updateStatusById
{
    
}


@end
