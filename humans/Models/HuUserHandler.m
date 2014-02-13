//
//  HuUserHandler.m
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuUserHandler.h"
#import "defines.h"
#import "LoggerClient.h"
#import <AFNetworking.h>
#import <RestKit.h>
#import "Flurry.h"

#import <ConciseKit.h>
#import "HuFriend.h"
#import "HuUser.h"
#import "HuHuman.h"
#import "HuServices.h"
#import "HuOnBehalfOf.h"
#import "HuServiceUser.h"
#import "HuAppDelegate.h"
#import "RKValueTransformers.h"


@implementation HuUserHandler

@synthesize client;
@synthesize humans_user;
@synthesize statusForHumanId;
@synthesize lastStatusResultHeader;
@synthesize friends;
@synthesize networkState;

NSDateFormatter *twitter_formatter;


- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
    
}

// An array of status. This will check this temporary object cache first. No strategy for dumping it other than
// when the application or GC dumps it..
- (NSArray *)statusForHuman:(HuHuman *)aHuman
{
    __block id obj =  [[self statusForHumanId]objectForKey:[aHuman humanid]];
    if(obj == nil) {
        [self getStatusForHuman:aHuman withCompletionHandler:^(BOOL success, NSError *error) {
            //
            obj =  [[self statusForHumanId]objectForKey:[aHuman humanid]];
        }];
    }
    return obj;
}

- (void)commonInit
{
    twitter_formatter = [NSDateFormatter new];
    [twitter_formatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];
    
    statusForHumanId = [[NSMutableDictionary alloc]init];
    
#pragma mark This is where you set either the sharedDevClient or the sharedProdClient
    
    client = [HuHumansHTTPClient sharedProdClient];
    
    
    //LOG_GENERAL(0, @"allowss invalid ssl cert? %@", [client allowsInvalidSSLCertificate]?@"YES":@"NO");
    
    __block HuUserHandler *bself = self;
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // Not reachable
            LOG_NETWORK(0, @"Network is down..");
            bself.networkState = NETWORK_DOWN;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            // Reachable
            LOG_NETWORK(0, @"Network is okay..WWAN");
            bself.networkState = NETWORK_WWAN;
            
        }
        if (status == AFNetworkReachabilityStatusUnknown) {
            LOG_NETWORK(0, @"Network is unknown..");
            bself.networkState = NETWORK_UNKNOWN;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            // On wifi
            LOG_NETWORK(0, @"Network is okay..WiFi..");
            bself.networkState = NETWORK_WIFI;
        }
    }];
}

- (void)userAddHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    NSString *path =[NSString stringWithFormat:@"/rest/user/add/human?access_token=%@", [self access_token]];
    [client setParameterEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request =[client requestWithMethod:@"POST" path:path parameters:nil];
    
    request.timeoutInterval = 30.000000;
    
    // Request Operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *jsonRequest = [aHuman jsonString];
    
    NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        LOG_NETWORK(0, @"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        LOG_NETWORK(0, @"Received %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_NETWORK(0, @"Success: Status Code %d", operation.response.statusCode);
        [Flurry logEvent:[NSString stringWithFormat:@"Successfully added a human %@ \n%@", [aHuman name], [aHuman jsonString]]];
        
        if(completionHandler) {
            completionHandler(true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        [Flurry logEvent:[NSString stringWithFormat:@"Failed adding a human %@ %@", [aHuman name], error]];
        
        if(completionHandler) {
            completionHandler(false, error);
        }
    }];
    
    // Connection
    [operation start];
}


- (void)userRequestTokenForUsername:(NSString *)username forPassword:(NSString *)password withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    NSString *path =[NSString stringWithFormat:@"/oauth2/token?grant_type=password&client_id=ioshumans&username=%@&password=%@",username,password];
    
    [client setParameterEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request =[client requestWithMethod:@"POST" path:path parameters:nil];
    //[request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded"] forHTTPHeaderField:@"Content-Type"];
    LOG_GENERAL(0, @"The request is to %@", [request URL]);
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        LOG_NETWORK(0, @"Success %@", responseObject);
        [self setAccess_token:[responseObject objectForKey:@"access_token"]];
        
        [self getHumansWithCompletionHandler:completionHandler];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        LOG_NETWORK(0, @"Failure %@", error);
        [self setAccess_token:nil];
        if(completionHandler) {
            completionHandler(NO, error);
        }
    }];
    
    [operation setSSLPinningMode:AFSSLPinningModeNone];
    //[operation setAllowsInvalidSSLCertificate:YES];
    [operation start];
    [operation waitUntilFinished];
    
}

#pragma mark get the user's humans as well as the user's details, id, services, username, etc.
- (void)getHumansWithCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    RKObjectManager *objectManager = [[RKObjectManager alloc]initWithHTTPClient:client];
    
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[HuUser class]];
    [userMapping addAttributeMappingsFromArray:@[@"email",@"id",@"username",@"isAdmin", @"isSuperuser"]];
    
    RKObjectMapping *humansMappping = [RKObjectMapping mappingForClass:[HuHuman class]];
    [humansMappping addAttributeMappingsFromArray:@[@"humanid", @"name"]];
    
    RKObjectMapping *servicesMapping = [RKObjectMapping mappingForClass:[HuServices class]];
    [servicesMapping addAttributeMappingsFromArray:@[@"serviceName", @"serviceUserID", @"serviceUsername"]];
    
    RKObjectMapping *onBehalfOfMapping = [RKObjectMapping mappingForClass:[HuOnBehalfOf class]];
    [onBehalfOfMapping addAttributeMappingsFromArray:@[@"serviceName", @"serviceUserID", @"serviceUsername"]];
    
    RKObjectMapping *serviceUsersMapping = [RKObjectMapping mappingForClass:[HuServiceUser class]];
    [serviceUsersMapping addAttributeMappingsFromArray:@[@"id", @"imageURL", @"lastUpdated", @"serviceName", @"serviceUserID", @"serviceUsername"]];
    
    // relationships
    // humans within users
    [userMapping addPropertyMapping:[RKRelationshipMapping
                                     relationshipMappingFromKeyPath:@"humans"
                                     toKeyPath:@"humans"
                                     withMapping:humansMappping]];
    
    // services within users
    [userMapping addPropertyMapping:[RKRelationshipMapping
                                     relationshipMappingFromKeyPath:@"services"
                                     toKeyPath:@"services"
                                     withMapping:servicesMapping]];
    
    // serviceUsers (friends) within humans
    [humansMappping addPropertyMapping:[RKRelationshipMapping
                                        relationshipMappingFromKeyPath:@"serviceUsers"
                                        toKeyPath:@"serviceUsers"
                                        withMapping:serviceUsersMapping]];
    
    // onBehalfOf within serviceUsers (friends)
    [serviceUsersMapping addPropertyMapping:[RKRelationshipMapping
                                            relationshipMappingFromKeyPath:@"onBehalfOf"
                                            toKeyPath:@"onBehalfOf"
                                            withMapping:onBehalfOfMapping]];
    
    NSIndexSet *statusCodes =  RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:statusCodes];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *errorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:@"message"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    
    [objectManager addResponseDescriptor:errorDescriptor];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self access_token], @"access_token", nil];
    
    RKObjectRequestOperation *operation;
    operation = [objectManager appropriateObjectRequestOperationWithObject:self method:RKRequestMethodGET path:@"/rest/user/get" parameters:queryParams];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //
       [Flurry logEvent:[NSString stringWithFormat:@"Successful getHumansWithCompletion %@" , [humans_user username]]];

        LOG_NETWORK(0, @"User Get Success %@", [mappingResult firstObject]);
        humans_user = [mappingResult firstObject];
        
        LOG_GENERAL(0, @"%@", [humans_user dictionary]);
        if(completionHandler) {
            completionHandler(true, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //
       [Flurry logEvent:[NSString stringWithFormat:@"Failed getHumansWithCompletion %@" , [humans_user username]]];

        RKErrorMessage *errorMessage =  [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        LOG_NETWORK(0, @"User Get Failed.. %@", error);
        LOG_NETWORK(0, @"%@", errorMessage);
        if(completionHandler) {
            completionHandler(false, error);
        }
        
    }];
    
    [operation start];
    [operation waitUntilFinished];
    
    
}

#pragma mark /status/count/{humanid}
- (void)getStatusCountForHuman:(HuHuman *)human withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSString *path =[NSString stringWithFormat:@"/rest/human/status/count/%@?access_token=%@", [human humanid], [self access_token]];
    [client setParameterEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request =[client requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        LOG_NETWORK(0, @"Received %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
//    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //LOG_NETWORK(0, @"Success: Status Code %d", operation.response.statusCode);
        if(completionHandler) {
            completionHandler([responseObject objectForKey:@"count"], true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        if(completionHandler) {
            completionHandler(nil, false, error);
        }
    }];
    
    // Connection
    
    [operation start];
}

#pragma mark /status/count/{humanid}/after/{timestamp}
- (void)getStatusCountForHuman:(HuHuman *)human after:(NSTimeInterval)timestamp withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    
    NSString *path =[NSString stringWithFormat:@"/rest/human/status/count/%@/after/%@?access_token=%@", [human humanid], [numberFormatter stringFromNumber:@(timestamp*1000l) ], [self access_token]];
    [client setParameterEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request =[client requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        LOG_NETWORK(0, @"Received %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_NETWORK(0, @"Success: Status Code %d", operation.response.statusCode);
        if(completionHandler) {
            completionHandler([responseObject objectForKey:@"count"], true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        if(completionHandler) {
            completionHandler(nil, false, error);
        }
    }];
    
    // Connection
    
    [operation start];
}


#pragma mark Delete Human By ID /user/rm/{humanid}/human
- (void)userRemoveHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    NSString *path = [NSString stringWithFormat:@"/rest/user/rm/%@/human?access_token=%@", [aHuman humanid], [self access_token] ];
    
    //    NSURL* URL = [NSURL URLWithString:@"https://localhost:8443/rest/user/rm/52df74850364e4bd329f50d5/human?access_token=9677da300993e1cbf4d7c15aabf3152e"];
    [client setParameterEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request =[client requestWithMethod:@"GET" path:path parameters:nil];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 30.000000;
    
    // Request Operation
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Progress & Completion blocks
    
    //    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
    //        LOG_NETWORK(0, @"Received %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
    //    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_NETWORK(0, @"Success: Status Code %d", operation.response.statusCode);
        if(completionHandler) {
            completionHandler(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        if(completionHandler) {
            completionHandler(NO, error);
        }
    }];
    
    // Connection
    
    [operation start];
}


#pragma mark Get Friends
- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler
{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *friendsMapping = [RKObjectMapping mappingForClass:[HuFriend class]];
    [friendsMapping addAttributeMappingsFromArray:@[@"imageURL", @"largeImageURL", @"serviceName", @"serviceUserID", @"username", @"fullname", @"lastUpdated"]];
    
    RKResponseDescriptor *dynamicResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:friendsMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:dynamicResponseDescriptor];
    
    // onBehalfOfMapping
    RKObjectMapping *onBehalfOfMapping = [RKObjectMapping mappingForClass:[HuOnBehalfOf class]];
    [onBehalfOfMapping addAttributeMappingsFromArray:@[@"serviceName", @"serviceUserID", @"serviceUsername"]];
    
    // onBehalfOf within serviceUsers (friends)
    [friendsMapping addPropertyMapping:[RKRelationshipMapping
                                        relationshipMappingFromKeyPath:@"onBehalfOf"
                                        toKeyPath:@"onBehalfOf"
                                        withMapping:onBehalfOfMapping]];
    
    
    // errors
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    
    
    RKResponseDescriptor *errorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:@"message"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [objectManager addResponseDescriptor:errorDescriptor];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self access_token], @"access_token", nil];
    
    
    [objectManager getObjectsAtPath:@"/rest/user/friends/get"
                         parameters:queryParams
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
//         LOG_GENERAL(0, @"success: mappings %@", mappingResult);
//         LOG_GENERAL(0, @"success: size=%d", [mappingResult count]);
         
         self.friends = [[NSMutableArray alloc]init];
         for (HuFriend *item in [mappingResult array]) {
             if([item.serviceName caseInsensitiveCompare:@"twitter"] == NSOrderedSame) {
                 [item setServiceImageBadge:@"twitter-bird-color.png"];
                 [item setTinyServiceImageBadge:@"twitter-bird-white-tiny.png"];
             }
             if([item.serviceName caseInsensitiveCompare:@"instagram"] == NSOrderedSame) {
                 [item setServiceImageBadge:@"instagram-camera-color.png"];
                 [item setTinyServiceImageBadge:@"instagram-camera-white-tiny.png"];
             }
             if([item.serviceName caseInsensitiveCompare:@"flickr"] == NSOrderedSame) {
                 [item setServiceImageBadge:@"flickr-peepers-color.png"];
                 [item setTinyServiceImageBadge:@"flickr-peepers-white-tiny.png"];
             }
             if([item.serviceName caseInsensitiveCompare:@"foursquare"] == NSOrderedSame) {
                 [item setServiceImageBadge:@"foursquare-icon-16x16.png"];
                 [item setTinyServiceImageBadge:@"foursquare-icon-gray-16x16.png"];
             }
             [self.friends addObject:item];
             
         }
         if(completionHandler) {
             completionHandler(friends);
         }
     }
     
                            failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         LOG_NETWORK(0, @"failure: operation: %@ \n\nerror: %@", operaton, error);
         LOG_NETWORK(0, @"errorMessage: %@", [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey]);
         [Flurry logEvent:[NSString stringWithFormat:@"Error loading friends %@", error]];
         
         if(completionHandler) {
             completionHandler(nil);
         }
     }];
    
}

-(void)searchFriendsWith:(NSRegularExpression *)regex withCompletionHandler:(ArrayOfResultsHandler)handler
{
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    [self.friends enumerateObjectsUsingBlock:^(HuFriend* friend, NSUInteger idx, BOOL *stop) {
        // match username
        // match fullname
        if(([self numberOfMatches:[friend username] forRegex:regex]) || ([self numberOfMatches:[friend fullname] forRegex:regex])) {
            [results addObject:friend];
        }

    }];
    
    //LOG_GENERAL(0, @"Final Results %@", results);
    if(handler) {
        handler(results);
    }
    
}

-(NSUInteger)numberOfMatches:(NSString *)string forRegex:(NSRegularExpression *)regex
{
    return [regex numberOfMatchesInString:string
                                  options:0
                                    range:NSMakeRange(0, [string length])];
}

- (void)getStatusForHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    [self getStatusForHuman:(HuHuman *)aHuman atPage:0 withCompletionHandler:(CompletionHandlerWithResult)completionHandler];
    
}
- (void)getStatusForHuman:(HuHuman *)aHuman atPage:(int)aPage withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKDynamicMapping *statusMapping = [RKDynamicMapping new];
    
    [statusMapping addMatcher:[self twitterNewStatusMatcher]];
    [statusMapping addMatcher:[self instagramStatusMatcher]];
    [statusMapping addMatcher:[self flickrStatusMatcher]];
    
    // Head - The service sends this back with metadata about the status request
    RKObjectMapping *headMapping = [RKObjectMapping mappingForClass:[HuRestStatusHeader class]];
    [headMapping addAttributeMappingsFromArray:@[@"count", @"human_id", @"human_name", @"page", @"pages", @"total_status"]];
    
    
    RKResponseDescriptor *headResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:headMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"head"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:headResponseDescriptor];
    
    
    // Status Success
    RKResponseDescriptor *statusResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:statusMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"status" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:statusResponseDescriptor];
    
    
    // Client Errors
    RKObjectMapping *clientErrorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [clientErrorMapping addPropertyMapping:
     [RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *clientErrorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:clientErrorMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"message"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [objectManager addResponseDescriptor:clientErrorDescriptor];
    
    
    // Server Errors
    RKObjectMapping *serverErrorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [serverErrorMapping addPropertyMapping:
     [RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *serverErrorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:serverErrorMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"message"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    
    [objectManager addResponseDescriptor:serverErrorDescriptor];
    
    NSString *humanid = [aHuman humanid];
    
    NSDictionary *queryParams;
    //NSString *a = [self access_token];
    NSNumber *page = [NSNumber numberWithInt:aPage];
    
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self access_token], @"access_token", humanid, @"humanid", page, @"page", nil];
    
    //LOG_GENERAL(0, @"query=%@", queryParams);
    
    [objectManager getObjectsAtPath:@"/rest/human/status"
                         parameters:queryParams
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         
         LOG_GENERAL(0, @"success: mappings: %@", [mappingResult array]);
         [[self statusForHumanId] setObject:[[mappingResult dictionary]objectForKey:@"status"] forKey:[aHuman humanid]];
         [self setLastStatusResultHeader:[[mappingResult dictionary]objectForKey:@"head"]];
         LOG_GENERAL(0,@"%@",[[mappingResult dictionary]objectForKey:@"head"]);
         LOG_GENERAL(0, @"%@", [[mappingResult dictionary]objectForKey:@"status"]);
         if(completionHandler) {
             completionHandler(true, nil);
         }
     }
                            failure:^(RKObjectRequestOperation * operation, NSError * error)
     {
         LOG_GENERAL (0, @"failure: error: %@", error);
         LOG_GENERAL(0, @"%@", [error localizedDescription] );
         [self setLastStatusResultHeader:nil];
         [[self statusForHumanId]removeObjectForKey:humanid];
         if(completionHandler) {
             completionHandler(false, error);
         }
     }];
    
    
    
}

- (RKObjectMappingMatcher *)twitterNewStatusMatcher
{
    RKObjectMapping *twitterStatusMapping = [RKObjectMapping mappingForClass:[HuTwitterStatus class]];
    [twitterStatusMapping addAttributeMappingsFromDictionary:@{
                                                               @"id" : @"tweet_id",
                                                               @"text" : @"text",
                                                               @"id_str" : @"id_str",
                                                               @"source" : @"source",
                                                               @"in_reply_to_status_id" : @"in_reply_to_status_id",
                                                               @"in_reply_to_status_id_str" : @"in_reply_to_status_id_str",
                                                               @"in_reply_to_user_id": @"in_reply_to_user_id",
                                                               @"in_reply_to_user_id_str" : @"in_reply_to_user_id_str",
                                                               @"in_reply_to_screen_name" : @"in_reply_to_screen_name",
                                                               @"contributors" : @"contributors",
                                                               @"retweet_count" : @"retweet_count",
                                                               @"favorite_count" : @"favorite_count",
                                                               @"favorited" : @"favorited",
                                                               @"retweeted" : @"retweeted",
                                                               @"possibly_sensitive" : @"possibly_sensitive",
                                                               @"lang" : @"lang",
                                                               @"created" : @"created"
                                                               //@"user" : @"user",
                                                               //@"created_at" : @"created_at",
                                                               //@"service" : @"name"
                                                               }];
    
    
    // Transform date
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];
    
    [[RKValueTransformer defaultValueTransformer]insertValueTransformer:dateFormatter atIndex:0];
    
    RKAttributeMapping *created_at_mapping = [RKAttributeMapping attributeMappingFromKeyPath:@"created_at" toKeyPath:@"created_at"];
    created_at_mapping.valueTransformer = [RKValueTransformer defaultValueTransformer];//dateTransformer;
    [twitterStatusMapping addPropertyMapping:created_at_mapping];
    
    //
    // the coordinates mapping
    //
    RKObjectMapping *coordinatesMapping = [RKObjectMapping mappingForClass:[HuTwitterCoordinates class]];
    [coordinatesMapping addAttributeMappingsFromArray:@[@"coordinates", @"type"]];
    [twitterStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coordinates" toKeyPath:@"coordinates" withMapping:coordinatesMapping]];
    
    
    //
    // the place mapping
    //
    RKObjectMapping *placeMapping = [RKObjectMapping mappingForClass:[HuTwitterPlace class]];
    [placeMapping addAttributeMappingsFromArray:@[@"country", @"country_code", @"full_name", @"id", @"name", @"place_type", @"url"]];
    [twitterStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"place" toKeyPath:@"place" withMapping:placeMapping]];
    
    //
    // the user mapping
    //
    RKObjectMapping *twitterUserMapping = [RKObjectMapping mappingForClass:[HuTwitterUser class]];
    [twitterUserMapping addAttributeMappingsFromArray:@[@"id",
                                                        @"id_str",
                                                        @"lastUpdated",
                                                        /* @"created_at",*/
                                                        @"description",
                                                        @"favourites_count",
                                                        @"following",
                                                        @"followers_count",
                                                        @"friends_count",
                                                        @"geo_enabled",
                                                        @"location",
                                                        @"name",
                                                        @"screen_name",
                                                        @"time_zone",
                                                        @"url",
                                                        @"utc_offset",
                                                        @"verified",
                                                        @"profile_image_url",
                                                        @"protected",
                                                        @"statuses_count",
                                                        @"listed_count",
                                                        @"lang",
                                                        @"profile_background_color",
                                                        @"profile_background_image_url",
                                                        @"profile_background_imag_url_https",
                                                        @"profile_link_color",
                                                        @"profile_sidebar_border_color",
                                                        @"profile_sidebar_fill_color",
                                                        @"profile_text_color"]];
    
    
    
    // Transform date
    NSDateFormatter *userCreatedAtDateFormatter = [NSDateFormatter new];
    [userCreatedAtDateFormatter setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];
    [[RKValueTransformer defaultValueTransformer]insertValueTransformer:userCreatedAtDateFormatter atIndex:0];
    
    //
    //    LOG_TODO(0, @"I hate date transformations: %@",  [userCreatedAtDateFormatter stringFromDate:[[NSDate alloc]init]]);
    //    NSString *test = @"Sat Jun 28 17:19:16 +0000 2008";
    //    NSDate *test_date = [userCreatedAtDateFormatter dateFromString:test];
    //    LOG_TODO(0, @"Did this take? %@ for this %@", test_date, test);
    
    RKAttributeMapping *user_created_at_mapping = [RKAttributeMapping attributeMappingFromKeyPath:@"created_at" toKeyPath:@"created_at"];
    user_created_at_mapping.valueTransformer = [RKValueTransformer defaultValueTransformer];//dateTransformer;
    [twitterUserMapping addPropertyMapping:user_created_at_mapping];
    
    [twitterStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                         toKeyPath:@"user"
                                                                                       withMapping:twitterUserMapping]];
    
    //
    // status entities
    //
    RKObjectMapping *twitterStatusEntitiesMapping = [RKObjectMapping mappingForClass:[HuTwitterStatusEntities class]];
    [twitterStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"entities" toKeyPath:@"entities" withMapping:twitterStatusEntitiesMapping]];
    //
    // entities.hashtags
    //
    RKObjectMapping *twitterEntitiesHashtagMapping = [RKObjectMapping mappingForClass:[HuTwitterEntitesHashtag class]];
    [twitterEntitiesHashtagMapping addAttributeMappingsFromArray:@[@"text", @"indices"]];
    [twitterStatusEntitiesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"hashtags" toKeyPath:@"hashtags" withMapping:twitterEntitiesHashtagMapping]];
    
    //
    // entities.symbols
    //
    RKObjectMapping *twitterEntitiesSymbolsMapping = [RKObjectMapping mappingForClass:[HuTwitterEntitiesSymbols class]];
    [twitterEntitiesSymbolsMapping addAttributeMappingsFromArray:@[@"text", @"indices"]];
    [twitterStatusEntitiesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"symbols" toKeyPath:@"symbols" withMapping:twitterEntitiesSymbolsMapping]];
    
    //
    // entities.urls
    //
    RKObjectMapping *twitterEntitiesURLsMapping = [RKObjectMapping mappingForClass:[HuTwitterEntitiesURL class]];
    [twitterEntitiesURLsMapping addAttributeMappingsFromArray:@[@"expanded_url", @"indices", @"display_url", @"url"]];
    [twitterStatusEntitiesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"urls" toKeyPath:@"urls" withMapping:twitterEntitiesURLsMapping]];
    
    
    //
    // entities.user_mentions
    //
    RKObjectMapping *twitterEntitiesUserMentionsMapping = [RKObjectMapping mappingForClass:[HuTwitterEntitiesUserMentions class]];
    [twitterEntitiesUserMentionsMapping addAttributeMappingsFromArray:@[@"expanded_url", @"indices", @"display_url", @"url"]];
    [twitterStatusEntitiesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_mentions" toKeyPath:@"user_mentions" withMapping:twitterEntitiesUserMentionsMapping]];
    
    
    //
    // entitites.media
    //
    RKObjectMapping *twitterEntitiesMediaMapping = [RKObjectMapping mappingForClass:[HuTwitterStatusMedia class]];
    [twitterEntitiesMediaMapping addAttributeMappingsFromArray:@[@"media_url", @"media_url_https", @"id", @"id_str", @"expanded_url", @"sizes", @"indices", @"display_url", @"url"]];
    
    //    RKObjectMapping *twitterEntitiesMediaSizesMapping = [RKObjectMapping mappingForClass:[HuTwitterMediaSize class]];
    //    [twitterEntitiesMediaSizesMapping addAttributeMappingsFromArray:@[@"w",@"h", @"resize"]];
    //
    //    RKObjectMapping *sizes = [RKObjectMapping mappingForClass:[NSArray class]];
    //    [sizes addAttributeMappingsFromArray:@[@"small", @"medium", @"large", @"thumb"]];
    //    //TODO: Sort this crazy stuff out. each "small" has a w,h,resize, each "medium" has a, etc.
    //
    //    [twitterEntitiesMediaSizesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sizes" toKeyPath:@"sizes" withMapping:sizes]];
    
    [twitterStatusEntitiesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"media" toKeyPath:@"media" withMapping:twitterEntitiesMediaMapping]];
    
    
    
    RKObjectMappingMatcher *twitterStatusMatcher = [RKObjectMappingMatcher matcherWithKeyPath:@"service" expectedValue:@"twitter" objectMapping:twitterStatusMapping];
    
    
    return twitterStatusMatcher;
}



// OLD TWITTER
//
//- (RKObjectMappingMatcher *)__oldtwitterStatusMatcher
//{
//    RKObjectMapping *twitterStatusMapping = [RKObjectMapping mappingForClass:[HuTwitterStatus class]];
//    [twitterStatusMapping addAttributeMappingsFromDictionary:@{
//                                                               @"id" : @"tweet_id",
//                                                               @"text" : @"text",
//                                                               @"id_str" : @"id_str",
//                                                               @"source" : @"source",
//                                                               @"created" : @"created"
//                                                               //@"user" : @"user",
//                                                               //@"created_at" : @"created_at",
//                                                               //@"service" : @"name"
//                                                               }];
//
//
//    // Transform date
////    NSDateFormatter *dateFormatter = [NSDateFormatter new];
////    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];
//
////    [[RKValueTransformer defaultValueTransformer]insertValueTransformer:dateFormatter atIndex:0];
//
//    RKAttributeMapping *created_at_mapping = [RKAttributeMapping attributeMappingFromKeyPath:@"created_at" toKeyPath:@"created_at"];
//    created_at_mapping.valueTransformer = [RKValueTransformer defaultValueTransformer];//dateTransformer;
//    [twitterStatusMapping addPropertyMapping:created_at_mapping];
//
//
//    RKObjectMapping *twitterUserMapping = [RKObjectMapping mappingForClass:[HuTwitterUser class]];
//    [twitterUserMapping addAttributeMappingsFromArray:@[@"id", @"lastUpdated",/* @"created_at",*/ @"description", @"favourites_count", @"following", @"followers_count", @"friends_count", @"geo_enabled", @"location", @"name", @"screen_name", @"time_zone", @"url", @"utc_offset", @"verified", @"profile_image_url", @"protected", @"statuses_count", @"listed_count"]];
//
//
//    [twitterUserMapping addPropertyMapping:[created_at_mapping copy]];
//    [twitterStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
//                                                                                         toKeyPath:@"user"
//                                                                                       withMapping:twitterUserMapping]];
//
//    RKObjectMappingMatcher *twitterStatusMatcher = [RKObjectMappingMatcher matcherWithKeyPath:@"service" expectedValue:@"twitter" objectMapping:twitterStatusMapping];
//
//
//    return twitterStatusMatcher;
//}


// INSTAGRAM
- (RKObjectMappingMatcher *)instagramStatusMatcher
{
    RKObjectMapping *instagramStatusMapping = [RKObjectMapping mappingForClass:[InstagramStatus class]];
    [instagramStatusMapping addAttributeMappingsFromDictionary:@{@"id": @"instagram_id",
                                                                 //@"caption", @"caption",
                                                                 //@"created_time": @"created_time",
                                                                 @"service" : @"service",
                                                                 @"filter" : @"filter",
                                                                 @"link" : @"link",
                                                                 @"type" : @"type",
                                                                 @"created" : @"created"
                                                                 }];
    
    
    //    NSNumberFormatter * twitterCreatedTime = [[NSNumberFormatter alloc] init];
    //    [twitterCreatedTime setNumberStyle:NSNumberFormatterDecimalStyle];
    
    RKValueTransformer *createdTimeTransformer =
    [RKBlockValueTransformer
     valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass, __unsafe_unretained Class outputValueClass) {
         return ([inputValueClass isSubclassOfClass:[NSNumber class]] &&
                 [outputValueClass isSubclassOfClass:[NSDate class]]);
     } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
         RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSNumber class], error);
         RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSDate class], error);
         //NSNumber *n = [twitterCreatedTime numberFromString:inputValue];
         *outputValue = [NSDate dateWithTimeIntervalSince1970:[inputValue doubleValue]];
         return YES;
     }];
    
    RKAttributeMapping *created_at_mapping = [RKAttributeMapping attributeMappingFromKeyPath:@"created_time" toKeyPath:@"created_time"];
    created_at_mapping.valueTransformer = createdTimeTransformer;//dateTransformer;
    [instagramStatusMapping addPropertyMapping:created_at_mapping];
    
    // Caption
    RKObjectMapping *instagramCaptionMapping = [RKObjectMapping mappingForClass:[InstagramCaption class]];
    [instagramCaptionMapping addAttributeMappingsFromArray:@[@"created_time", @"id", @"text"]];
    
    // Caption.User
    RKObjectMapping *instagramCaptionUserMapping = [RKObjectMapping mappingForClass:[InstagramUser class]];
    [instagramCaptionUserMapping addAttributeMappingsFromArray:@[@"id",@"profile_picture", @"username", @"full_name"]];
    
    [instagramCaptionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"from" toKeyPath:@"from" withMapping:instagramCaptionUserMapping]];
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"caption" toKeyPath:@"caption" withMapping:instagramCaptionMapping]];
    
    // Images
    RKObjectMapping *instagramImagesMapping = [RKObjectMapping mappingForClass:[InstagramImages class]];
    //[instagramImagesMapping addAttributeMappingsFromArray:@[@"low_resolution", @"standard_resolution", @"thumbnail"]];
    
    // Images.Image
    RKObjectMapping *instagramImageMapping = [RKObjectMapping mappingForClass:[InstagramImage class]];
    [instagramImageMapping addAttributeMappingsFromArray:@[@"height", @"url", @"width"]];
    
    [instagramImagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"low_resolution" toKeyPath:@"low_resolution" withMapping:instagramImageMapping]];
    [instagramImagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"standard_resolution" toKeyPath:@"standard_resolution" withMapping:instagramImageMapping]];
    [instagramImagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"thumbnail" toKeyPath:@"thumbnail" withMapping:instagramImageMapping]];
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"images" toKeyPath:@"images" withMapping:instagramImagesMapping]];
    
    // Comments
    RKObjectMapping *instagramCommentsMapping = [RKObjectMapping mappingForClass:[InstagramComments class]];
    [instagramCommentsMapping addAttributeMappingsFromArray:@[@"count"]];
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comments" toKeyPath:@"comments" withMapping:instagramCommentsMapping]];
    
    // Comments.Commentors
    RKObjectMapping *instagramCommenterMapping = [RKObjectMapping mappingForClass:[InstagramCommenter class]];
    [instagramCommenterMapping addAttributeMappingsFromArray:@[@"created_time", @"id", @"text"]];
    
    [instagramCommentsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"data" withMapping:instagramCommenterMapping]];
    
    // Comments.Commentor.From
    RKObjectMapping *instagramCommenterUserMapping = [RKObjectMapping mappingForClass:[InstagramUser class]];
    [instagramCommenterUserMapping addAttributeMappingsFromArray:@[@"id",@"full_name", @"profile_picture",@"username"]];
    [instagramCommenterMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"from" toKeyPath:@"from" withMapping:instagramCommenterUserMapping]];
    
    // Transient User (??)
    RKObjectMapping *instagramTransientUserMapping = [RKObjectMapping mappingForClass:[TransientInstagramUser class]];
    [instagramTransientUserMapping addAttributeMappingsFromArray:@[@"bio", @"full_name", @"id", @"lastUpdated", @"profile_picture", @"username", @"website", @"version"]];
    
    
    RKObjectMapping *instagramCountsMapping = [RKObjectMapping mappingForClass:[InstagramCounts class]];
    [instagramCountsMapping addAttributeMappingsFromArray:@[@"followed_by", @"follows", @"media"]];
    
    [instagramTransientUserMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"counts" toKeyPath:@"counts" withMapping:instagramCountsMapping]];
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"transient_instagram_user" toKeyPath:@"transient_instagram_user" withMapping:instagramTransientUserMapping]];
    
    
    RKObjectMapping *instagramUserMapping = [RKObjectMapping mappingForClass:[InstagramUser class]];
    [instagramUserMapping addAttributeMappingsFromArray:@[@"bio", @"full_name", @"id", @"profile_picture", @"username", @"website"]];
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:instagramUserMapping]];
    
    //RKObjectMapping *instagamLocationMapping
    
    RKObjectMapping *likesMapping = [RKObjectMapping mappingForClass:[InstagramLikes class]];
    [likesMapping addAttributeMappingsFromArray:@[@"count"]];
    
    RKObjectMapping *likeMapping = [RKObjectMapping mappingForClass:[InstagramLike class]];
    [likeMapping addAttributeMappingsFromArray:@[@"full_name", @"id", @"profile_picture", @"username"]];
    
    [likesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"data" withMapping:likeMapping]];
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"likes" toKeyPath:@"likes" withMapping:likesMapping]];
    
    
    
    RKObjectMappingMatcher *instagramStatusMatcher = [RKObjectMappingMatcher matcherWithKeyPath:@"service" expectedValue:@"instagram" objectMapping:instagramStatusMapping];
    
    return instagramStatusMatcher;
}

- (RKObjectMappingMatcher *)flickrStatusMatcher
{
    RKObjectMapping *flickrStatusMapping = [RKObjectMapping mappingForClass:[HuFlickrStatus class]];
    [flickrStatusMapping addAttributeMappingsFromDictionary:@{
                                                              @"id": @"flickr_id",
                                                              @"accuracy": @"accuracy",
                                                              @"context": @"context",
                                                              @"created": @"created",
                                                              @"datetaken": @"datetaken",
                                                              @"datetakengranularity": @"datetakengranularity",
                                                              @"dateupload": @"dateupload",
                                                              @"farm": @"farm",
                                                              @"height_c": @"height_c",
                                                              @"height_l": @"height_l",
                                                              @"height_m": @"height_m",
                                                              @"height_n": @"height_n",
                                                              @"height_o": @"height_o",
                                                              @"height_q": @"height_q",
                                                              @"height_s": @"height_s",
                                                              @"height_sq": @"height_sq",
                                                              @"height_t": @"height_t",
                                                              @"height_z": @"height_z",
                                                              @"iconfarm": @"iconfarm",
                                                              @"iconserver": @"iconserver",
                                                              @"isfamily": @"isfamily",
                                                              @"isfriend": @"isfriend",
                                                              @"ispublic": @"ispublic",
                                                              @"lastUpdated": @"lastUpdated",
                                                              @"lastupdate": @"lastupdate",
                                                              @"latitude": @"latitude",
                                                              @"license": @"license",
                                                              @"longitude": @"longitude",
                                                              @"machine_tags": @"machine_tags",
                                                              @"media": @"media",
                                                              @"media_status": @"media_status",
                                                              @"o_height": @"o_height",
                                                              @"o_width": @"o_width",
                                                              @"originalformat": @"originalformat",
                                                              @"originalsecret": @"originalsecret",
                                                              @"owner": @"owner",
                                                              @"ownername": @"ownername",
                                                              @"pathalias": @"pathalias",
                                                              @"secret": @"secret",
                                                              @"server": @"server",
                                                              @"service": @"service",
                                                              @"tags": @"tags",
                                                              @"title": @"title",
                                                              @"url_c": @"url_c",
                                                              @"url_l": @"url_l",
                                                              @"url_m": @"url_m",
                                                              @"url_n": @"url_n",
                                                              @"url_o": @"url_o",
                                                              @"url_q": @"url_q",
                                                              @"url_s": @"url_s",
                                                              @"url_sq": @"url_sq",
                                                              @"url_t": @"url_t",
                                                              @"url_z": @"url_z",
                                                              @"version": @"version",
                                                              @"views": @"views",
                                                              @"width_c": @"width_c",
                                                              @"width_l": @"width_l",
                                                              @"width_m": @"width_m",
                                                              @"width_n": @"width_n",
                                                              @"width_o": @"width_o",
                                                              @"width_q": @"width_q",
                                                              @"width_s": @"width_s",
                                                              @"width_sq": @"width_sq",
                                                              @"width_t": @"width_t",
                                                              @"width_z": @"width_z"
                                                              }];
    
    // description
    //    RKObjectMapping *descriptionMapping = [RKObjectMapping mappingForClass:[HuFlickrDescription class]];
    //    [descriptionMapping addAttributeMappingsFromArray:@[@"_content"]];
    //
    //    // connect the description to the status
    //    [flickrStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"description" toKeyPath:@"description" withMapping:descriptionMapping]];
    
    // we know its flickr if the service element says so..
    RKObjectMappingMatcher *flickrStatusMatcher = [RKObjectMappingMatcher matcherWithKeyPath:@"service" expectedValue:@"flickr" objectMapping:flickrStatusMapping];
    return flickrStatusMatcher;
}


- (BOOL)usernameExists:(NSString *)username
{
    
    __block bool exists = true;
    
    NSString *json = $str(@"{\"check_username\" : \"%@\"}", username);
    
    [client setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request =[client requestWithMethod:@"POST" path:@"/rest/user/username/exists" parameters:nil];
    request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    LOG_GENERAL(0, @"%@", request);
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        LOG_GENERAL(0, @"Success %@", responseObject);
        //NSString * result = [responseObject objectForKey:@"result"];
        NSString * val = (NSString*)[responseObject objectForKey:@"exists"];
        if([@"1" isEqualToString:val]) {
            exists = true;
        } else {
            exists = false;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        LOG_GENERAL(0, @"Failure %@", error);
    }];
    
    [operation start];
    [operation waitUntilFinished];
    return exists;
}

#pragma mark stuff for authenticating with service through server side stuff
- (NSURL *)urlForInstagramAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/instagram?access_token=%@",[client baseURL],[self access_token]];
    result = [NSURL URLWithString:url];
    return result;
}

- (NSURL *)urlForTwitterAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/twitter?access_token=%@", [client baseURL], [self access_token]];
    result = [NSURL URLWithString:url];
    return result;
}

- (NSURL *)urlForFlickrAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/flickr?access_token=%@", [client baseURL], [self access_token]];
    result = [NSURL URLWithString:url];
    return result;
}

- (NSURL *)urlForFoursquareAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/foursquare?access_token=%@", [client baseURL], [self access_token]];
    result = [NSURL URLWithString:url];
    return result;
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSArray *trustedHosts = [NSArray arrayWithObjects:@"localhost",nil];
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if ([trustedHosts containsObject:challenge.protectionSpace.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end



//    RKValueTransformer *dateTransformer = [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass, __unsafe_unretained Class outputValueClass) {
//        //
//        return ([inputValueClass isSubclassOfClass:[NSString class]] && [outputValueClass isSubclassOfClass:[NSDate class]]);
//    } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
//        //
//        RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
//        RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSDate class], error);
//
//        *outputValue = [twitter_formatter dateFromString:inputValue];
//
//        return YES;
//    }];
