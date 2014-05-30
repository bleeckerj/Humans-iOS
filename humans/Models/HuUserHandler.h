//
//  HuUserHandler.h
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "defines.h"


@class InstagramStatus;
@class HuUser;
@class HuHuman;
@class HuServices;
@class HuServiceUser;
@class HuHumansHTTPSessionManager;
@class HuOnBehalfOf;
@interface HuUserHandler : NSObject <NSURLConnectionDelegate>

typedef enum networkStateTypes
{
    NETWORK_DOWN,
    NETWORK_OKAY,
    NETWORK_WWAN,
    NETWORK_UNKNOWN,
    NETWORK_WIFI
} HuNetworkState;

@property (nonatomic, retain) HuHumansHTTPSessionManager *huRequestOperationManager;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) HuUser *humans_user;
@property (nonatomic, readonly) NSMutableDictionary *statusForHumanId;
@property (nonatomic, retain) NSDictionary *lastStatusResultHeader;
@property (nonatomic, retain) NSMutableArray *friends;
@property HuNetworkState networkState;
@property (nonatomic, retain) NSMutableDictionary *authForServices;

- (NSTimeInterval)lastPeekTimeFor:(HuHuman *)aHuman;
- (void)parseCreateNewUser:(HuUser *)aUser password:(NSString *)aPassword withCompletionHandler:(CompletionHandlerWithData)completionHandler;
//- (void)createNewUser:(HuUser *)user password:(NSString *)aPassword withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)getStatusCountForHuman:(HuHuman *)human withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)getStatusCountForHuman:(HuHuman *)human after:(NSTimeInterval)timestamp withCompletionHandler:(CompletionHandlerWithData)completionHandler;
-(void)getStatusCountsWithCompletionHandler:(CompletionHandlerWithData)completionHandler;

- (void)getHumansWithCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userRequestTokenForUsername:(NSString *)username forPassword:(NSString *)password withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userAddHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userRemoveHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;


- (void)userRemoveService:(HuServices *)aService withCompletionHandler:(CompletionHandlerWithResult)completionHandler;


- (void)humanAddServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)humanAddServiceUsers:(NSArray *)arrayOfServiceUsers forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)humanRemoveServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;

+ (void)usernameExists:(NSString *)username withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)usernameExists:(NSString *)username withCompletionHandler:(CompletionHandlerWithResult)completionhandler;

- (void)updateInstagramMediaByID:(NSString *)mediaID for:(NSString*)username;



- (NSMutableDictionary *)getAuthForService:(HuOnBehalfOf *)onBehalfOf;
- (void)getAuthForService:(HuServices *)service with:(CompletionHandlerWithData)completionHandler;

- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler;
- (void)userGettyUpdate:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userGettyUpdateYoumanWithCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userGettyUpdateFriends:(CompletionHandlerWithResult)completionHandler;

- (void)getStatusForHuman:(HuHuman *)aHuman atPage:(int)aPage withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)getStatusForHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (NSArray *)statusForHuman:(HuHuman *)aHuman;
-(void)searchFriendsWith:(NSRegularExpression *)regex withCompletionHandler:(ArrayOfResultsHandler)handler;


- (NSURL *)urlForInstagramAuthentication;
- (NSURL *)urlForTwitterAuthentication;
- (NSURL *)urlForFlickrAuthentication;
- (NSURL *)urlForFoursquareAuthentication;

@end
