//
//  TwitterStatus.m
//  CocoaPodsExample
//
//  Created by julian on 12/11/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "TwitterStatus.h"
#import "defines.h"

@implementation TwitterStatus
@synthesize tweet_id;
@synthesize text;
//@synthesize user_id;
@synthesize created_at;
//@synthesize name;
@synthesize user;

// HuServiceStatus things
@synthesize hasBeenRead;
@synthesize doNotShow;
@synthesize serviceSolidColor;
@synthesize serviceUsername;
@synthesize statusText;
@synthesize statusTime;

-(NSURL *)userProfileImageURL
{
    NSURL *result = nil;
    result = [NSURL URLWithString:[self.user profile_image_url]];
    return result;
}

-(UIColor *)serviceSolidColor
{
    return [UIColor blueColor];
}

-(NSString *)serviceUsername
{
    return [user screen_name];
}

-(NSString *)tinyMonochromeServiceImageBadgeName
{
    return @"twitter-bird-white-tiny.png";
}

-(NSString *)statusText
{
    return text;//[self statusTextNoURL];
}

-(NSTimeInterval)statusTime
{
    return [[self created_at]timeIntervalSince1970];
}

-(NSDate *)dateForSorting
{
    if (created_at == nil) {
        created_at = [NSDate dateWithTimeIntervalSince1970:6000];
        LOG_ERROR(0, @"Something happened with the date format parsing for %@ %@", self, [self statusText]);
    }
    return [self created_at];
}

-(NSUInteger)hash
{
    return [[self tweet_id]hash];
}

-(BOOL)isEqual:(id)object
{
    if(NO == [object isKindOfClass:[TwitterStatus class]]) {
        return NO;
    }
    if([object hash] == [self hash]) {
        return YES;
    }
    return NO;
}

// TODO This does not work if there are more than one URLs in the status, I think..
#warning This does not work if there are more than one URLs in the status, I think..
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


-(NSTimeInterval)timeIntervalSince1970ForSorting {
    return [self statusTime];
}

@end
