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
    //    self.requestSerializer = [AFJSONRequestSerializer serializer];
    //    [self.requestSerializer setTimeoutInterval:45.0];
    //
    //    // not proud of this..
    //    AFSecurityPolicy *sec = [[AFSecurityPolicy alloc]init];
    //    [sec setSSLPinningMode:AFSSLPinningModeNone];
    //    [sec setValidatesCertificateChain:NO];
    //    [sec setAllowInvalidCertificates:YES];
    //    [self setSecurityPolicy:sec];
    
    
    return self;
}

- (void)unlike:(InstagramStatus*)status
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
    
//    [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of] with:^(id data, BOOL success, NSError *error) {
//        //
//    }];
    
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
        LOG_INSTAGRAM(0, @"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        LOG_INSTAGRAM(0, @"%@", error);
        
    }];
    
    
}

- (void)like:(InstagramStatus*)status
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSDictionary *auth_stuff = [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
    NSString *access_token = [auth_stuff objectForKey:@"token_key"];
    [self like:[status instagram_id] withAccessToken:access_token];
    
}

- (void)like:(NSString *)mediaId withAccessToken:(NSString *)accessToken
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *full_path = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", mediaId, accessToken];
    
    NSDictionary *parameters = nil;//@{@"access_token": accessToken};
    
    // UNLIKE??
    /**
     [manager DELETE:full_path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
     //
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
     //
     }];
     */
    
    [manager POST:full_path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        LOG_INSTAGRAM(0, @"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        LOG_INSTAGRAM(0, @"%@", error);
        
    }];
    
    
    //    NSString *path = [NSString stringWithFormat:@"/media/%@/likes?access_token=%@", mediaId, accessToken];
    //
    //    [self POST:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    //        LOG_INSTAGRAM(0, @"%@", responseObject);
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        LOG_ERROR(0, @"Error %@", error);
    //    }];
    
}

@end
