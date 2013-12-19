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

@implementation HuUserHandler


@synthesize client;
@synthesize humans_user;


- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
    
}

- (void)commonInit
{
    client = [HuHumansHTTPClient sharedDevClient];
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
    LOG_GENERAL(0, @"%@", request);
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        LOG_NETWORK(0, @"Success %@", responseObject);
        [self setAccess_token:[responseObject objectForKey:@"access_token"]];
        [self userGetWithCompletionHandler:completionHandler];
        
//        if(completionHandler) {
//            completionHandler(true, nil);
//        }
        //NSString * result = [responseObject objectForKey:@"result"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        LOG_NETWORK(0, @"Failure %@", error);
        [self setAccess_token:nil];
//        if(completionHandler) {
//            completionHandler(false, error);
//        }
    }];
    
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
    
//
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
    

/*
    [objectManager getObjectsAtPath:@"/rest/user/get" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        LOG_NETWORK(0, @"Success %@", [mappingResult firstObject]);
        humans_user = [mappingResult firstObject];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKErrorMessage *errorMessage =  [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        LOG_NETWORK(0, @"Failed.. %@", error);
        LOG_NETWORK(0, @"%@", errorMessage);
    }];
*/
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
             /**
              UIImageView *iv = [UIImageView new];
              [iv setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[item largeImageURL]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
              //
              //CGImageRef imageRef = [image CGImage];
              //LOG_INSTAGRAM_IMAGE(0, CGImageGetWidth([image CGImage]), CGImageGetHeight([image CGImage]), UIImageJPEGRepresentation(image, 1.0));
              [item setLargeProfileImage:image];
              
              } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
              //
              LOG_ERROR(0, @"Error %@", error);
              }];
              **/
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


@end
