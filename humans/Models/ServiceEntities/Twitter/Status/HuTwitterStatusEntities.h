//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;
@class NSArray;
@class NSArray;
@class NSArray;
@class NSArray;

@interface HuTwitterStatusEntities : NSObject



@property (strong, nonatomic) NSArray *hashtags;
@property (strong, nonatomic) NSArray *symbols;
@property (strong, nonatomic) NSArray *urls;
@property (strong, nonatomic) NSArray *user_mentions;
@property (strong, nonatomic) NSArray *media;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
