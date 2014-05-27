//
//  HuInstagramHTTPSessionManager.h
//  humans
//
//  Created by Julian Bleecker on 5/25/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "defines.h"
#import <ObjectiveSugar.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "InstagramStatus.h"
#import "HuAppDelegate.h"

@interface HuInstagramHTTPSessionManager : AFHTTPSessionManager
+(HuInstagramHTTPSessionManager *)sharedInstagramClient;

//- (void)unlike:(NSString *)mediaId withAccessToken:(NSString *)accessToken;
//- (void)like:(NSString *)mediaId withAccessToken:(NSString *)accessToken;
- (void)like:(InstagramStatus*)status;
- (void)unlike:(InstagramStatus *)status;


@end
