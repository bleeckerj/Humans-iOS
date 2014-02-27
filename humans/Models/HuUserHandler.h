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
#import "HuServices.h"

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

#import "HuRestStatusHeader.h"
#import <Parse/Parse.h>

@interface HuUserHandler : NSObject <NSURLConnectionDelegate>

typedef enum networkStateTypes
{
    NETWORK_DOWN,
    NETWORK_OKAY,
    NETWORK_WWAN,
    NETWORK_UNKNOWN,
    NETWORK_WIFI
} HuNetworkState;

@property (nonatomic, retain) HuHumansHTTPClient *client;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) HuUser *humans_user;
@property (nonatomic, readonly) NSMutableDictionary *statusForHumanId;
@property (nonatomic, retain) HuRestStatusHeader *lastStatusResultHeader;
@property (nonatomic, retain) NSMutableArray *friends;
@property HuNetworkState networkState;

- (void)parseCreateNewUser:(HuUser *)aUser password:(NSString *)aPassword withCompletionHandler:(CompletionHandlerWithData)completionHandler;
//- (void)createNewUser:(HuUser *)user password:(NSString *)aPassword withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)getStatusCountForHuman:(HuHuman *)human withCompletionHandler:(CompletionHandlerWithData)completionHandler;
- (void)getStatusCountForHuman:(HuHuman *)human after:(NSTimeInterval)timestamp withCompletionHandler:(CompletionHandlerWithData)completionHandler;

- (void)getHumansWithCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userRequestTokenForUsername:(NSString *)username forPassword:(NSString *)password withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userAddHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)userRemoveHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;

- (void)userRemoveService:(HuServices *)aService withCompletionHandler:(CompletionHandlerWithResult)completionHandler;


- (void)usernameExists:(NSString *)username withCompletionHandler:(CompletionHandlerWithResult)completionhandler;
- (void)getAuthForService:(HuServices *)service with:(CompletionHandlerWithData)completionHandler;

- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler;
- (void)getStatusForHuman:(HuHuman *)aHuman atPage:(int)aPage withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (void)getStatusForHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler;
- (NSArray *)statusForHuman:(HuHuman *)aHuman;
-(void)searchFriendsWith:(NSRegularExpression *)regex withCompletionHandler:(ArrayOfResultsHandler)handler;


- (NSURL *)urlForInstagramAuthentication;
- (NSURL *)urlForTwitterAuthentication;
- (NSURL *)urlForFlickrAuthentication;
- (NSURL *)urlForFoursquareAuthentication;

@end
