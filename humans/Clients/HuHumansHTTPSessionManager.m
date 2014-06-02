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
        [_sharedClient.reachabilityManager startMonitoring];
        
        
    });
    
    return _sharedClient;
}

+ (HuHumansHTTPSessionManager *)sharedProdClient {
    static HuHumansHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HuHumansHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kHumansProdBaseURLString]];
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    AFCompoundResponseSerializer *c = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[ [AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer] ]];
    
    [self setResponseSerializer:c];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setTimeoutInterval:45.0];
    
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

//
- (void)humanAddServiceUsers:(NSArray *)aServiceUsers forHuman:(HuHuman *)aHuman withProgress:(NSProgress *__autoreleasing *)progress withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    
    NSString *URLString = [NSString stringWithFormat:@"rest/human/%@/add/serviceuser", [aHuman humanid]];
    
    NSError *error;
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc]initWithCapacity:[aServiceUsers count]];
    
    [aServiceUsers eachWithIndex:^(id object, NSUInteger index) {
        [arrayOfDicts addObject:[[aServiceUsers objectAtIndex:index]dictionary]];
    }];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayOfDicts options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LOG_GENERAL(0, @"%@", [jsonString dataUsingEncoding:NSUTF8StringEncoding]);

    
    NSMutableURLRequest *requestFoo = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:nil error:nil];
    [requestFoo setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    __block NSURLSessionUploadTask *task = [self uploadTaskWithRequest:requestFoo fromData:jsonData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (completionHandler) {
                completionHandler(nil, NO, error);
            }
        } else {
            if(completionHandler) {
                completionHandler(responseObject, YES, nil);
            }
        }
        
    }];

    
    [task resume];

    
}

- (void)humanAddServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withProgress:(NSProgress *__autoreleasing *)progress withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSString *URLString = [NSString stringWithFormat:@"rest/human/%@/add/serviceuser", [aHuman humanid]];
    
    [self POST:URLString parameters:[aServiceUser dictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            completionHandler(responseObject, YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(completionHandler) {
            completionHandler(nil, NO, error);
        }
        LOG_ERROR(0, @"Error %@", error);
        
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
                //LOG_GENERAL(0, @"%lu %@", (unsigned long)index, friend);
            }];
            completionHandler(result);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"failure: operation: %@ \n\nerror: %@", task, error);
        //[PFAnalytics trackEvent:[NSString stringWithFormat:@"Error loading friends %@", error]];
        LELog *log = [LELog sharedInstance];
        NSDictionary *dimentions = @{@"error": error};
        [log log:dimentions];
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
    
    //self.requestSerializer = [AFJSONRequestSerializer serializer];
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
