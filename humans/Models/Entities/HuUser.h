//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;
@class NSArray;

@interface HuUser : NSObject



@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSArray *humans;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSArray *services;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSDecimalNumber *version;
@property (strong, nonatomic) NSNumber *isAdmin;
@property (strong, nonatomic) NSNumber *isSuperuser;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
-(NSDictionary *)dictionary;
- (NSDictionary *)proxyForJson;
- (Boolean)amSuperuser;
- (Boolean)amAdmin;
@end
