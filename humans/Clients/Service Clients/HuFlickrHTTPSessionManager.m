//
//  HuFlickrHTTPSessionManager.m
//  Pods
//
//  Created by Julian Bleecker on 3/30/14.
//
//

#import "HuFlickrHTTPSessionManager.h"

@implementation HuFlickrHTTPSessionManager


static NSString * const kFlickrAPIBaseURLString = @"https://localhost:8443/";


+ (HuFlickrHTTPSessionManager *)sharedFlickrClient {
    static HuFlickrHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HuFlickrHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kFlickrAPIBaseURLString]];
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

    
    return self;
}

@end
