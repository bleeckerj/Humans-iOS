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
#import <ConciseKit.h>
#import "HuFriend.h"
#import "HuUser.h"
#import "HuHuman.h"
#import "HuServices.h"
#import "HuOnBehalfOf.h"
#import "HuServiceUser.h"
#import "HuAppDelegate.h"

@implementation HuUserHandler

@synthesize client;
@synthesize humans_user;
@synthesize statusForHumanId;

- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
    
}

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
    statusForHumanId = [[NSMutableDictionary alloc]init];
    client = [HuHumansHTTPClient sharedDevClient];
    
    //LOG_GENERAL(0, @"allowss invalid ssl cert? %@", [client allowsInvalidSSLCertificate]?@"YES":@"NO");
    
    
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // Not reachable
            LOG_NETWORK(0, @"Network is down..");
        } else {
            // Reachable
            LOG_NETWORK(0, @"Network is okay..");
            
        }
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            // On wifi
            LOG_NETWORK(0, @"Network is wifi..");
        }
    }];
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
        [self userGetWithCompletionHandler:completionHandler];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        LOG_NETWORK(0, @"Failure %@", error);
        [self setAccess_token:nil];
    }];
    
    
    
    
    [operation setSSLPinningMode:AFSSLPinningModeNone];
    //[operation setAllowsInvalidSSLCertificate:YES];
    [operation start];
    [operation waitUntilFinished];
    
}

- (void)userGetWithCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    RKObjectManager *objectManager = [[RKObjectManager alloc]initWithHTTPClient:client];
    
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[HuUser class]];
    [userMapping addAttributeMappingsFromArray:@[@"email",@"id",@"username"]];
    
    RKObjectMapping *humansMappping = [RKObjectMapping mappingForClass:[HuHuman class]];
    [humansMappping addAttributeMappingsFromArray:@[@"humanid", @"name"]];
    
    RKObjectMapping *servicesMapping = [RKObjectMapping mappingForClass:[HuServices class]];
    [servicesMapping addAttributeMappingsFromArray:@[@"serviceName", @"serviceUserID", @"serviceUsername"]];
    
    RKObjectMapping *onBehalfOfMapping = [RKObjectMapping mappingForClass:[HuOnBehalfOf class]];
    [onBehalfOfMapping addAttributeMappingsFromArray:@[@"serviceName", @"serviceUserID", @"serviceUsername"]];
    
    RKObjectMapping *serviceUserMapping = [RKObjectMapping mappingForClass:[HuServiceUser class]];
    [serviceUserMapping addAttributeMappingsFromArray:@[@"id", @"imageURL", @"lastUpdated", @"service", @"serviceID", @"username"]];
    
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
                                        withMapping:serviceUserMapping]];
    
    // onBehalfOf within serviceUsers (friends)
    [serviceUserMapping addPropertyMapping:[RKRelationshipMapping
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
        LOG_NETWORK(0, @"User Get Success %@", [mappingResult firstObject]);
        humans_user = [mappingResult firstObject];
        
        LOG_GENERAL(0, @"%@", [humans_user dictionary]);
        if(completionHandler) {
            completionHandler(true, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //
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

- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler
{
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *friendsMapping = [RKObjectMapping mappingForClass:[HuFriend class]];
    [friendsMapping addAttributeMappingsFromArray:@[@"imageURL", @"largeImageURL", @"service", @"serviceID", @"username"]];
    
    RKResponseDescriptor *dynamicResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:friendsMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:dynamicResponseDescriptor];
    
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
         LOG_UI_VERBOSE(0, @"success: mappings %@", mappingResult);
         NSMutableArray *results = [NSMutableArray new];
         for (HuFriend *item in [mappingResult array]) {
             [results addObject:item];
         }
         if(completionHandler) {
             completionHandler(results);
         }
     }
     
                            failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         LOG_NETWORK(0, @"failure: operation: %@ \n\nerror: %@", operaton, error);
         LOG_NETWORK(0, @"errorMessage: %@", [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey]);
         if(completionHandler) {
             completionHandler(nil);
         }
     }];
    
}


- (void)getStatusForHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    RKDynamicMapping *dynamicMapping = [RKDynamicMapping new];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    [dynamicMapping addMatcher:[self twitterStatusMatcher]];
    [dynamicMapping addMatcher:[self instagramStatusMatcher]];
    
    // Success
    RKResponseDescriptor *dynamicResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dynamicMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"status" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:dynamicResponseDescriptor];

    // Errors
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];

    RKResponseDescriptor *errorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:@"message"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    [objectManager addResponseDescriptor:errorDescriptor];

    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self access_token], @"access_token", [aHuman humanid], @"humanid", @"1", @"page", nil];
    
    //__block NSArray *array;
    
    [objectManager getObjectsAtPath:@"/rest/human/status"
                         parameters:queryParams
      success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         
        // NSArray *result = [mappingResult array];
         LOG_GENERAL(0, @"success: mappings: %@", [mappingResult array]);
         [[self statusForHumanId] setObject:[mappingResult array] forKey:[aHuman humanid]];
         if(completionHandler) {
             completionHandler(true, nil);
         }
    }
      failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         LOG_GENERAL (0, @"failure: operation: %@ \n\nerror: %@", operaton, error);
         if(completionHandler) {
             completionHandler(false, error);
         }
     }];
    
    
    
}

- (RKObjectMappingMatcher *)twitterStatusMatcher
{
    RKObjectMapping *twitterStatusMapping = [RKObjectMapping mappingForClass:[TwitterStatus class]];
    [twitterStatusMapping addAttributeMappingsFromDictionary:@{
                                                               @"id" : @"tweet_id",
                                                               @"text" : @"text",
                                                               //@"user" : @"user",
                                                               @"created_at" : @"created_at",
                                                               @"service" : @"name"
                                                               }];
    //twitterUserMapping.dateFormatters = [NSArray arrayWithObject: dateFormatter];

    
    RKObjectMapping *twitterUserMapping = [RKObjectMapping mappingForClass:[TwitterUser class]];
    [twitterUserMapping addAttributeMappingsFromArray:@[@"id", @"lastUpdated", @"created_at", @"description", @"favourites_count", @"following", @"followers_count", @"friends_count", @"geo_enabled", @"location", @"name", @"screen_name", @"time_zone", @"url", @"utc_offset", @"verified"]];
    
    
    
    [twitterStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                         toKeyPath:@"user"
                                                                                       withMapping:twitterUserMapping]];
    
    RKObjectMappingMatcher *twitterStatusMatcher = [RKObjectMappingMatcher matcherWithKeyPath:@"service" expectedValue:@"twitter" objectMapping:twitterStatusMapping];
    
    
    return twitterStatusMatcher;
}


- (RKObjectMappingMatcher *)instagramStatusMatcher
{
    RKObjectMapping *instagramStatusMapping = [RKObjectMapping mappingForClass:[InstagramStatus class]];
    [instagramStatusMapping addAttributeMappingsFromDictionary:@{@"id": @"instagram_id",
                                                                 //@"caption", @"caption",
                                                                 @"created_time": @"created_time",
                                                                 @"service" : @"service"
                                                                 }];
    
    RKObjectMapping *instagramCaptionMapping = [RKObjectMapping mappingForClass:[InstagramCaption class]];
    [instagramCaptionMapping addAttributeMappingsFromArray:@[@"created_time", @"id", @"text"]];
    
    RKObjectMapping *instagramCaptionUserMapping = [RKObjectMapping mappingForClass:[InstagramUser class]];
    [instagramCaptionUserMapping addAttributeMappingsFromArray:@[@"id",@"profile_picture", @"username", @"full_name"]];
    
    [instagramCaptionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"from" toKeyPath:@"from" withMapping:instagramCaptionUserMapping]];
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"caption" toKeyPath:@"caption" withMapping:instagramCaptionMapping]];
    
    RKObjectMapping *instagramImagesMapping = [RKObjectMapping mappingForClass:[InstagramImages class]];
    //[instagramImagesMapping addAttributeMappingsFromArray:@[@"low_resolution", @"standard_resolution", @"thumbnail"]];
    
    
    RKObjectMapping *instagramImageMapping = [RKObjectMapping mappingForClass:[InstagramImage class]];
    [instagramImageMapping addAttributeMappingsFromArray:@[@"height", @"url", @"width"]];
    
    [instagramImagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"low_resolution" toKeyPath:@"low_resolution" withMapping:instagramImageMapping]];
    [instagramImagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"standard_resolution" toKeyPath:@"standard_resolution" withMapping:instagramImageMapping]];
    [instagramImagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"thumbnail" toKeyPath:@"thumbnail" withMapping:instagramImageMapping]];
    
    
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"images" toKeyPath:@"images" withMapping:instagramImagesMapping]];
  
    RKObjectMapping *instagramTransientUserMapping = [RKObjectMapping mappingForClass:[TransientInstagramUser class]];
    [instagramTransientUserMapping addAttributeMappingsFromArray:@[@"bio", @"full_name", @"id", @"lastUpdated", @"profile_picture", @"username", @"website", @"version"]];
    
    
    RKObjectMapping *instagramCountsMapping = [RKObjectMapping mappingForClass:[InstagramCounts class]];
    [instagramCountsMapping addAttributeMappingsFromArray:@[@"followed_by", @"follows", @"media"]];
    
    [instagramTransientUserMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"counts" toKeyPath:@"counts" withMapping:instagramCountsMapping]];
    
    [instagramStatusMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"transient_instagram_user" toKeyPath:@"transient_instagram_user" withMapping:instagramTransientUserMapping]];

    RKObjectMappingMatcher *instagramStatusMatcher = [RKObjectMappingMatcher matcherWithKeyPath:@"service" expectedValue:@"instagram" objectMapping:instagramStatusMapping];
    
    return instagramStatusMatcher;
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
