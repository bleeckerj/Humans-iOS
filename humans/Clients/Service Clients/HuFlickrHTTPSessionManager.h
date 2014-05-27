//
//  HuFlickrHTTPSessionManager.h
//  Pods
//
//  Created by Julian Bleecker on 3/30/14.
//
//

#import "AFHTTPSessionManager.h"

@interface HuFlickrHTTPSessionManager : AFHTTPSessionManager
+(HuFlickrHTTPSessionManager *)sharedFlickrClient;

@end
