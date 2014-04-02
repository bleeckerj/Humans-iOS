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
#import <RNDecryptor.h>
#import <ObjectiveSugar.h>
//#import "Flurry.h"
#import <ConciseKit.h>
#import "HuFriend.h"
#import "HuUser.h"
#import "HuHuman.h"
#import "HuOnBehalfOf.h"
#import "HuServiceUser.h"
#import "HuAppDelegate.h"
#import <WSLObjectSwitch.h>
#import <Parse/Parse.h>

#pragma mark This is where you set either the sharedDevhuRequestOperationManager or the sharedProdhuRequestOperationManager

#undef DEV

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
    
#ifdef DEV
    huRequestOperationManager = [HuHumansHTTPSessionManager sharedDevClient];
#else
    huRequestOperationManager = [HuHumansHTTPSessionManager sharedProdClient];
#endif
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


- (NSTimeInterval)lastPeekTimeFor:(HuHuman *)aHuman
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *lastPeeks = [[defaults objectForKey:@"lastPeeks"]mutableCopy];;
    //id foo = [lastPeeks objectForKey:[aHuman humanid]];
    NSNumber *time = [lastPeeks objectForKey:[aHuman humanid]];
    NSTimeInterval interval = [time longValue];
    double exp = log10(interval);
    if(exp < 10) {
        interval *= 1000;
    }
    
    return interval;
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


#pragma mark createNewUser
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
        
        //[Flurry logEvent:@"create-new-user" withParameters:dimensions];
        
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
    
}

#pragma mark userAddHuman
- (void)userAddHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    NSString *path = @"/rest/user/add/human";
    NSString *jsonRequest = [aHuman jsonString];
    NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    [huRequestOperationManager POST:path parameters:nil data:requestData success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dimensions = @{@"user": [[self humans_user]username], @"human-name": [aHuman name], @"success": @"YES"};
        //[Flurry logEvent:@"Added a human" withParameters:dimensions];
        [aHuman setHumanid:[responseObject objectForKey:@"human.id"]];
        [self userGettyUpdate:aHuman withCompletionHandler:nil];

        if(completionHandler) {
            completionHandler(true, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        NSDictionary *dimensions = @{@"user": [[self humans_user]username], @"human-name": [aHuman name], @"success": @"NO", @"error" : [error userInfo]};
        //[Flurry logEvent:@"Failed adding a human" withParameters:dimensions];
        
        if(completionHandler) {
            completionHandler(false, error);
        }
        
    }];
    
}

#pragma mark Basically login /oauth2/token?grant_typ
- (void)userRequestTokenForUsername:(NSString *)username forPassword:(NSString *)password withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    //LOG_ERROR(0, @"Hello %@ %@", username, password);
    NSString* buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CWBuildNumber"];
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    [huRequestOperationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    NSString *path =[NSString stringWithFormat:@"/oauth2/token"];
    NSDictionary *params = @{@"grant_type": @"password", @"client_id": CLIENT_NAME, @"build": buildNumber, @"ver": version};
    
    
    [huRequestOperationManager GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        LOG_NETWORK(0, @"Success %@", responseObject);
#pragma mark here's where we set the access token to live in the requestSerializer for this manager.. =============
        [self setAccess_token:[responseObject objectForKey:@"access_token"]];
        [huRequestOperationManager.requestSerializer setAuthorizationHeaderFieldWithToken:self.access_token];
        [self getHumansWithCompletionHandler:completionHandler];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Failure %@", error);
        //[Flurry logError:error.localizedDescription message:@"" error:error];
        
        [self setAccess_token:nil];
        if(completionHandler) {
            completionHandler(NO, error);
        }
        
        
    }];
    
}

- (HuHuman *)getYouman
{
    return [humans_user getYouman];
}


#pragma --- mark get the user's humans as well as the user's details, id, services, username, etc.

- (void)getHumansWithCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    [huRequestOperationManager GET:@"/rest/user/get" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        //[Flurry logEvent:[NSString stringWithFormat:@"Successful getHumansWithCompletion %@" , [humans_user username]]];
        
        humans_user = [[HuUser alloc]initWithJSONDictionary:responseObject];
        //[self makeYouman:nil];
        //LOG_GENERAL(0, @"%@", [humans_user dictionary]);
        if(completionHandler) {
            completionHandler(true, nil);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       // [Flurry logEvent:[NSString stringWithFormat:@"Failed getHumansWithCompletion %@" , [humans_user username]]];
        
        LOG_NETWORK(0, @"User Get Failed.. %@", error);
        LOG_NETWORK(0, @"%@", [error localizedDescription]);
        if(completionHandler) {
            completionHandler(false, error);
        }
        
    }];
}


#pragma mark /human/status/count
-(void)getStatusCountsWithCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    NSString *path =@"/rest/human/status/count";
    NSURLSessionDataTask *statusCountTask = [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            completionHandler(responseObject, true, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        //[Flurry logError:error.localizedDescription message:@"" error:error];
        
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
        //[Flurry logError:error.localizedDescription message:@"" error:error];
        
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

#pragma mark getty update Youman convenience /getty/update/{youman_humanid}
- (void)userGettyUpdateYoumanWithCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    HuHuman *youman = [self getYouman];
    if(youman != NULL) {
        [self userGettyUpdate:youman withCompletionHandler:completionHandler];
    } else {
        if(completionHandler) {
            NSError *error = [[NSError alloc]initWithDomain:@"" code:909 userInfo:@{@"message": @"There was a problem. You've got no youman."}];
            completionHandler(NO, error);
        }
    }
}

#pragma mark getty update /getty/update/{humanid}
- (void)userGettyUpdate:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    NSString *path = [NSString stringWithFormat:@"/rest/user/getty/update/%@", [aHuman humanid]];
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        LOG_TODO(0, @"%@", responseObject);
        if(completionHandler) {
            completionHandler(YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_ERROR(0, @"%@", error);
        if(completionHandler) {
            completionHandler(NO, error);
        }
        
    }];
  
}

#pragma mark getty update friends /getty/update/
- (void)userGettyUpdateFriends:(CompletionHandlerWithResult)completionHandler
{
    NSString *path = @"/rest/user/getty/update/friends";
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        LOG_TODO(0, @"%@", responseObject);
        if(completionHandler) {
            completionHandler(YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_ERROR(0, @"%@", error);
        if(completionHandler) {
            completionHandler(NO, error);
        }
        
    }];
    
    
}

#pragma mark Delete a service connection for a user
- (void)userRemoveService:(HuServices *)aService withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    //[Flurry logEvent:[NSString stringWithFormat:@"Attempting userRemoveService for %@", [aService description]]];
    
    NSString *path = @"/rest/user/rm/service";
    
    [huRequestOperationManager POST:path parameters:nil data:[aService json] success:^(NSURLSessionDataTask *task, id responseObject) {
       // [Flurry logEvent:[NSString stringWithFormat:@"Success for %@ response=%@", [aService description], responseObject]];
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
        
        //[Flurry logError:error.localizedDescription message:@"" error:error];
        if(completionHandler) {
            completionHandler(NO, error);
        }
        
        
    }];
}

#pragma mark add a bunch of service users /rest/human/{humanid}/add/serviceuser/ with JSON for all of the service users
- (void)humanAddServiceUsers:(NSArray *)arrayOfServiceUsers forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    [huRequestOperationManager humanAddServiceUsers:arrayOfServiceUsers forHuman:aHuman withProgress:nil withCompletionHandler:^(id data, BOOL success, NSError *error) {
        if(success) {
            [self userGettyUpdate:aHuman withCompletionHandler:nil];
            if(completionHandler) {
                completionHandler(data, YES, nil);
            }
        } else {
            if(completionHandler) {
                completionHandler(data, NO, error);
            }
        }
    }];
}

#pragma mark add a service user /rest/human/{humanid}/add/serviceuser/ with JSON for the service user
- (void)humanAddServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithData)completionHandler
{
    
    [huRequestOperationManager humanAddServiceUser:aServiceUser forHuman:aHuman withProgress:nil withCompletionHandler:^(id data, BOOL success, NSError *error) {
        if(success) {
            [self userGettyUpdate:aHuman withCompletionHandler:nil];
            if(completionHandler) {
                completionHandler(data, YES, nil);
            }
        } else {
            if(completionHandler) {
                completionHandler(data, NO, error);
            }
        }

    }];
}

#pragma mark remove a service user (someone as part of a human composite) by ID /rest/rm/{serviceuserid}/serviceuser
- (void)humanRemoveServiceUser:(HuServiceUser *)aServiceUser forHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    NSString *path = [NSString stringWithFormat:@"/rest/human/%@/rm/serviceuser/%@", [aHuman humanid], [aServiceUser id]];
    
    [huRequestOperationManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(completionHandler) {
            completionHandler(YES, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_NETWORK(0, @"Error: %@", error.localizedDescription);
        //[Flurry logError:error.localizedDescription message:@"" error:error];
        
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
        self.friends = result;
        if(completionHandler) {
            completionHandler(result);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //[Flurry logError:[error localizedDescription] message:[error description] error:error];
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
        //[Flurry logError:error.localizedDescription message:@"" error:error];
        
        [self setLastStatusResultHeader:nil];
        [[self statusForHumanId]removeObjectForKey:humanid];
        if(completionHandler) {
            completionHandler(false, error);
        }
        
    }];
}


+ (void)usernameExists:(NSString *)username withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    HuHumansHTTPSessionManager *mgr;
#ifdef DEV
    mgr = [HuHumansHTTPSessionManager sharedDevClient];
#else
    mgr = [HuHumansHTTPSessionManager sharedProdClient];
#endif
   
    __block bool exists = true;
    NSString *json = $str(@"{\"username\" : \"%@\"}", username);
    
    [mgr POST:@"/rest/user/username/exists" parameters:nil data:[json dataUsingEncoding:NSUTF8StringEncoding] success:^(NSURLSessionDataTask *task, id responseObject) {
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
    
    
    
}

- (void)usernameExists:(NSString *)username withCompletionHandler:(CompletionHandlerWithResult)completionHandler
{
    
    __block bool exists = true;
    NSString *json = $str(@"{\"username\" : \"%@\"}", username);
    
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
}

#pragma mark access token crap for a specific service. name the service and get the authentication parcel
// given a HuService this will try and get the access token particulars for that service + user

- (void)getAuthForService:(HuServices *)service with:(CompletionHandlerWithData)completionHandler
{
    
    NSString *path = [NSString stringWithFormat:@"/rest/user/get/auth/%@/%@", [service serviceName], [service serviceUserID]];
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
            //[Flurry logError:[ne reason] message:[ne reason] error:error];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LOG_GENERAL(0, @"Failure %@", error);
        if (completionHandler) {
            completionHandler(nil, NO, error);
        }
    }];
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



