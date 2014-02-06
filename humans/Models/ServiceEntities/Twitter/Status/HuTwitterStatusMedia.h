//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;
@class NSArray;

@interface HuTwitterStatusMedia : NSObject



@property (strong, nonatomic) NSDecimalNumber *id;
@property (strong, nonatomic) NSString *id_str;
@property (strong, nonatomic) NSArray *indices;
@property (strong, nonatomic) NSString *media_url;
@property (strong, nonatomic) NSString *media_url_https;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *display_url;
@property (strong, nonatomic) NSString *expanded_url;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *sizes;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
