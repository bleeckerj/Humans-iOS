//
//  HuFlickrHTTPSessionManager.m
//  Pods
//
//  Created by Julian Bleecker on 3/30/14.
//
//

#import "HuFlickrServiceManager.h"
#import "HuFlickrStatus.h"
#import "HuAppDelegate.h"

@implementation HuFlickrServiceManager

NSString *consumer_key;
NSString *consumer_secret;

//+ (HuFlickrServiceManager *)sharedFlickrServiceManagerDerivedFromStatus:(HuFlickrStatus *)status
//{
//    static HuFlickrServiceManager *_sharedServiceManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedServiceManager = [[HuFlickrServiceManager alloc]init];
//        if(_sharedServiceManager != nil) {
//        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//        NSDictionary *auth_stuff = [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
//        NSString *token_key = [auth_stuff objectForKey:@"token_key"];
//        NSString *token_secret = [auth_stuff objectForKey:@"token_secret"];
//        consumer_key = [auth_stuff objectForKey:@"consumer_key"];
//        consumer_secret = [auth_stuff objectForKey:@"consumer_secret"];
//            flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:token_key sharedSecret:token_secret/* @"12b7b86e5c8ae218"*/];
//            [flickrContext setOAuthToken:consumer_key];
//            [flickrContext setOAuthTokenSecret:consumer_secret];
//            flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
//
////            flickr = [FlickrKit sharedFlickrKit];
////        [[FlickrKit sharedFlickrKit]initializeWithAPIKey:consumer_key sharedSecret:consumer_secret authToken:token_key authSecret:token_secret];
////            LOG_FLICKR(0, @"%@", [FlickrKit sharedFlickrKit]);
//        }
//        
//    });
//    return _sharedServiceManager;
//    
//}


- (id)initFor:(HuFlickrStatus *)status
{
    self = [super init];
    if(self) {
            HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            NSDictionary *auth_stuff = [[delegate humansAppUser]getAuthForService:[status status_on_behalf_of]];
            NSString *token_key = [auth_stuff objectForKey:@"token_key"];
            NSString *token_secret = [auth_stuff objectForKey:@"token_secret"];
            consumer_key = [auth_stuff objectForKey:@"consumer_key"];
            consumer_secret = [auth_stuff objectForKey:@"consumer_secret"];
        // @"12b7b86e5c8ae218" <-- consumer_secret
        flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:consumer_key sharedSecret:consumer_secret];
        [flickrContext setOAuthToken:token_key];
        [flickrContext setOAuthTokenSecret:token_secret];
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
        [flickrRequest setDelegate:self];
        
//        flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:@"149460e530f15612b81b733a5f9c9ffd" sharedSecret:@"12b7b86e5c8ae218"];
//        [flickrContext setOAuthToken:@"72157636317942405-8ea8cb5de002a305"];
//        [flickrContext setOAuthTokenSecret:@"3671be40d4b0a0db"];
//        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
//        [flickrRequest setDelegate:self];
        //[self nextRandomPhotoAction:self];
        
    }
    return self;
 
}


- (void)like:(HuFlickrStatus *)status
{
    
    if (![flickrRequest isRunning]) {
        [HuAppDelegate popGoodToastNotification:@"Like That" withColor:[UIColor FlickrBlue]];
		//[flickrRequest callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"per_page", nil]];
        [flickrRequest callAPIMethodWithGET:@"flickr.favorites.add" arguments:@{@"photo_id": [status flickr_id]}];
	} else {
        [HuAppDelegate popBadToastNotification:@"Wait a moment" withSubnotice:@"Try again in a moment"];
    }

}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    LOG_FLICKR(0, @"error=%@", inError);
    [HuAppDelegate popBadToastNotification:@"Shrug" withSubnotice:[inError localizedFailureReason] ];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    LOG_FLICKR(0, @"response %@", inResponseDictionary);
}






@end
