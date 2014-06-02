//
//  HuFlickrHTTPSessionManager.h
//  Pods
//
//  Created by Julian Bleecker on 3/30/14.
//
//
#import <ObjectiveFlickr/ObjectiveFlickr.h>

@class HuFlickrStatus;

@interface HuFlickrServiceManager : NSObject <OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
}
- (id)initFor:(HuFlickrStatus *)status; 
- (void)like:(HuFlickrStatus *)status;


@end
