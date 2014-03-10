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
//#import <RestKit.h>
#import <RNDecryptor.h>
#import <ObjectiveSugar.h>
#import "Flurry.h"

#import <ConciseKit.h>
#import "HuFriend.h"
#import "HuUser.h"
#import "HuHuman.h"
#import "HuOnBehalfOf.h"
#import "HuServiceUser.h"
#import "HuAppDelegate.h"
#import <WSLObjectSwitch.h>
#import <Parse/Parse.h>

@implementation HuUserHandler

@synthesize huRequestOperationManager;
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


- (void)commonInit
{
    twitter_formatter = [NSDateFormatter new];
    [twitter_formatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];
    
    statusForHumanId = [[NSMutableDictionary alloc]init];
    
#pragma mark This is where you set either the sharedDevhuRequestOperationManager or the sharedProdhuRequestOperationManager
    
    huRequestOperationManager = [HuHumansHTTPSessionManager sharedDevClient];
    
    __block HuUserHandler *bself = self;
    
    [huRequestOperationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
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


- (void)parseCreateNewUser:(HuUser *)aUser password:(NSString *)aPassword withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    PFUser *user = [PFUser user];
    user.username = [aUser username];
    user.password = aPassword;
    user.email = [aUser email];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //
        if(!error) {
            [self createNewUser:aUser password:aPassword withCompletionHandler:^(id data, BOOL success, NSError *error) {
                //
                if(completionHandler) {
                    completionHandler(data, YES, nil);
                }
            }];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            LOG_ERROR(0, @"%@ %@", errorString, error);
            if(completionHandler) {
                completionHandler([error userInfo], NO, error);
            }
        }
    }];
}

- (void)createNewUser:(HuUser *)aUser password:(NSString *)aPassword withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSString *path = @"/rest/user/new";
    NSError *err = nil;
    NSDictionary *simple = [[NSDictionary alloc]initWithObjectsAndKeys:aUser.username, @"username", aPassword, @"password", aUser.email, @"email", nil];

    NSData *data = [NSJSONSerialization dataWithJSONObject:simple options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonDataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSData *requestData = [jsonDataStr dataUsingEncoding:NSUTF8StringEncoding];

    [huRequestOperationManager POST:path parameters:nil data:requestData success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        LOG_NETWORK(0, @"Success: %@", task.response);
        
        
        // success in the request, not necessarily creating a user successfully
        NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedDescriptionKey, [responseObject valueForKey:@"message"], nil];
        NSError *err = [[NSError alloc]initWithDomain:@"humans" code:100 userInfo:message];
        
        NSString *result = [responseObject valueForKey:@"result"];
        
        NSDictionary *dimensions = @{@"username": [aUser username], @"result": result};
        [PFAnalytics trackEvent:@"create-new-user" dimensions:dimensions];
        
        [Flurry logEvent:@"create-new-user" withParameters:dimensions];
        
        [WSLObjectSwitch switchOn:result
                     defaultBlock:^{
                         //
                         if(completionHandler) {
                             completionHandler(responseObject, NO, err);
                         }
                         
                     } cases:
         @"fail", ^{
             LOG_ERROR(0, @"%@", [responseObject valueForKey:@"message"] );
             
             if(completionHandler) {
                 completionHandler(responseObject, NO, err);
             }
         },
         @"success", ^{
             if(completionHandler) {
                 completionHandler(responseObject, YES, nil);
             }
         }];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(completionHandler) {
            completionHandler(nil ,NO, error);
        }
    }];
    
/*
    NSMutableURLRequest *request =[huRequestOperationManager requestWithMethod:@"POST" path:path parameters:nil];
    
    request.timeoutInterval = 30.000000;
    
    // Request Operation
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    NSDictionary *simple = [[NSDictionary alloc]initWithObjectsAndKeys:aUser.username, @"username", aPassword, @"password", aUser.email, @"email", nil];
    
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:simple options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonDataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData *requestData = [jsonDataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        LOG_NETWORK(0, @"Success: Status Code %d", operation.response.statusCode);
        
        
        // success in the request, not necessarily creating a user successfully
        NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedDescriptionKey, [responseObject valueForKey:@"message"], nil];
        NSError *err = [[NSError alloc]initWithDomain:@"humans" code:100 userInfo:message];
        
        NSString *result = [responseObject valueForKey:@"result"];
        
        NSDictionary *dimensions = @{@"username": [aUser username], @"result": result};
        [PFAnalytics trackEvent:@"create-new-user" dimensions:dimensions];

        [Flurry logEvent:@"create-new-user" withParameters:dimensions];
        
        [WSLObjectSwitch switchOn:result
                     defaultBlock:^{
                         //
                         if(completionHandler) {
                             completionHandler(responseObject, NO, err);
                         }
                         
                     } cases:
         @"fail", ^{
             LOG_ERROR(0, @"%@", [responseObject valueForKey:@"message"] );

             if(completionHandler) {
                 completionHandler(responseObject, NO, err);
             }
         },
         @"success", ^{
             if(completionHandler) {
                 completionHandler(responseObject, YES, nil);
             }
         }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        if(completionHandler) {
            completionHandler(nil ,NO, nil);
        }
    }];
    
    // connection
    [operation start];
 */
}


- (void)userAddHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    NSString *path = @"/rest/user/add/human";
    NSString *jsonRequest = [aHuman jsonString];
    NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];

    [huRequestOperationManager POST:path parameters:nil data:requestData success:^(NSURLSessionDataTask *task, id responseObject) {
        [Flurry logEvent:[NSString stringWithFormat:@"Successfully added a human %@ \n%@", [aHuman name], [aHuman jsonString]]];
        
        if(completionHandler) {
            completionHandler(true, nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        [Flurry logEvent:[NSString stringWithFormat:@"Failed adding a human %@ %@", [aHuman name], error]];
        
        if(completionHandler) {
            completionHandler(false, error);
        }

    }];
    
}

#pragma mark Basically login /oauth2/token?grant_typ
- (void)userRequestTokenForUsername:(NSString *)username forPassword:(NSString *)password withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    LOG_ERROR(0, @"Hello %@ %@", username, password);
    NSString* buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CWBuildNumber"];
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [huRequestOperationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    NSString *path =[NSString stringWithFormat:@"/oauth2/token"];
    NSDictionary *params = @{@"grant_type": @"password", @"client_id": CLIENT_NAME, @"build": buildNumber, @"ver": version};
    
    
    [huRequestOperationManager GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        LOG_NETWORK(0, @"Success %@", responseObject);
        [self setAccess_token:[responseObject objectForKey:@"access_token"]];
        [huRequestOperationManager.requestSerializer setAuthorizationHeaderFieldWithToken:self.access_token];
        [self getHumansWithCompletionHandler:completionHandler];
  
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Failure %@", error);
        [Flurry logError:error.localizedDescription message:@"" error:error];
        
        [self setAccess_token:nil];
        if(completionHandler) {
            completionHandler(NO, error);
        }
        

    }];

}

#pragma --- mark get the user's humans as well as the user's details, id, services, username, etc.

- (void)getHumansWithCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    [huRequestOperationManager GET:@"/rest/user/get" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        [Flurry logEvent:[NSString stringWithFormat:@"Successful getHumansWithCompletion %@" , [humans_user username]]];
        
        humans_user = [[HuUser alloc]initWithJSONDictionary:responseObject];
        
        LOG_GENERAL(0, @"%@", [humans_user dictionary]);
        if(completionHandler) {
            completionHandler(true, nil);
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Flurry logEvent:[NSString stringWithFormat:@"Failed getHumansWithCompletion %@" , [humans_user username]]];
        
        LOG_NETWORK(0, @"User Get Failed.. %@", error);
        LOG_NETWORK(0, @"%@", [error localizedDescription]);
        if(completionHandler) {
            completionHandler(false, error);
        }

    }];
}


#pragma mark /status/count
-(void)getStatusCountsWithCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSString *path =@"/rest/human/status/count";
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            completionHandler(responseObject, true, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        [Flurry logError:error.localizedDescription message:@"" error:error];
        
        if(completionHandler) {
            completionHandler(nil, false, error);
        }
    }];
}


#pragma mark /status/count/{humanid}
- (void)getStatusCountForHuman:(HuHuman *)human withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSString *path =[NSString stringWithFormat:@"/rest/human/status/count/%@", [human humanid]];
    
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            completionHandler([responseObject objectForKey:@"count"], true, nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        [Flurry logError:error.localizedDescription message:@"" error:error];
        
        if(completionHandler) {
            completionHandler(nil, false, error);
        }

    }];
}

#pragma mark /status/count/{humanid}/after/{timestamp}
- (void)getStatusCountForHuman:(HuHuman *)human after:(NSTimeInterval)timestamp withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
   // [huRequestOperationManager getStatusCountForHuman:human after:timestamp withCompletionHandler:completionHandler];
    NSNumber *time = [NSNumber numberWithLong:timestamp];
    
    NSString *path = [NSString stringWithFormat:@"/rest/human/status/count/%@/after/%@", [human humanid],[time stringValue]];
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        LOG_TODO(0, @"%@", responseObject);
        if(completionHandler) {
            completionHandler(responseObject, YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_ERROR(0, @"%@", error);
        if(completionHandler) {
            completionHandler(nil, NO, error);
        }
        
    }];
}

#pragma mark Delete a service connection for a user
- (void)userRemoveService:(HuServices *)aService withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    [Flurry logEvent:[NSString stringWithFormat:@"Attempting userRemoveServiceUser for %@", [aService description]]];
    
    NSString *path = @"/rest/user/rm/service";
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [Flurry logEvent:[NSString stringWithFormat:@"Success for %@ response=%@", [aService description], responseObject]];
        if(completionHandler) {
            
            id result = [responseObject objectForKey:@"result"];
            if(result != nil && [result isKindOfClass:[NSString class]]) {
                if([result isEqualToString:@"success"]) {
                    completionHandler(YES, nil);
                } else {
                    NSString *message = [responseObject objectForKey:@"message"];
                    if(message == nil) {
                        message = @"no message";
                    }
                    NSError *err = [[NSError alloc]initWithDomain:@"error" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:result, @"result", message, @"message", nil]];
                    completionHandler(NO, err);
                    
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        
        [Flurry logError:error.localizedDescription message:@"" error:error];
       if(completionHandler) {
            completionHandler(NO, error);
        }
  
    }];
    /*
    [huRequestOperationManager setParameterEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request =[huRequestOperationManager requestWithMethod:@"POST" path:path parameters:nil];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30.000000;
    request.HTTPBody = [aService json];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    
    // Request Operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Progress & Completion blocks
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG_NETWORK(0, @"Success: Status Code %d", operation.response.statusCode);
        [Flurry logEvent:[NSString stringWithFormat:@"Success for %@ response=%@", [aService description], responseObject]];
        NSError *readError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&readError];
       // BOOL valid = [NSJSONSerialization isValidJSONObject:json];
        if(completionHandler) {
            
            id result = [json objectForKey:@"result"];
            if(result != nil && [result isKindOfClass:[NSString class]]) {
                if([result isEqualToString:@"success"]) {
                    completionHandler(YES, nil);
                } else {
                    NSString *message = [responseObject objectForKey:@"message"];
                    if(message == nil) {
                        message = @"no message";
                    }
                    NSError *err = [[NSError alloc]initWithDomain:@"error" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:result, @"result", message, @"message", nil]];
                    completionHandler(NO, err);
                    
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        
        [Flurry logError:error.localizedDescription message:@"" error:error];
        
        
        
        if(completionHandler) {
            completionHandler(NO, error);
        }
    }];
    
    // Connection
    
    [operation start];
    */
}

- (void)userAddServiceUsers:(NSMutableArray *)arrayOfServiceUsers forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    
}

#pragma mark add a service user {humanid}/add/serviceuser/ with JSON for the service user
- (void)userAddServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithData)completionHandler
{

    [huRequestOperationManager userAddServiceUser:aServiceUser forHuman:aHuman withProgress:nil withCompletionHandler:completionHandler];
}

#pragma mark remove a service user (someone as part of a human composite) by ID /rest/rm/{serviceuserid}/serviceuser
- (void)userRemoveServiceUser:(HuServiceUser *)aServiceUser withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    NSString *path = [NSString stringWithFormat:@"/rest/user/rm/%@/serviceuser", [aServiceUser id]];
    
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            completionHandler(YES, nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        [Flurry logError:error.localizedDescription message:@"" error:error];
        
        if(completionHandler) {
            completionHandler(NO, error);
        }

    }];
    
}

#pragma mark Delete Human By ID /user/rm/{humanid}/human
- (void)userRemoveHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    NSString *path = [NSString stringWithFormat:@"/rest/user/rm/%@/human", [aHuman humanid]];
    
    
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            completionHandler(YES, nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(completionHandler) {
            completionHandler(NO, error);
        }

    }];
    
}


#pragma mark Get Friends
- (void)userFriendsGet:(ArrayOfResultsHandler)completionHandler
{
    NSString *path = @"rest/user/friends/get";
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *result = [[NSMutableArray alloc]init];
        [responseObject each:^(id object) {
            HuFriend *friend = [[HuFriend alloc]initWithJSONDictionary:object];
            [result addObject:friend];
        }];
        if(completionHandler) {
            completionHandler(result);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Flurry logError:[error localizedDescription] message:[error description] error:error];
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

#pragma mark --- status for human ---


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

- (void)getStatusForHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    [self getStatusForHuman:(HuHuman *)aHuman atPage:0 withCompletionHandler:(CompletionHandlerWithResult)completionHandler];
    
}

- (void)getStatusForHuman:(HuHuman *)aHuman atPage:(int)aPage withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    NSString *humanid = [aHuman humanid];
    
    NSDictionary *queryParams;

    NSNumber *page = [NSNumber numberWithInt:aPage];
    
    queryParams = @{@"humanid": humanid, @"page":page};
    
    [huRequestOperationManager GET:@"/rest/human/status" parameters:queryParams success:^(NSURLSessionDataTask *task, id responseObject) {
        LOG_GENERAL(0, @"success: %@", responseObject);
        //[[self statusForHumanId] setObject:[responseObject objectForKey:@"status"] forKey:[aHuman humanid]];
        [self setLastStatusResultHeader:[responseObject objectForKey:@"head"]];

        NSArray *sent_status = [responseObject objectForKey:@"status"];
        NSMutableArray *saved_status = [[NSMutableArray alloc]initWithCapacity:[sent_status count]];
        [sent_status each:^(id object) {
            LOG_TODO(0, @"service=%@", [object valueForKey:@"service"]);
            if([[object valueForKey:@"service"] isEqualToString:@"flickr"]) {
                HuFlickrStatus *status = [[HuFlickrStatus alloc]initWithJSONDictionary:object];
                [saved_status addObject:status];
            }
            if([[object valueForKey:@"service"] isEqualToString:@"instagram"]) {
                InstagramStatus *status = [[InstagramStatus alloc]initWithJSONDictionary:object];
                [saved_status addObject:status];
            }
            if([[object valueForKey:@"service"] isEqualToString:@"twitter"]) {
                HuTwitterStatus *status = [[HuTwitterStatus alloc]initWithJSONDictionary:object];
                [saved_status addObject:status];
            }
            if([[object valueForKey:@"service"] isEqualToString:@"foursquare"]) {
                HuFoursquareCheckin *status = [[HuFoursquareCheckin alloc]initWithJSONDictionary:object];
                [saved_status addObject:status];
            }
        }];

        [[self statusForHumanId] setObject:saved_status forKey:[aHuman humanid]];
        
        LOG_GENERAL(0, @"%@", [self lastStatusResultHeader]);
        if(completionHandler) {
            completionHandler(true, nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_GENERAL (0, @"failure: error: %@", error);
        LOG_GENERAL(0, @"%@", [error localizedDescription] );
        [Flurry logError:error.localizedDescription message:@"" error:error];
        
        [self setLastStatusResultHeader:nil];
        [[self statusForHumanId]removeObjectForKey:humanid];
        if(completionHandler) {
            completionHandler(false, error);
        }
        
    }];
}

/*
- (void)getStatusForHuman:(HuHuman *)aHuman atPage:(int)aPage withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPRequestOperationManager:huRequestOperationManager];
    
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
    
    
    // huRequestOperationManager Errors
    RKObjectMapping *huRequestOperationManagerErrorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [huRequestOperationManagerErrorMapping addPropertyMapping:
     [RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    RKResponseDescriptor *huRequestOperationManagerErrorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:huRequestOperationManagerErrorMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"message"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClasshuRequestOperationManagerError)];
    
    [objectManager addResponseDescriptor:huRequestOperationManagerErrorDescriptor];
    
    
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
         [Flurry logError:error.localizedDescription message:@"" error:error];
         
         [self setLastStatusResultHeader:nil];
         [[self statusForHumanId]removeObjectForKey:humanid];
         if(completionHandler) {
             completionHandler(false, error);
         }
     }];
    
    
    
}
*/

/*
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
                                                        // @"created_at",
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
    // entities.user_mentions
    //
    RKObjectMapping *twitterEntitiesUserMentionsMapping = [RKObjectMapping mappingForClass:[HuTwitterEntitiesUserMentions class]];
    [twitterEntitiesUserMentionsMapping addAttributeMappingsFromArray:@[@"expanded_url", @"indices", @"display_url", @"url"]];
    [twitterStatusEntitiesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_mentions" toKeyPath:@"user_mentions" withMapping:twitterEntitiesUserMentionsMapping]];
    
    
    
    //
    // entities.urls
    //
    RKObjectMapping *twitterEntitiesURLsMapping = [RKObjectMapping mappingForClass:[HuTwitterEntitiesURL class]];
    [twitterEntitiesURLsMapping addAttributeMappingsFromArray:@[@"expanded_url", @"indices", @"display_url", @"url"]];
    [twitterStatusEntitiesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"urls" toKeyPath:@"urls" withMapping:twitterEntitiesURLsMapping]];
    
    
    
    
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

*/

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

/*
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
*/

- (void)usernameExists:(NSString *)username withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    __block bool exists = true;
    NSString *json = $str(@"{\"check_username\" : \"%@\"}", username);
    
    [huRequestOperationManager POST:@"/rest/user/username/exists" parameters:nil data:[json dataUsingEncoding:NSUTF8StringEncoding] success:^(NSURLSessionDataTask *task, id responseObject) {
        CFBooleanRef result = ( CFBooleanRef)CFBridgingRetain([responseObject objectForKey:@"exists"]);
        if(result == kCFBooleanTrue) {
            exists = true;
        } else {
            exists = false;
        }
        if(completionHandler) {
            completionHandler(exists, nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_GENERAL(0, @"Failure %@", error);
        if(completionHandler) {
            completionHandler(exists, error);
        }

    }];
    
    /*
    [huRequestOperationManager setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request =[huRequestOperationManager requestWithMethod:@"POST" path:@"/rest/user/username/exists" parameters:nil];
    request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    LOG_GENERAL(0, @"%@", request);
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        LOG_GENERAL(0, @"Success %@", responseObject);
        //NSString * result = [responseObject objectForKey:@"result"];
        CFBooleanRef result = ( CFBooleanRef)CFBridgingRetain([responseObject objectForKey:@"exists"]);
        if(result == kCFBooleanTrue) {
            exists = true;
        } else {
            exists = false;
        }
        if(completionHandler) {
            completionHandler(exists, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        LOG_GENERAL(0, @"Failure %@", error);
        if(completionHandler) {
            completionHandler(exists, error);
        }
    }];
    
    [operation start];
     */
}

#pragma mark access token crap for a specific service
// given a HuService this will try and get the access token particulars for that service + user

- (void)getAuthForService:(HuServices *)service with:(CompletionHandlerWithData)completionHandler
{
    
    NSString *path = [NSString stringWithFormat:@"/rest/user/get/auth/%@/%@", [service serviceName], [service serviceUserID]];
//    NSMutableURLRequest *request =[huRequestOperationManager requestWithMethod:@"GET" path:path parameters:nil];
//    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
//    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
//    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @try {
        LOG_GENERAL(0, @"Success %@", responseObject);
        NSString *serviceNameCap = [[service serviceName]uppercaseString];
        NSString *general =[NSString stringWithFormat:@"humans-%@_CF_PV", serviceNameCap];
        NSString *parcel_key = [NSString stringWithFormat:@"client-%@_CF_PV", serviceNameCap];
        
        
        NSError *err;
        NSString *encryptedParcelStr = [responseObject valueForKey:@"parcel"];
        NSData *parcelData = [[NSData alloc]initWithBase64EncodedString:encryptedParcelStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *decryptedParcelData =[RNDecryptor decryptData:parcelData
                                                 withPassword:parcel_key
                                                        error:&err];
        NSString *foo = [[NSString alloc]initWithData:decryptedParcelData encoding:NSUTF8StringEncoding];
        id decryptedParselJson = [NSJSONSerialization JSONObjectWithData:[foo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
        
        
        
        NSString *encryptedCK_DataStr = [decryptedParselJson valueForKey:@"ck"];
        
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptedCK_DataStr
                                                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *decryptedCK_Data = [RNDecryptor decryptData:data
                                               withPassword:general
                                                      error:&err];
        NSString *consumer_key = [[NSString alloc]initWithData:decryptedCK_Data encoding:NSUTF8StringEncoding];
        
        
        NSString *encryptedCS_DataStr = [decryptedParselJson valueForKey:@"cs"];
        
        
        data = [[NSData alloc] initWithBase64EncodedString:encryptedCS_DataStr
                                                   options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *decryptedCS_Data = [RNDecryptor decryptData:data
                                               withPassword:general
                                                      error:&err];
        NSString *consumer_secret = [[NSString alloc]initWithData:decryptedCS_Data encoding:NSUTF8StringEncoding];
        
        
        
        NSString *encryptedTK_DataStr = [decryptedParselJson valueForKey:@"tk"];
        data = [[NSData alloc]initWithBase64EncodedString:encryptedTK_DataStr
                                                  options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *decryptedTK_Data = [RNDecryptor decryptData:data
                                               withPassword:general
                                                      error:&err];
        
        NSString *token_key = [[NSString alloc]initWithData:decryptedTK_Data encoding:NSUTF8StringEncoding];
        
        
        NSString *encryptedSK_DataStr = [decryptedParselJson valueForKey:@"ts"];
        data = [[NSData alloc]initWithBase64EncodedString:encryptedSK_DataStr
                                                  options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *decryptedSK_Data = [RNDecryptor decryptData:data
                                               withPassword:general
                                                      error:&err];
        NSString *token_secret = [[NSString alloc]initWithData:decryptedSK_Data encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:consumer_key, @"consumer_key", consumer_secret, @"consumer_secret", token_key, @"token_key", token_secret, @"token_secret", nil];
        
        if(completionHandler) {
            completionHandler(result, YES, nil);
        }
        LOG_GENERAL(0, @"What we got..%@", result);
        }
        @catch (NSException *ne) {
            NSString *loc = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
            NSError *error = [[NSError alloc]initWithDomain:@"HuUserHandler" code:99 userInfo:@{@"reason": [ne reason], @"name": [ne name], @"place": loc, @"exception": ne}];
            [Flurry logError:[ne reason] message:[ne reason] error:error];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_GENERAL(0, @"Failure %@", error);
        if (completionHandler) {
            completionHandler(nil, NO, error);
        }
    }];
    
    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    [operation start];
//    [operation waitUntilFinished];
    
}

#pragma mark stuff for authenticating with service through server side stuff
- (NSURL *)urlForInstagramAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/instagram?access_token=%@",[huRequestOperationManager baseURL],[self access_token]];
    result = [NSURL URLWithString:url];
    return result;
}

- (NSURL *)urlForTwitterAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/twitter?access_token=%@", [huRequestOperationManager baseURL], [self access_token]];
    result = [NSURL URLWithString:url];
    return result;
}

- (NSURL *)urlForFlickrAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/flickr?access_token=%@", [huRequestOperationManager baseURL], [self access_token]];
    result = [NSURL URLWithString:url];
    return result;
}

- (NSURL *)urlForFoursquareAuthentication
{
    NSURL *result;
    NSString *url = [NSString stringWithFormat:@"%@/rest/auth/foursquare?access_token=%@", [huRequestOperationManager baseURL], [self access_token]];
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



