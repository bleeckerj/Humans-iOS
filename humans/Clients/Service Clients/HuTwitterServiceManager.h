//
//  HuTwitterHTTPSessionManager.h
//  humans
//
//  Created by Julian Bleecker on 5/28/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

//#import "AFHTTPSessionManager.h"
@class HuOnBehalfOf;
@class HuTwitterStatus;
@class STTwitterAPI;

@interface HuTwitterServiceManager : NSObject  /*: AFHTTPSessionManager */
@property STTwitterAPI *twitter;

+ (HuTwitterServiceManager *)sharedTwitterClientOnBehalfOf:(HuOnBehalfOf *)onBehalfOf;

- (void)like:(HuTwitterStatus*)status;
- (void)retweet:(HuTwitterStatus*)status;
- (void)getStatus:(NSString *)statusID withStatuses:(NSArray *)statuses withCompletion:(CompletionHandlerWithData)completion;


//+ (HuTwitterServiceManager *)sharedTwitterClientWithOAuthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret oauthToken:(NSString *)oauthToken;

//- (id)initWithOAuthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret oauthToken:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret;


@end
