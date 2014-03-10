//
//  HuHumansHTTPClient.m
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuHumansHTTPSessionManager.h"

@implementation HuHumansHTTPSessionManager


static NSString * const kHumansLocalDevBaseURLString = @"https://localhost:8443/";
static NSString * const kHumansProdBaseURLString = @"https://humans.nearfuturelaboratory.com:8443/";



+ (HuHumansHTTPSessionManager *)sharedDevClient {
    static HuHumansHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HuHumansHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kHumansLocalDevBaseURLString]];
       

    });
    
    return _sharedClient;
}

+ (HuHumansHTTPSessionManager *)sharedProdClient {
    static HuHumansHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HuHumansHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kHumansProdBaseURLString]];
        
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.requestSerializer setTimeoutInterval:30.0];
    
    // not proud of this..
    AFSecurityPolicy *sec = [[AFSecurityPolicy alloc]init];
    [sec setSSLPinningMode:AFSSLPinningModeNone];
    [sec setValidatesCertificateChain:NO];
    [sec setAllowInvalidCertificates:YES];
    [self setSecurityPolicy:sec];

//    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    
//    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//    [self setDefaultHeader:@"Accept" value:@"application/json"];
//    [self setAllowsInvalidSSLCertificate:YES];
    
    return self;
}

- (void)getStatusCountForHuman:(HuHuman *)human after:(NSTimeInterval)timestamp withCompletionHandler:(CompletionHandlerWithData)completionHandler {
    
    NSNumber *time = [NSNumber numberWithLong:timestamp];
    
    NSString *path = [NSString stringWithFormat:@"/status/count/%@/after/%@", [human humanid], [time stringValue]];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        LOG_TODO(0, @"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
    [self setDataTaskDidReceiveDataBlock:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
        //
        LOG_NETWORK(0, @"%@", data);
    }];
    
}

- (void)userAddServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withProgress:(NSProgress *__autoreleasing *)progress withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSString *URLString = [NSString stringWithFormat:@"/rest/human/%@/add/serviceuser", [aHuman humanid]];

    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:nil error:nil];
    NSData *data = [[aServiceUser jsonString]dataUsingEncoding:NSUTF8StringEncoding];
    data = [data subdataWithRange:NSMakeRange(0, [data length]-1)];
    [self uploadTaskWithRequest:request fromData:data progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if(completionHandler) {
            if(error == nil) {
                completionHandler(responseObject, YES, error);
            } else {
                completionHandler(responseObject, NO, error);
            }
            
        }
    }];
}

- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler

{
    NSString *path = @"rest/user/friends/get";
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            NSMutableArray *result = [[NSMutableArray alloc]init];
            [responseObject eachWithIndex:^(id item, NSUInteger index) {
                //
                HuFriend *friend = [[HuFriend alloc]initWithJSONDictionary:item];
                if([friend.serviceName caseInsensitiveCompare:@"twitter"] == NSOrderedSame) {
                    [friend setServiceImageBadge:@"twitter-bird-color.png"];
                    [friend setTinyServiceImageBadge:@"twitter-bird-white-tiny.png"];
                }
                if([friend.serviceName caseInsensitiveCompare:@"instagram"] == NSOrderedSame) {
                    [friend setServiceImageBadge:@"instagram-camera-color.png"];
                    [friend setTinyServiceImageBadge:@"instagram-camera-white-tiny.png"];
                }
                if([friend.serviceName caseInsensitiveCompare:@"flickr"] == NSOrderedSame) {
                    [friend setServiceImageBadge:@"flickr-peepers-color.png"];
                    [friend setTinyServiceImageBadge:@"flickr-peepers-white-tiny.png"];
                }
                if([friend.serviceName caseInsensitiveCompare:@"foursquare"] == NSOrderedSame) {
                    [friend setServiceImageBadge:@"foursquare-icon-16x16.png"];
                    [friend setTinyServiceImageBadge:@"foursquare-icon-gray-16x16.png"];
                }

                [result addObject:friend];
                LOG_GENERAL(0, @"%d %@", index, friend);
            }];
            completionHandler(result);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"failure: operation: %@ \n\nerror: %@", task, error);
        [Flurry logEvent:[NSString stringWithFormat:@"Error loading friends %@", error]];
        
        if(completionHandler) {
            completionHandler(nil);
        }

    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                          data:(NSData *)data
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];

     __block NSURLSessionDataTask *task = [self uploadTaskWithRequest:request fromData:data progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
 
    }];
    
    [task resume];
    
    return task;
}

@end
