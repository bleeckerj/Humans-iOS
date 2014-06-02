
//
//  HuFlickrServicer.m
//  humans
//
//  Created by Julian Bleecker on 6/1/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuFlickrServicer.h"

@implementation HuFlickrServicer 

- (id)init
{
    self = [super init];
    if(self) {
        flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:@"149460e530f15612b81b733a5f9c9ffd" sharedSecret:@"12b7b86e5c8ae218"];
        [flickrContext setOAuthToken:@"72157636317942405-8ea8cb5de002a305"];
        [flickrContext setOAuthTokenSecret:@"3671be40d4b0a0db"];
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
        [flickrRequest setDelegate:self];
    }
    return self;
}

- (void)like
{
    
    if (![flickrRequest isRunning]) {
   
        BOOL result = [flickrRequest callAPIMethodWithGET:@"flickr.favorites.add" arguments:@{@"photo_id": @"14319951542"}];
        NSLog(@"%d", result);
   
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"Hello?");
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"Bye bye?");

}

@end
