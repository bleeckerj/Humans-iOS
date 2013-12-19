//
//  HuHumansHTTPClient.m
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuHumansHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import <RestKit.h>

@implementation HuHumansHTTPClient


static NSString * const kHumansLocalDevBaseURLString = @"http://localhost:8080/";
static NSString * const kHumansProdBaseURLString = @"https://humans.nearfuturelaboratory.com:8443/";


+ (HuHumansHTTPClient *)sharedDevClient {
    static HuHumansHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HuHumansHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kHumansLocalDevBaseURLString]];
        [_sharedClient setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        [_sharedClient setDefaultHeader:@"Content-Type" value:RKMIMETypeJSON];
        [_sharedClient setAllowsInvalidSSLCertificate:YES];

    });
    
    return _sharedClient;
}

+ (HuHumansHTTPClient *)sharedProdClient {
    static HuHumansHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HuHumansHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kHumansProdBaseURLString]];
//        [_sharedClient setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
//        [_sharedClient setAllowsInvalidSSLCertificate:YES];
        
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setAllowsInvalidSSLCertificate:YES];
//    // By default, the example ships with SSL pinning enabled for the app.net API pinned against the public key of adn.cer file included with the example. In order to make it easier for developers who are new to AFNetworking, SSL pinning is automatically disabled if the base URL has been changed. This will allow developers to hack around with the example, without getting tripped up by SSL pinning.
//    if ([[url scheme] isEqualToString:@"https"] && [[url host] isEqualToString:@"alpha-api.app.net"]) {
//        self.defaultSSLPinningMode = AFSSLPinningModePublicKey;
//    } else {
//        self.defaultSSLPinningMode = AFSSLPinningModeNone;
//    }
    
    return self;
}


@end
