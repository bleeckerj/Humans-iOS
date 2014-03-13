//
//  HuHumansHTTPClient.h
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//
#import <AFHTTPSessionManager.h>
#import "defines.h"
#import "HuHuman.h"
#import "HuServiceUser.h"
#import <ObjectiveSugar.h>
#import "Flurry.h"

@interface HuHumansHTTPSessionManager : AFHTTPSessionManager

+(HuHumansHTTPSessionManager *)sharedDevClient;
+(HuHumansHTTPSessionManager *)sharedProdClient;

- (void)getStatusCountForHuman:(HuHuman *)human after:(NSTimeInterval)timestamp withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)humanAddServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withProgress:(NSProgress *__autoreleasing *)progress withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)humanAddServiceUsers:(NSArray *)aServiceUser forHuman:(HuHuman *)aHuman withProgress:(NSProgress *__autoreleasing *)progress withCompletionHandler:(CompletionHandlerWithData)completionHandler;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                          data:(NSData *)data
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
