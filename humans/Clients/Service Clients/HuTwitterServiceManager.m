//
//  HuTwitterHTTPSessionManager.m
//  humans
//
//  Created by Julian Bleecker on 5/28/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//
#import "defines.h"
#import "HuTwitterServiceManager.h"
#import "HuTwitterStatus.h"
#import "HuAppDelegate.h"
#import <STTwitterAPI.h>

@interface HuTwitterServiceManager()


@end

static NSMutableDictionary *cache;

@implementation HuTwitterServiceManager
STTwitterAPI *twitter;

- (id)init
{
    self = [super init];
    if(self) {
        cache = NSMutableDictionary.new;
    }
    return self;
}


+ (void)initialize {
    if (self == [HuTwitterServiceManager class]) {
        // do whatever
        cache = NSMutableDictionary.new;
    }
}

//static NSString * const kTwitterAPIBaseURLString = @"https://api.twitter.com/1.1/";
//
//+ (HuTwitterServiceManager *)sharedTwitterClientWithOAuthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret oauthToken:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret {
//    static HuTwitterServiceManager *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedClient = [STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerKey consumerSecret:consumerSecret oauthToken:oauthToken  oauthTokenSecret:oauthSecret ];
//        //_sharedClient = [[HuTwitterHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kTwitterAPIBaseURLString]];
//        //[_sharedClient.reachabilityManager startMonitoring];
//    });
//    
//    return _sharedClient;
//}

+ (HuTwitterServiceManager *)sharedTwitterClientOnBehalfOf:(HuOnBehalfOf *)onBehalfOf
{
    static HuTwitterServiceManager *_sharedClient;
    if(cache) {
        _sharedClient = [cache objectForKey:onBehalfOf];
        if(_sharedClient == nil) {
            HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            NSDictionary *auth_stuff = [[delegate humansAppUser]getAuthForService:onBehalfOf];
            NSString *token_key = [auth_stuff objectForKey:@"token_key"];
            NSString *token_secret = [auth_stuff objectForKey:@"token_secret"];
            NSString *consumer_key = [auth_stuff objectForKey:@"consumer_key"];
            NSString *consumer_secret = [auth_stuff objectForKey:@"consumer_secret"];
            STTwitterAPI *_twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:consumer_key consumerSecret:consumer_secret oauthToken:token_key  oauthTokenSecret:token_secret ];
            _sharedClient = [[HuTwitterServiceManager alloc ]initWithOAuthConsumerKey:consumer_key consumerSecret:consumer_secret oauthToken:token_key oauthSecret:token_secret];
            _sharedClient.twitter = _twitter;
            [cache setObject:_sharedClient forKey:onBehalfOf removeAfter:30*60];
        }
    }
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
   // });
    return _sharedClient;
}



+ (HuTwitterServiceManager *)sharedTwitterClientDerivedFromStatus:(HuTwitterStatus *)status
{
    static HuTwitterServiceManager *_sharedClient = nil;
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSDictionary *auth_stuff = [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
    NSString *token_key = [auth_stuff objectForKey:@"token_key"];
    NSString *token_secret = [auth_stuff objectForKey:@"token_secret"];
    NSString *consumer_key = [auth_stuff objectForKey:@"consumer_key"];
    NSString *consumer_secret = [auth_stuff objectForKey:@"consumer_secret"];
    twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:consumer_key consumerSecret:consumer_secret oauthToken:token_key  oauthTokenSecret:token_secret ];
    //});
    return _sharedClient;
}


- (id)initWithOAuthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret oauthToken:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret {
    self = [super init];
    if(self) {
        twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerKey consumerSecret:consumerSecret oauthToken:oauthToken  oauthTokenSecret:oauthSecret ];
    }
    return self;
    
}

//- (id)initWithBaseURL:(NSURL *)url withAccessDictionary:(NSDictionary *)accessParameters{
//    self = [super initWithBaseURL:url];
//    if (!self) {
//        return nil;
//    }
//    AFCompoundResponseSerializer *c = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[ [AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer] ]];
//    
//    [self setResponseSerializer:c];
//    return self;
//}

//@"consumer_key", consumer_secret, @"consumer_secret", token_key, @"token_key", token_secret, @"token_secret"
- (void)like:(HuTwitterStatus*)status
{
    [HuAppDelegate popGoodToastNotification:@"Like That" withColor:[UIColor Twitter]];
    
    __block HuTwitterStatus *bstatus = status;
    if([status favorited] == NO) {
        [twitter postFavoriteCreateWithStatusID:[[status tweet_id]stringValue] includeEntities:@0 successBlock:^(NSDictionary *status) {
            //
            [bstatus setFavorited:YES];
            NSLog(@"success %@", status);
        } errorBlock:^(NSError *error) {
            //
            NSLog(@"error %@", error);
        }];
    }
}

- (void)retweet:(HuTwitterStatus*)status
{
    HuOnBehalfOf *onBehalfOf = [status status_on_behalf_of];
    NSString *str = [NSString stringWithFormat:@"Retweet That %@", [onBehalfOf serviceUsername]];
    [HuAppDelegate popGoodToastNotification:str withColor:[UIColor Twitter]];
    
    __block HuTwitterStatus *bstatus = status;
    if([status retweeted] == NO) {
        [twitter postStatusRetweetWithID:[[status tweet_id]stringValue] trimUser:@1 successBlock:^(NSDictionary *status) {
            //
            [bstatus setRetweeted:YES];
            NSLog(@"success %@", status);

        } errorBlock:^(NSError *error) {
            //
            NSLog(@"error %@", error);
            [HuAppDelegate popBadToastNotification:@"Woops." withSubnotice:[error localizedDescription]];
            
        }];
        
        
        [twitter postFavoriteCreateWithStatusID:[[status tweet_id]stringValue] includeEntities:@0 successBlock:^(NSDictionary *status) {
            //
            [bstatus setFavorited:YES];
            NSLog(@"success %@", status);
        } errorBlock:^(NSError *error) {
            //
            NSLog(@"error %@", error);
        }];
    }
 
}

// recursively go back and get all the statuses to which this statusID is in reply (to)
- (void)getStatus:(NSString *)statusID withStatuses:(NSArray *)statuses withCompletion:(CompletionHandlerWithData)completion
{
    [twitter getStatusesShowID:statusID trimUser:@0 includeMyRetweet:@0 includeEntities:@1 successBlock:^(NSDictionary *result) {
        //
        HuTwitterStatus *status = [[HuTwitterStatus alloc]initWithJSONDictionary:result];
        if(status && [status in_reply_to_status_id] != nil) {
            NSMutableArray *x = NSMutableArray.new;
            [x addObjectsFromArray:statuses];
            [x addObject:status];
            [self getStatus:[status in_reply_to_status_id] withStatuses:x withCompletion:completion];
        } else {
        //NSString *statusText = [status text];
        
        if(completion) {
            completion(statuses, YES, nil);
        }
        }
    } errorBlock:^(NSError *error) {
        //
        if(completion) {
            completion(nil, NO, error);
        }
        
    }];
}


@end
