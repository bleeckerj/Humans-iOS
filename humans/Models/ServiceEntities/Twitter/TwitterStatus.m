//
//  TwitterStatus.m
//  CocoaPodsExample
//
//  Created by julian on 12/11/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "TwitterStatus.h"

@implementation TwitterStatus
@synthesize tweet_id;
@synthesize text;
//@synthesize user_id;
@synthesize created_at;
//@synthesize name;
@synthesize user;

-(NSString *)statusTextNoURL
{
    if(self.text && (self.text.length > 20)) {
        NSRange r = {[self.text length]-20, 20};
        NSRange w;
        //                @try {
        w = [self.text rangeOfString:@"http://t.co" options:NSCaseInsensitiveSearch range:r];
        //                } @catch (NSException *nre) {
        //                    iOSSLog(@"%@", nre);
        //                }
        
        if(w.location != NSNotFound) {
            self.statusTextNoURL = [self.text substringToIndex:w.location-1];
        } else {
            self.statusTextNoURL = self.text;
        }
        //iOSSLog(@"%d %d %d %d %d %@ [%@]", r.length, r.location, w.location, w.length, self.statusText.length, self.statusText, self.statusTextNoURL);
        
    } else {
        self.statusTextNoURL = self.text;
    }
    return self.statusTextNoURL;
}

- (NSTimeInterval)statusTime
{
    return 0;
    //return [self.created_at timeIntervalSince1970];
}

- (NSDate *)dateForSorting
{
    NSDate *result;
    result = [[NSDate alloc]initWithTimeIntervalSince1970:[self statusTime]];
    return result;
}

-(NSTimeInterval)timeIntervalSince1970ForSorting {
    return [self statusTime];
}

@end
