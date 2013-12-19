//
//  HuHumansHTTPClient.h
//  humans
//
//  Created by julian on 12/16/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//
#import "AFHTTPClient.h"


@interface HuHumansHTTPClient : AFHTTPClient

+(HuHumansHTTPClient *)sharedDevClient;
+(HuHumansHTTPClient *)sharedProdClient;


@end
