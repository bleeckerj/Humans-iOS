//
//  NSURLRequest+NSURLRequestIgnoreSSL.m
//  humans
//
//  Created by Julian Bleecker on 5/30/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "NSURLRequest+NSURLRequestIgnoreSSL.h"

@implementation NSURLRequest (NSURLRequestIgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
