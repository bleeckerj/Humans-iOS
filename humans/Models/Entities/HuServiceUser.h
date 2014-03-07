//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuFriend.h"

@class HuFriend;
@class HuOnBehalfOf;

@interface HuServiceUser : NSObject
- (id) initWithFriend:(HuFriend *)aFriend;



@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *lastUpdated;
@property (strong, nonatomic) HuOnBehalfOf *onBehalfOf;
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSString *serviceUserID;
@property (strong, nonatomic) NSString *username;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
-(NSString *)jsonString;

- (NSDictionary *)dictionary;
@end
