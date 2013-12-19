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
@interface HuUserHandler : NSObject

@property (nonatomic, retain) HuHumansHTTPClient *client;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) HuUser *humans_user;

- (void)userGetWithCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userRequestTokenForUsername:(NSString *)username forPassword:(NSString *)password withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (BOOL)usernameExists:(NSString *)username;
- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler;

@end
