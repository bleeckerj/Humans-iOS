//
//  HuUserHandler.h
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HuHumansHTTPSessionManager.h"
#import "defines.h"
#import "HuUser.h"
#import "HuHuman.h"
#import "HuServices.h"
#import "HuServiceUser.h"

// new twitter
#import "HuTwitterStatus.h"
#import "HuTwitterUser.h"
#import "HuTwitterCoordinates.h"
#import "HuTwitterPlace.h"
#import "HuTwitterStatusEntities.h"
#import "HuTwitterEntitesHashtag.h"
#import "HuTwitterEntitiesSymbols.h"
#import "HuTwitterEntitiesUserMentions.h"
#import "HuTwitterEntitiesURL.h"
#import "HuTwitterStatusMedia.h"
#import "HuTwitterMediaSize.h"
//#import "TwitterStatus.h"
//#import "TwitterUser.h"

#import "InstagramStatus.h"
#import "InstagramCaption.h"
#import "InstagramUser.h"
#import "TransientInstagramUser.h"
#import "InstagramImages.h"
#import "InstagramCounts.h"
#import "InstagramImage.h"
#import "InstagramComments.h"
#import "InstagramCommenter.h"
#import "InstagramLikes.h"
#import "InstagramLike.h"

#import "HuFlickrStatus.h"
#import "HuFlickrDescription.h"

#import "HuFoursquareCheckin.h"

#import <Parse/Parse.h>
#import <ObjectiveSugar.h>

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
- (void)getAuthForService:(HuServices *)service with:(CompletionHandlerWithData)completionHandler;

- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler;
- (void)userGettyUpdate:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
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
