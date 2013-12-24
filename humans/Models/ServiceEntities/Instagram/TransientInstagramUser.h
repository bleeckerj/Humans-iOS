//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramCounts;

@interface TransientInstagramUser : NSObject



@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) InstagramCounts *counts;
@property (strong, nonatomic) NSString *full_name;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *lastUpdated;
@property (strong, nonatomic) NSString *profile_picture;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSDecimalNumber *version;
@property (strong, nonatomic) NSString *website;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
