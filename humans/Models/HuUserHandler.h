//
//  HuUserHandler.h
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuHumansHTTPClient.h"
#import "defines.h"
#import "HuUser.h"
#import "HuHuman.h"

#import "TwitterStatus.h"
#import "TwitterUser.h"

#import "InstagramStatus.h"
#import "InstagramCaption.h"
#import "InstagramUser.h"
#import "TransientInstagramUser.h"
#import "InstagramImages.h"
#import "InstagramCounts.h"
#import "InstagramImage.h"

@interface HuUserHandler : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) HuHumansHTTPClient *client;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) HuUser *humans_user;
@property (nonatomic, readonly) NSMutableDictionary *statusForHumanId;

- (void)userGetWithCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userRequestTokenForUsername:(NSString *)username forPassword:(NSString *)password withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (BOOL)usernameExists:(NSString *)username;
- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler;
- (void)getStatusForHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (NSArray *)statusForHuman:(HuHuman *)aHuman;

@end
