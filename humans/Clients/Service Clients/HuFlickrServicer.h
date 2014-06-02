//
//  HuFlickrServicer.h
//  humans
//
//  Created by Julian Bleecker on 6/1/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <ObjectiveFlickr/ObjectiveFlickr.h>

@interface HuFlickrServicer : NSObject <OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIContext *flickrContext;
    OFFlickrAPIRequest *flickrRequest;
}

- (void)like;

@end
